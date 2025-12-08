(function() {
  const qs = (sel, ctx=document) => Array.from(ctx.querySelectorAll(sel));

  function setupCopyButtons() {
    qs('pre').forEach((block) => {
      const wrapper = block.closest('.code-block') || block.parentElement;
      if (!wrapper || wrapper.querySelector('button.copy')) return;
      const btn = document.createElement('button');
      btn.className = 'copy';
      btn.type = 'button';
      btn.textContent = 'Copy';
      btn.addEventListener('click', async () => {
        const text = block.textContent.trim();
        try {
          await navigator.clipboard.writeText(text);
          btn.textContent = 'Copied';
          btn.disabled = true;
          setTimeout(() => { btn.textContent = 'Copy'; btn.disabled = false; }, 1200);
        } catch (err) {
          btn.textContent = 'Press ⌘/Ctrl+C';
          setTimeout(() => { btn.textContent = 'Copy'; }, 1400);
        }
      });
      wrapper.style.position = 'relative';
      wrapper.appendChild(btn);
    });
  }

  function setupSearch() {
    const input = document.querySelector('[data-doc-search]');
    if (!input) return;
    const sections = qs('[data-section]');
    input.addEventListener('input', () => {
      const term = input.value.toLowerCase().trim();
      sections.forEach((section) => {
        const text = section.textContent.toLowerCase();
        const match = !term || text.includes(term);
        section.style.display = match ? '' : 'none';
      });
    });
  }

  function setupTOC() {
    const tocLinks = qs('.toc a[href^="#"]');
    tocLinks.forEach((link) => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(link.getAttribute('href'));
        if (target) {
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    setupCopyButtons();
    setupSearch();
    setupTOC();
  });
})();
