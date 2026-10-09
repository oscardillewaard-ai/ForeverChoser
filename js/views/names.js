import { RACES, raceById } from '../data.js';
import { NAME_MIDDLES, NAME_PARTS } from '../games-data.js';
import { getState, update } from '../store.js';
import { esc, toast } from '../ui.js';

const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

export function makeName(raceId) {
  const parts = NAME_PARTS[raceId];
  for (let tries = 0; tries < 20; tries++) {
    const raw = pick(parts.a) + (Math.random() < 0.3 ? pick(NAME_MIDDLES) : '') + pick(parts.b);
    const name = raw.charAt(0).toUpperCase() + raw.slice(1).toLowerCase();
    // WoW-namen: 2-12 letters, geen drie dezelfde letters achter elkaar.
    if (name.length >= 3 && name.length <= 12 && !/(.)\1\1/i.test(name)) return name;
  }
  return pick(parts.a) + pick(parts.b);
}

export function renderNames(root) {
  let raceId = getState().race?.ranking?.[0] || 'human';

  root.innerHTML = `
    <div class="page-head">
      <a class="back" href="#/">← Start</a>
      <h1>📜 Namen-smidse</h1>
    </div>
    <p class="muted">Kies je ras en smeed een naam. Tik op een naam om hem te kopiëren en te bewaren.</p>
    <div class="chip-grid">
      ${RACES.map((r) => `<button class="chip ${r.id === raceId ? 'chosen' : ''}" data-r="${r.id}">${r.icon} ${esc(r.name)}</button>`).join('')}
    </div>
    <button class="btn btn-primary btn-block" data-forge>🔨 Smeed namen</button>
    <ul class="name-list" aria-live="polite"></ul>
    <section class="card favorites"></section>
    <p class="muted small">Of een naam nog vrij is, zie je pas in de character creation.</p>
  `;

  const list = root.querySelector('.name-list');

  function forge() {
    const names = new Set();
    for (let i = 0; i < 100 && names.size < 8; i++) names.add(makeName(raceId));
    list.innerHTML = [...names].map((n) => `<li><button class="name" data-n="${esc(n)}">${esc(n)}</button></li>`).join('');
  }

  function renderFavorites() {
    const favs = getState().names;
    root.querySelector('.favorites').innerHTML = favs.length
      ? `<h3>⭐ Bewaarde namen</h3><ul class="fav-list">${favs
          .map((f) => `<li><span>${raceById[f.raceId]?.icon || ''} ${esc(f.name)}</span><button class="btn btn-small btn-ghost" data-del="${esc(f.name)}" aria-label="Verwijder ${esc(f.name)}">✕</button></li>`)
          .join('')}</ul>`
      : '<h3>⭐ Bewaarde namen</h3><p class="muted small">Nog niets bewaard.</p>';
  }

  root.querySelector('.chip-grid').addEventListener('click', (e) => {
    const btn = e.target.closest('[data-r]');
    if (!btn) return;
    raceId = btn.dataset.r;
    root.querySelectorAll('.chip').forEach((c) => c.classList.toggle('chosen', c === btn));
    forge();
  });
  root.querySelector('[data-forge]').addEventListener('click', forge);

  list.addEventListener('click', async (e) => {
    const btn = e.target.closest('[data-n]');
    if (!btn) return;
    const name = btn.dataset.n;
    const favs = getState().names;
    if (!favs.some((f) => f.name === name)) update({ names: [{ name, raceId }, ...favs].slice(0, 30) });
    btn.classList.add('chosen');
    renderFavorites();
    try {
      await navigator.clipboard.writeText(name);
      toast(`“${name}” gekopieerd en bewaard`);
    } catch {
      toast(`“${name}” bewaard`);
    }
  });

  root.querySelector('.favorites').addEventListener('click', (e) => {
    const btn = e.target.closest('[data-del]');
    if (!btn) return;
    update({ names: getState().names.filter((f) => f.name !== btn.dataset.del) });
    renderFavorites();
  });

  forge();
  renderFavorites();
}
