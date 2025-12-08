export function initNav() {
  const header = document.querySelector(".site-header");
  const toggle = document.querySelector("[data-nav-toggle]");
  const navLinks = document.querySelector(".nav-links");
  const overlay = document.querySelector(".nav-overlay");

  const closeNav = () => {
    navLinks?.classList.remove("open");
    overlay?.classList.remove("visible");
    toggle?.setAttribute("aria-expanded", "false");
  };

  toggle?.addEventListener("click", () => {
    const isOpen = navLinks?.classList.toggle("open");
    overlay?.classList.toggle("visible");
    toggle?.setAttribute("aria-expanded", isOpen ? "true" : "false");
  });

  overlay?.addEventListener("click", closeNav);

  navLinks?.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", closeNav);
  });

  let lastScroll = 0;

  window.addEventListener("scroll", () => {
    const current = window.scrollY;
    const scrolled = current > 32;

    if (scrolled) {
      header?.classList.add("scrolled");
    } else {
      header?.classList.remove("scrolled");
    }

    const scrollingDown = current > lastScroll && current > 96;
    if (scrollingDown) {
      header?.classList.add("hidden");
    } else {
      header?.classList.remove("hidden");
    }

    lastScroll = current;
  });
}

document.addEventListener("DOMContentLoaded", initNav);
