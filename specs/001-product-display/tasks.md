# Tasks: Product Display Page

**Input**: Design documents from `/specs/001-product-display/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Tests**: No automated tests requested. Manual browser testing per constitution.

**Organization**: Tasks grouped by user story for independent implementation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- File paths relative to repository root

## Path Conventions

```text
index.html               # Main HTML file
css/styles.css           # All styles
js/app.js               # JavaScript logic
products.json            # Data (exists)
```

---

## Phase 1: Setup

**Purpose**: Create project structure and base files

- [x] T001 Create css/ directory at repository root
- [x] T002 Create js/ directory at repository root
- [x] T003 [P] Create empty css/styles.css file
- [x] T004 [P] Create empty js/app.js file
- [x] T005 Create index.html with HTML5 boilerplate in repository root

**Checkpoint**: Project structure ready for development

---

## Phase 2: Foundational (HTML Structure)

**Purpose**: Base HTML that all user stories depend on

**⚠️ CRITICAL**: Complete before user story implementation

- [x] T006 Add semantic header section with company name and subtitle in index.html
- [x] T007 Add main content area with product container in index.html
- [x] T008 Add footer with exchange rate note and price validity in index.html
- [x] T009 Link css/styles.css in index.html head
- [x] T010 Link js/app.js at end of body in index.html

**Checkpoint**: HTML skeleton ready - user stories can begin

---

## Phase 3: User Story 1 - Browse All Products (Priority: P1) 🎯 MVP

**Goal**: Display all 17 categories and 60+ products from products.json

**Independent Test**: Open page in browser, verify all categories and products visible

### Implementation for User Story 1

- [x] T011 [US1] Implement fetch() to load products.json in js/app.js
- [x] T012 [US1] Implement renderCategories() function to create category sections in js/app.js
- [x] T013 [US1] Implement renderProducts() function to create product rows in js/app.js
- [x] T014 [US1] Add loading state display while fetching data in js/app.js
- [x] T015 [US1] Add error handling for failed JSON fetch in js/app.js
- [x] T016 [P] [US1] Add base typography styles (font-family, sizes) in css/styles.css
- [x] T017 [P] [US1] Add header styling in css/styles.css
- [x] T018 [P] [US1] Add category section styling in css/styles.css
- [x] T019 [P] [US1] Add product table/grid layout in css/styles.css

**Checkpoint**: All products display correctly - MVP complete

---

## Phase 4: User Story 2 - View Product Pricing Details (Priority: P2)

**Goal**: Display prices with proper formatting, handle null prices and availability

**Independent Test**: Verify prices show THB format, N/A for nulls, availability messages

### Implementation for User Story 2

- [x] T020 [US2] Implement formatPrice() using Intl.NumberFormat for THB in js/app.js
- [x] T021 [US2] Add logic to display "N/A" for null prices in js/app.js
- [x] T022 [US2] Add logic to display availability message when present in js/app.js
- [x] T023 [P] [US2] Style price columns with proper alignment in css/styles.css
- [x] T024 [P] [US2] Style N/A and availability text differently in css/styles.css

**Checkpoint**: All pricing displays correctly with proper formatting

---

## Phase 5: User Story 3 - Mobile-Friendly Browsing (Priority: P3)

**Goal**: Responsive layout working from 320px to 1920px

**Independent Test**: Test page at 320px, 768px, 1024px widths - no horizontal scroll

### Implementation for User Story 3

- [x] T025 [US3] Add viewport meta tag in index.html head
- [x] T026 [US3] Add mobile-first base styles in css/styles.css
- [x] T027 [US3] Add media query for tablet (768px+) in css/styles.css
- [x] T028 [US3] Add media query for desktop (1024px+) in css/styles.css
- [x] T029 [US3] Ensure tables/grids adapt to narrow screens in css/styles.css

**Checkpoint**: Page fully responsive across all device sizes

---

## Phase 6: Polish & Accessibility

**Purpose**: Final improvements and accessibility compliance

- [x] T030 Add proper heading hierarchy (h1, h2, h3) in index.html
- [x] T031 Add ARIA labels where needed in index.html
- [x] T032 Ensure color contrast meets WCAG AA (4.5:1) in css/styles.css
- [x] T033 Add focus styles for keyboard navigation in css/styles.css
- [x] T034 Run manual browser testing (Chrome, Safari, Firefox)
- [x] T035 Validate against quickstart.md checklist

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Phase 2
- **User Story 2 (Phase 4)**: Depends on Phase 3 (needs renderProducts in place)
- **User Story 3 (Phase 5)**: Can start after Phase 2 (CSS is independent)
- **Polish (Phase 6)**: After all user stories complete

### User Story Dependencies

- **US1 (P1)**: Core display - must complete first
- **US2 (P2)**: Enhances US1 - depends on render functions existing
- **US3 (P3)**: CSS-only - can work in parallel with US2

### Within Each Phase

- Tasks marked [P] can run in parallel
- Sequential tasks must complete in order

### Parallel Opportunities

```bash
# Phase 1 - T003 and T004 parallel:
T003: "Create empty css/styles.css"
T004: "Create empty js/app.js"

# Phase 3 - CSS tasks parallel:
T016: "Add base typography styles"
T017: "Add header styling"
T018: "Add category section styling"
T019: "Add product table/grid layout"

# Phase 4 - CSS tasks parallel:
T023: "Style price columns"
T024: "Style N/A and availability text"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (5 tasks)
2. Complete Phase 2: Foundational (5 tasks)
3. Complete Phase 3: User Story 1 (9 tasks)
4. **STOP and VALIDATE**: Open in browser, verify products display
5. Can demo/deploy at this point

### Incremental Delivery

1. Setup + Foundational → Structure ready
2. User Story 1 → Products visible (MVP!)
3. User Story 2 → Prices formatted correctly
4. User Story 3 → Mobile responsive
5. Polish → Accessibility compliant

### Suggested MVP Scope

**MVP = Phases 1-3 (19 tasks)**
- Basic product display working
- All categories and products visible
- Can be tested and demonstrated

---

## Notes

- Total tasks: 35
- Phase 1 (Setup): 5 tasks
- Phase 2 (Foundational): 5 tasks
- Phase 3 (US1): 9 tasks
- Phase 4 (US2): 5 tasks
- Phase 5 (US3): 5 tasks
- Phase 6 (Polish): 6 tasks
- Parallel opportunities: 10 tasks marked [P]
- No automated tests - manual browser testing only
