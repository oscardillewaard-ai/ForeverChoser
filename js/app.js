import { renderHome } from './views/home.js';
import { renderQuiz } from './views/quiz.js';
import { renderDuel } from './views/duel.js';
import { renderTrialHub, renderTrialGame } from './views/trial.js';
import { renderRace } from './views/race.js';
import { renderWheel } from './views/wheel.js';
import { renderNames } from './views/names.js';
import { renderGuide } from './views/guide.js';
import { renderResults } from './views/results.js';

const app = document.getElementById('app');
let cleanup = null;

// Volgorde telt: het eerste patroon dat past wint.
const ROUTES = [
  [/^$/, renderHome, 'home'],
  [/^quiz$/, renderQuiz, 'home'],
  [/^duel$/, renderDuel, 'home'],
  [/^proefrit$/, renderTrialHub, 'home'],
  [/^proefrit\/(heal|tank|dps)$/, renderTrialGame, 'home'],
  [/^ras$/, renderRace, 'home'],
  [/^rad$/, renderWheel, 'rad'],
  [/^namen$/, renderNames, 'home'],
  [/^gids(?:\/(.*))?$/, renderGuide, 'gids'],
  [/^resultaat$/, renderResults, 'resultaat'],
];

function route() {
  const path = decodeURIComponent(location.hash.replace(/^#\/?/, '')).replace(/\/$/, '');
  if (typeof cleanup === 'function') cleanup();
  cleanup = null;

  let match = null;
  let view = renderHome;
  let nav = 'home';
  for (const [re, fn, n] of ROUTES) {
    match = path.match(re);
    if (match) {
      view = fn;
      nav = n;
      break;
    }
  }
  if (!match) {
    location.replace('#/');
    return;
  }

  document.querySelectorAll('[data-nav]').forEach((a) => {
    a.classList.toggle('active', a.dataset.nav === nav);
    if (a.dataset.nav === nav) a.setAttribute('aria-current', 'page');
    else a.removeAttribute('aria-current');
  });

  app.innerHTML = '';
  cleanup = view(app, match.slice(1)) || null;
  const h1 = app.querySelector('h1');
  const title = h1 ? h1.textContent.replace(/^[^\p{L}\d]+/u, '').trim() : '';
  document.title = path && title ? `${title} · ForeverChoser` : 'ForeverChoser';
  window.scrollTo(0, 0);
  app.focus({ preventScroll: true });
}

window.addEventListener('hashchange', route);
route();

// Installeerknop: Chrome/Edge/Android geven een beforeinstallprompt-event.
let deferredPrompt = null;
const installBtn = document.getElementById('install-btn');
const standalone = matchMedia('(display-mode: standalone)').matches || navigator.standalone === true;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;
  if (!standalone) installBtn.hidden = false;
});
installBtn.addEventListener('click', async () => {
  if (!deferredPrompt) return;
  deferredPrompt.prompt();
  await deferredPrompt.userChoice;
  deferredPrompt = null;
  installBtn.hidden = true;
});
window.addEventListener('appinstalled', () => {
  installBtn.hidden = true;
});

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('sw.js').catch(() => {});
  });
}
