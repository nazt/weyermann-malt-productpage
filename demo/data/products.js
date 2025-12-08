const productsUrl = new URL("../../../products.json", import.meta.url);

function normalizeCategory(category) {
  const items = Array.isArray(category.products) ? category.products : [];

  return {
    name: category.name || "Untitled",
    note: category.note || category.notes || null,
    items: items.map((item) => ({
      name: item.name || "Unnamed product",
      price5: item.price_5kg ?? null,
      price25: item.price_25kg ?? null,
      availability: item.availability || null,
      note: item.note || null,
    })),
  };
}

export async function loadProducts() {
  const response = await fetch(productsUrl);

  if (!response.ok) {
    throw new Error(`Unable to load products: ${response.statusText}`);
  }

  const payload = await response.json();
  const categories = Array.isArray(payload.categories)
    ? payload.categories.map(normalizeCategory)
    : [];

  return {
    company: payload.company || "Catalog",
    subtitle: payload.subtitle || "",
    currency: payload.currency || "",
    exchangeNote: payload.exchange_note || "",
    priceValid: payload.price_valid || "",
    categories,
  };
}

export function summarizeProducts(data) {
  const categoryCount = data.categories.length;
  const productCount = data.categories.reduce(
    (total, category) => total + category.items.length,
    0
  );

  return {
    categoryCount,
    productCount,
    currency: data.currency || "THB",
  };
}
