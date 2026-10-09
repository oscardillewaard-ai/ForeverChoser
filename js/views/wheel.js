import { CLASSES, RACES, classById, raceById, isNewCombo } from '../data.js';
import { getState, update } from '../store.js';
import { comboName, esc, factionBadge, rand } from '../ui.js';

const FILTERS = [
  { v: 'any', t: 'Allebei' },
  { v: 'alliance', t: '🦁 Alliance' },
  { v: 'horde', t: '🐺 Horde' },
];

function validRaces(classId, faction, onlyNew) {
  return RACES.filter(
    (r) =>
      r.classes.includes(classId) &&
      (faction === 'any' || r.faction === faction) &&
      (!onlyNew || r.skyborne || isNewCombo(r, classId)),
  );
}

export function renderWheel(root) {
  let faction = 'any';
  let onlyNew = false;
  let spinning = false;
  let rotation = 0;
  let raf = 0;
  let disposed = false;

  root.innerHTML = `
    <div class="page-head">
      <h1>🎡 Rad van het Lot</h1>
    </div>
    <p class="muted">Kun je echt niet kiezen? Laat het lot beslissen. Eerst de class, dan het ras.</p>
    <div class="segmented" role="group" aria-label="Faction">
      ${FILTERS.map((f) => `<button class="seg ${f.v === faction ? 'chosen' : ''}" data-f="${f.v}">${f.t}</button>`).join('')}
    </div>
    <label class="toggle"><input type="checkbox" data-new> Alleen wat nieuw is in Forever ★</label>
    <div class="wheel-wrap">
      <div class="wheel-pointer" aria-hidden="true"></div>
      <canvas class="wheel" width="600" height="600" role="img" aria-label="Rad van het Lot"></canvas>
    </div>
    <p class="wheel-stage muted" aria-live="polite"></p>
    <button class="btn btn-primary btn-block" data-spin>🎲 Draai!</button>
    <div class="wheel-result"></div>
    <div class="wheel-history"></div>
  `;

  const canvas = root.querySelector('canvas');
  const ctx = canvas.getContext('2d');
  const stage = root.querySelector('.wheel-stage');
  const spinBtn = root.querySelector('[data-spin]');
  const resultEl = root.querySelector('.wheel-result');
  let segments = classSegments();

  function classSegments() {
    return CLASSES.filter((c) => validRaces(c.id, faction, onlyNew).length).map((c) => ({
      id: c.id,
      label: c.name,
      icon: c.icon,
      color: c.color,
    }));
  }

  function draw() {
    const n = segments.length;
    const size = canvas.width;
    const r = size / 2;
    const seg = (Math.PI * 2) / n;
    ctx.clearRect(0, 0, size, size);
    ctx.save();
    ctx.translate(r, r);
    ctx.rotate(rotation);
    segments.forEach((s, i) => {
      const a0 = -Math.PI / 2 + i * seg;
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.arc(0, 0, r - 8, a0, a0 + seg);
      ctx.closePath();
      ctx.fillStyle = s.color;
      ctx.globalAlpha = i % 2 ? 0.78 : 0.95;
      ctx.fill();
      ctx.globalAlpha = 1;
      ctx.strokeStyle = '#0d0f17';
      ctx.lineWidth = 4;
      ctx.stroke();
      ctx.save();
      ctx.rotate(a0 + seg / 2);
      ctx.textAlign = 'right';
      ctx.textBaseline = 'middle';
      ctx.fillStyle = '#14100a';
      ctx.font = `bold ${n > 7 ? 26 : 30}px Georgia, serif`;
      ctx.fillText(`${s.label} ${s.icon}`, r - 28, 0);
      ctx.restore();
    });
    ctx.restore();
    ctx.beginPath();
    ctx.arc(r, r, 36, 0, Math.PI * 2);
    ctx.fillStyle = '#0d0f17';
    ctx.fill();
    ctx.strokeStyle = '#e6b450';
    ctx.lineWidth = 6;
    ctx.stroke();
  }

  // Draait het rad zodat segment `index` onder de pijl bovenaan stopt.
  function spinTo(index) {
    return new Promise((resolve) => {
      const n = segments.length;
      const seg = (Math.PI * 2) / n;
      const jitter = rand(-0.35, 0.35) * seg;
      const targetMod = (((-(index + 0.5) * seg + jitter) % (Math.PI * 2)) + Math.PI * 2) % (Math.PI * 2);
      const currentMod = ((rotation % (Math.PI * 2)) + Math.PI * 2) % (Math.PI * 2);
      let delta = targetMod - currentMod;
      if (delta < 0) delta += Math.PI * 2;
      delta += Math.PI * 2 * 5;
      const start = rotation;
      const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
      const duration = reduce ? 300 : 3600;
      const t0 = performance.now();
      const frame = (now) => {
        if (disposed) return;
        const t = Math.min(1, (now - t0) / duration);
        const eased = 1 - Math.pow(1 - t, 4);
        rotation = start + delta * eased;
        draw();
        if (t < 1) raf = requestAnimationFrame(frame);
        else resolve();
      };
      raf = requestAnimationFrame(frame);
    });
  }

  function refresh() {
    if (spinning) return;
    segments = classSegments();
    draw();
  }

  root.querySelector('.segmented').addEventListener('click', (e) => {
    const btn = e.target.closest('[data-f]');
    if (!btn || spinning) return;
    faction = btn.dataset.f;
    root.querySelectorAll('.seg').forEach((s) => s.classList.toggle('chosen', s === btn));
    refresh();
  });
  root.querySelector('[data-new]').addEventListener('change', (e) => {
    onlyNew = e.target.checked;
    refresh();
  });

  spinBtn.addEventListener('click', async () => {
    if (spinning) return;
    spinning = true;
    spinBtn.disabled = true;
    resultEl.innerHTML = '';

    segments = classSegments();
    const ci = Math.floor(Math.random() * segments.length);
    const classId = segments[ci].id;
    stage.textContent = 'Eerst de class…';
    await spinTo(ci);
    const c = classById[classId];
    stage.textContent = `Het wordt een ${c.name}! Nu het ras…`;
    await new Promise((r) => setTimeout(r, 700));
    if (disposed) return;

    const races = validRaces(classId, faction, onlyNew);
    segments = races.map((r, i) => ({
      id: r.id,
      label: r.short || r.name,
      icon: r.icon,
      color: r.faction === 'horde' ? (i % 2 ? '#d0604a' : '#e88a6e') : i % 2 ? '#5b93e6' : '#8ab4f0',
    }));
    rotation = 0;
    const ri = Math.floor(Math.random() * segments.length);
    await spinTo(ri);
    const race = raceById[segments[ri].id];

    stage.textContent = '';
    showResult(race.id, classId);
    const history = [{ raceId: race.id, classId }, ...getState().wheel].slice(0, 5);
    update({ wheel: history });
    renderHistory();
    spinning = false;
    spinBtn.disabled = false;
    spinBtn.textContent = '🎲 Nog een keer';
    segments = classSegments();
  });

  function showResult(raceId, classId) {
    const race = raceById[raceId];
    const c = classById[classId];
    const isNew = race.skyborne || isNewCombo(race, classId);
    resultEl.innerHTML = `
      <section class="card reveal" style="--cc:${c.color}">
        <p class="eyebrow">Het lot heeft gekozen</p>
        <div class="reveal-icon" aria-hidden="true">${race.icon}${c.icon}</div>
        <h2 class="class-name">${esc(comboName(raceId, classId))}</h2>
        <div class="badges">${factionBadge(race.faction)}${isNew ? '<span class="badge new">★ Nieuw in Forever</span>' : ''}</div>
        <p class="muted">${esc(c.tagline)}</p>
        <div class="actions">
          <a class="btn btn-small" href="#/gids/class/${classId}">Over de ${esc(c.name)}</a>
          <a class="btn btn-small" href="#/gids/ras/${raceId}">Over de ${esc(race.short || race.name)}</a>
        </div>
      </section>
    `;
  }

  function renderHistory() {
    const h = getState().wheel;
    root.querySelector('.wheel-history').innerHTML = h.length
      ? `<h3 class="section-title">Eerdere worpen</h3><ul class="history">${h.map((x) => `<li>${raceById[x.raceId].icon}${classById[x.classId].icon} ${esc(comboName(x.raceId, x.classId))}</li>`).join('')}</ul>`
      : '';
  }

  draw();
  renderHistory();
  return () => {
    disposed = true;
    cancelAnimationFrame(raf);
  };
}
