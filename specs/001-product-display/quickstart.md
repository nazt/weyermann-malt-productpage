# Quickstart: Product Display Page

**Feature**: 001-product-display
**Date**: 2025-11-30

## Prerequisites

- Modern web browser (Chrome, Firefox, Safari, Edge)
- Local web server (for JSON loading due to CORS)

## Quick Start

### Option 1: Python HTTP Server (Recommended)

```bash
# Navigate to project root
cd /path/to/000-workshop-product-page

# Start server
python3 -m http.server 8000

# Open browser
open http://localhost:8000
```

### Option 2: Node.js HTTP Server

```bash
# Install if needed
npm install -g http-server

# Start server
http-server -p 8000

# Open browser
open http://localhost:8000
```

### Option 3: VS Code Live Server

1. Install "Live Server" extension
2. Right-click `index.html`
3. Select "Open with Live Server"

## Project Structure

```
000-workshop-product-page/
├── index.html          # Main page
├── css/
│   └── styles.css      # All styles
├── js/
│   └── app.js          # Product loading & rendering
├── products.json       # Product data
└── specs/              # Documentation
```

## Development Workflow

1. Edit HTML/CSS/JS files
2. Refresh browser to see changes
3. Check browser console for errors
4. Test on mobile using browser dev tools

## Testing Checklist

- [ ] Page loads without console errors
- [ ] All 17 categories visible
- [ ] Products display with correct prices
- [ ] "N/A" shows for missing prices
- [ ] Mobile responsive (320px width)
- [ ] Keyboard navigation works

## Troubleshooting

### JSON not loading

**Symptom**: Products don't appear, console shows CORS error

**Solution**: Use a local web server (see Quick Start options above). Opening `index.html` directly in browser won't work due to CORS restrictions on `file://` protocol.

### Prices showing wrong format

**Symptom**: Numbers display without proper formatting

**Solution**: Check that `Intl.NumberFormat` is used in `app.js`

### Mobile layout broken

**Symptom**: Horizontal scroll on mobile

**Solution**: Check CSS media queries and ensure no fixed widths exceed viewport
