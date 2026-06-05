/* CycleBed shared script: theme toggle + PWA wiring.
   Loaded in <head> (no defer) so the theme is applied before first paint,
   avoiding a flash for users who prefer light mode. DOM-dependent work waits
   for DOMContentLoaded. */
(function () {
  'use strict';

  // --- Theme: apply saved/preferred theme immediately (pre-paint) ---
  var KEY = 'cyclebed-theme';
  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  if (saved === 'light' || saved === 'dark') {
    document.documentElement.setAttribute('data-theme', saved);
  }

  function currentTheme() {
    return document.documentElement.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    try { localStorage.setItem(KEY, theme); } catch (e) {}
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) meta.setAttribute('content', theme === 'light' ? '#eef1f8' : '#0b1020');
    var btn = document.getElementById('theme-toggle');
    if (btn) {
      var toLight = theme === 'dark';
      btn.setAttribute('aria-label', toLight ? 'Switch to light theme' : 'Switch to dark theme');
      btn.innerHTML = toLight ? sunIcon() : moonIcon();
    }
  }

  function moonIcon() {
    return '<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>';
  }
  function sunIcon() {
    return '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M2 12h2M20 12h2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M19.1 4.9l-1.4 1.4M6.3 17.7l-1.4 1.4"/></svg>';
  }

  function injectToggle() {
    var container = document.querySelector('.site-header .container');
    if (!container || document.getElementById('theme-toggle')) return;
    var btn = document.createElement('button');
    btn.id = 'theme-toggle';
    btn.type = 'button';
    btn.className = 'theme-toggle';
    container.appendChild(btn);
    btn.addEventListener('click', function () {
      applyTheme(currentTheme() === 'light' ? 'dark' : 'light');
    });
    applyTheme(currentTheme());
  }

  // --- PWA: register the service worker ---
  function registerSW() {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/sw.js').catch(function () {});
    }
  }

  function init() {
    injectToggle();
    registerSW();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
