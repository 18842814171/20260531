/**
 * LibertyOS — splash login (web gate + kernel login_session handoff)
 */

(function () {
  const LOGIN_USER = 'root';
  const SESSION_KEY = 'libertyos_session';

  const form = document.getElementById('login-form');
  const userInput = document.getElementById('login-user');
  const errorEl = document.getElementById('login-error');

  if (LibertyOS.getSession()) {
    window.location.replace('desktop.html');
    return;
  }

  function showError(show) {
    errorEl?.classList.toggle('hidden', !show);
  }

  function enterDesktop(user) {
    LibertyOS.setSession(user);
    const splash = document.querySelector('.splash');
    if (splash) splash.classList.add('splash--fade-out');
    setTimeout(() => {
      window.location.href = 'desktop.html';
    }, 500);
  }

  form?.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = (userInput?.value || '').trim().toLowerCase();
    if (name !== LOGIN_USER) {
      showError(true);
      userInput?.focus();
      userInput?.select();
      return;
    }
    showError(false);
    enterDesktop(name);
  });

  userInput?.focus();
})();
