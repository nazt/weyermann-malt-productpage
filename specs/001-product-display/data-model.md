# Data Model: Product Display Page

**Feature**: 001-product-display
**Date**: 2025-11-30

## Source Data Structure

Data is loaded from `products.json` in the repository root.

## Entities

### ProductCatalog (Root)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| company | string | Yes | Company name ("Weyermann Specialty Malts") |
| subtitle | string | Yes | Tagline ("Brewery & Distillery Products") |
| currency | string | Yes | Price currency code ("THB") |
| exchange_note | string | Yes | Exchange rate disclaimer |
| price_valid | string | Yes | Price validity period |
| categories | Category[] | Yes | List of product categories |

### Category

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Category name (e.g., "Brew Malts") |
| note | string | No | Optional category note (e.g., size info) |
| products | Product[] | Yes | List of products in this category |

### Product

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Product name |
| price_5kg | number \| null | No | Price for 5kg package in THB |
| price_25kg | number \| null | No | Price for 25kg package in THB |
| availability | string | No | Availability message (if no price) |
| note | string | No | Additional product notes |

## Display Rules

### Price Display Logic

```
IF price_5kg is not null:
  Display formatted price (e.g., "481.50")
ELSE:
  Display "N/A"

IF price_25kg is not null:
  Display formatted price
ELSE:
  Display "N/A"

IF availability field exists:
  Display availability message instead of prices
```

### Category Display Order

Categories are displayed in the order they appear in the JSON array (preserve source order).

### Number Formatting

- Currency: THB (Thai Baht)
- Decimal places: 2
- Thousands separator: comma (1,234.56)
- Example: 2,006.25

## Validation Rules

| Rule | Validation |
|------|------------|
| Category must have name | name.length > 0 |
| Category must have products | products.length > 0 |
| Product must have name | name.length > 0 |
| Price must be positive if present | price > 0 when not null |

## State Transitions

This is a read-only display. No state transitions or user modifications.

| State | Description |
|-------|-------------|
| Loading | Initial state while fetching JSON |
| Loaded | Data successfully parsed and displayed |
| Error | Failed to load or parse JSON |
