# Research: Product Display Page

**Feature**: 001-product-display
**Date**: 2025-11-30

## Technical Decisions

### 1. Data Loading Approach

**Decision**: Use `fetch()` API to load products.json at runtime

**Rationale**:
- Native browser API, no dependencies
- Async loading keeps page responsive
- Works with static file hosting

**Alternatives considered**:
- Embed JSON in HTML: Rejected (harder to maintain, larger initial HTML)
- Server-side rendering: Rejected (requires backend, violates static-only constraint)

### 2. Rendering Strategy

**Decision**: JavaScript DOM manipulation to build product tables

**Rationale**:
- Simple, no templating library needed
- Full control over HTML structure
- Easy to add accessibility attributes

**Alternatives considered**:
- Template literals in JS: Will use this within the DOM approach
- Pre-rendered static HTML: Rejected (60+ products would be hard to maintain)

### 3. CSS Architecture

**Decision**: Mobile-first single CSS file with CSS custom properties

**Rationale**:
- No build step required
- Custom properties for consistent theming
- Media queries for responsive breakpoints

**Alternatives considered**:
- CSS-in-JS: Rejected (requires framework)
- Multiple CSS files: Rejected (unnecessary complexity for single page)

### 4. Layout Pattern

**Decision**: CSS Grid for category/product tables, Flexbox for header

**Rationale**:
- Grid perfect for tabular product data
- Native browser support, no polyfills needed
- Responsive without JavaScript

**Alternatives considered**:
- HTML tables: Could work but less flexible for mobile
- Flexbox only: Grid is better for 2D layouts

### 5. Price Formatting

**Decision**: `Intl.NumberFormat` for Thai Baht formatting

**Rationale**:
- Native browser API
- Handles locale-specific formatting
- Consistent decimal places

**Alternatives considered**:
- Manual string formatting: More error-prone
- External library: Unnecessary dependency

## Browser Support

**Target**: Modern browsers (last 2 versions)
- Chrome 90+
- Safari 14+
- Firefox 88+
- Edge 90+

All features used (fetch, CSS Grid, CSS Custom Properties, ES6) are supported.

## Performance Strategy

1. **Minimal HTTP requests**: 1 HTML + 1 CSS + 1 JS + 1 JSON = 4 requests
2. **No images initially**: Product page is text-based price list
3. **Async data loading**: Show loading state, then render
4. **CSS-based responsive**: No JS resize handlers

## Accessibility Strategy

1. **Semantic HTML**: `<header>`, `<main>`, `<section>`, `<table>`
2. **Heading hierarchy**: h1 (company) → h2 (category) → table headers
3. **ARIA labels**: For interactive elements if any
4. **Color contrast**: Meet WCAG AA (4.5:1 for text)
5. **Keyboard navigation**: Native focus handling

## No Unresolved Items

All technical decisions made. Ready for Phase 1 design.
