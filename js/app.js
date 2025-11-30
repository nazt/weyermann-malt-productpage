// Product Display Page - JavaScript

// State
let catalogData = null;
let isLoading = false;
let isError = false;

// Format price using Intl.NumberFormat for Thai Baht
function formatPrice(price) {
  if (price === null || price === undefined) {
    return "N/A";
  }
  return new Intl.NumberFormat("en-US", {
    style: "decimal",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(price);
}

// Render category sections and products
function renderCategories(data) {
  const main = document.querySelector("main");

  // Clear existing content
  const existingSections = main.querySelectorAll("section");
  existingSections.forEach((section) => section.remove());

  // Render each category
  data.categories.forEach((category) => {
    const section = document.createElement("section");
    section.innerHTML = "";

    // Category heading
    const heading = document.createElement("h2");
    heading.textContent = category.name;
    section.appendChild(heading);

    // Optional category note
    if (category.note) {
      const note = document.createElement("p");
      note.className = "category-note";
      note.textContent = category.note;
      section.appendChild(note);
    }

    // Product table
    const table = document.createElement("table");
    table.className = "product-table";

    // Table header
    const thead = document.createElement("thead");
    const headerRow = document.createElement("tr");
    headerRow.innerHTML = `
      <th>Product Name</th>
      <th>5kg Price</th>
      <th>25kg Price</th>
    `;
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Table body
    const tbody = document.createElement("tbody");
    category.products.forEach((product) => {
      const row = document.createElement("tr");

      // Product name
      const nameCell = document.createElement("td");
      nameCell.textContent = product.name;
      row.appendChild(nameCell);

      // Price handling - show availability or prices
      if (product.availability) {
        // Show availability message spanning both price columns
        const availCell = document.createElement("td");
        availCell.colSpan = "2";
        availCell.className = "availability";
        availCell.textContent = product.availability;
        row.appendChild(availCell);
      } else {
        // 5kg price
        const price5kgCell = document.createElement("td");
        price5kgCell.className = `price ${
          product.price_5kg === null ? "na" : ""
        }`;
        price5kgCell.textContent = formatPrice(product.price_5kg);
        row.appendChild(price5kgCell);

        // 25kg price
        const price25kgCell = document.createElement("td");
        price25kgCell.className = `price ${
          product.price_25kg === null ? "na" : ""
        }`;
        price25kgCell.textContent = formatPrice(product.price_25kg);
        row.appendChild(price25kgCell);
      }

      tbody.appendChild(row);
    });
    table.appendChild(tbody);

    section.appendChild(table);
    main.appendChild(section);
  });
}

// Show loading state
function showLoading() {
  isLoading = true;
  const main = document.querySelector("main");
  main.innerHTML = '<p class="loading">Loading products</p>';
}

// Show error state
function showError(message) {
  isError = true;
  const main = document.querySelector("main");
  main.innerHTML = `<div class="error"><strong>Error:</strong> ${message}</div>`;
}

// Load and parse products.json
async function loadProducts() {
  showLoading();

  try {
    const response = await fetch("products.json");

    if (!response.ok) {
      throw new Error(`Failed to load products.json: ${response.statusText}`);
    }

    catalogData = await response.json();

    // Validate data structure
    if (!catalogData.categories || !Array.isArray(catalogData.categories)) {
      throw new Error("Invalid data structure: missing or invalid categories");
    }

    // Render the catalog
    renderCategories(catalogData);
    isLoading = false;
    isError = false;
  } catch (error) {
    console.error("Error loading products:", error);
    showError(
      error.message || "Failed to load products. Please try again later."
    );
  }
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", () => {
  loadProducts();
});

// Export for testing (if needed)
if (typeof module !== "undefined" && module.exports) {
  module.exports = {
    formatPrice,
    renderCategories,
    loadProducts,
  };
}
