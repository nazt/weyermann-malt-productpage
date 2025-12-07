#!/bin/bash
# Central Inbox System for Multi-Agent Communication
# Usage: source scripts/inbox.sh

INBOX_DIR="${INBOX_DIR:-.tmp/inbox}"

# Ensure directories exist
inbox_init() {
    mkdir -p "$INBOX_DIR"/{incoming/.tmp,processing,done,dead-letter}
}

# Write a message to the inbox (atomic)
# Usage: inbox_write <sender> <type> <content>
inbox_write() {
    local sender="${1:-unknown}"
    local type="${2:-message}"
    local content="${3:-}"
    local timestamp=$(date -u +%Y%m%d%H%M%S)
    local uuid=$(uuidgen 2>/dev/null || echo "$$-$RANDOM")
    local msg_id="${timestamp}-${sender}-${uuid:0:8}"

    inbox_init

    # Create JSON message
    local json=$(cat <<EOF
{
  "id": "$msg_id",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "sender": "$sender",
  "type": "$type",
  "content": "$content",
  "attempts": 0
}
EOF
)

    # Atomic write: temp file + rename
    local tmp_file="$INBOX_DIR/incoming/.tmp/$msg_id.json"
    local final_file="$INBOX_DIR/incoming/$msg_id.json"

    echo "$json" > "$tmp_file"
    sync "$tmp_file" 2>/dev/null || true
    mv "$tmp_file" "$final_file"

    echo "$msg_id"
}

# List pending messages
# Usage: inbox_list
inbox_list() {
    ls -1 "$INBOX_DIR/incoming/"*.json 2>/dev/null | xargs -I{} basename {} .json
}

# Claim a message for processing (atomic)
# Usage: inbox_claim <msg_id>
inbox_claim() {
    local msg_id="$1"
    local src="$INBOX_DIR/incoming/${msg_id}.json"
    local dst="$INBOX_DIR/processing/${msg_id}.json"

    if [ -f "$src" ]; then
        mv "$src" "$dst" 2>/dev/null && echo "$dst" || echo ""
    fi
}

# Read message content
# Usage: inbox_read <msg_file>
inbox_read() {
    local file="$1"
    if [ -f "$file" ]; then
        cat "$file"
    fi
}

# Complete a message (move to done)
# Usage: inbox_complete <msg_id>
inbox_complete() {
    local msg_id="$1"
    local src="$INBOX_DIR/processing/${msg_id}.json"
    local dst="$INBOX_DIR/done/${msg_id}.json"

    [ -f "$src" ] && mv "$src" "$dst"
}

# Fail a message (move to dead-letter)
# Usage: inbox_fail <msg_id>
inbox_fail() {
    local msg_id="$1"
    local src="$INBOX_DIR/processing/${msg_id}.json"
    local dst="$INBOX_DIR/dead-letter/${msg_id}.json"

    [ -f "$src" ] && mv "$src" "$dst"
}

# Process all pending messages
# Usage: inbox_process <handler_function>
inbox_process() {
    local handler="${1:-echo}"

    for msg_file in "$INBOX_DIR/incoming/"*.json; do
        [ -f "$msg_file" ] || continue

        local msg_id=$(basename "$msg_file" .json)
        local claimed=$(inbox_claim "$msg_id")

        if [ -n "$claimed" ]; then
            local content=$(inbox_read "$claimed")
            if $handler "$content"; then
                inbox_complete "$msg_id"
            else
                inbox_fail "$msg_id"
            fi
        fi
    done
}

# Poll inbox until message arrives or timeout
# Usage: inbox_poll [timeout_seconds]
inbox_poll() {
    local timeout="${1:-30}"
    local count=0
    local interval=0.1
    local max=$((timeout * 10))

    while [ $count -lt $max ]; do
        local msgs=$(ls -1 "$INBOX_DIR/incoming/"*.json 2>/dev/null | wc -l)
        if [ "$msgs" -gt 0 ]; then
            inbox_list
            return 0
        fi
        sleep $interval
        count=$((count + 1))
    done
    return 1
}

# Cleanup old messages
# Usage: inbox_cleanup [minutes]
inbox_cleanup() {
    local mins="${1:-30}"
    find "$INBOX_DIR/done" -type f -mmin +"$mins" -delete 2>/dev/null
    find "$INBOX_DIR/dead-letter" -type f -mmin +"$mins" -delete 2>/dev/null
}

# Status summary
inbox_status() {
    local incoming=$(ls -1 "$INBOX_DIR/incoming/"*.json 2>/dev/null | wc -l)
    local processing=$(ls -1 "$INBOX_DIR/processing/"*.json 2>/dev/null | wc -l)
    local done=$(ls -1 "$INBOX_DIR/done/"*.json 2>/dev/null | wc -l)
    local dead=$(ls -1 "$INBOX_DIR/dead-letter/"*.json 2>/dev/null | wc -l)

    echo "📬 Inbox Status:"
    echo "   Incoming:    $incoming"
    echo "   Processing:  $processing"
    echo "   Done:        $done"
    echo "   Dead-letter: $dead"
}
