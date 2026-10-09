import { CLASSES, classById } from '../data.js';
import { getState, update } from '../store.js';
import { duelScores } from '../scoring.js';
import { bar, esc, shuffle } from '../ui.js';

const ROUNDS = 15;

// Kiest steeds twee classes die het minst vaak aan bod kwamen en nog niet tegen elkaar speelden.
function makeScheduler() {
  const apps = Object.fromEntries(CLASSES.map((c) => [c.id, 0]));
  const lines = Object.fromEntries(CLASSES.map((c) => [c.id, shuffle(c.duel)]));
  const played = new Set();
  const key = (a, b) => [a, b].sort().join('|');
  const lineFor = (id) => {
    if (!lines[id].length) lines[id] = shuffle(classById[id].duel);
    return lines[id].pop();
  };

  return function next() {
    const order = shuffle(CLASSES.map((c) => c.id)).sort((a, b) => apps[a] - apps[b]);
    const a = order[0];
    const b = order.slice(1).find((id) => !played.has(key(a, id))) || order[1];
    played.add(key(a, b));
    apps[a]++;
    apps[b]++;
    const pair = [
      { c: a, line: lineFor(a) },
      { c: b, line: lineFor(b) },
    ];
    return Math.random() < 0.5 ? pair : pair.reverse();
  };
}

export function renderDuel(root) {
  let round = 0;
  let wins = {};
  let apps = {};
  let picks = [];
  let next = makeScheduler();
  let current = null;

  function showRound() {
    current = next();
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>⚖️ Dit of Dat</h1>
      </div>
      <p class="muted">Kies telkens de fantasie die je het meest aanspreekt. Welke class erachter zit, zie je pas aan het eind.</p>
      <div class="progress-row">
        <div class="progress"><span style="width:${(round / ROUNDS) * 100}%"></span></div>
        <span class="muted">${round + 1}/${ROUNDS}</span>
      </div>
      <div class="duel">
        <button class="duel-card" data-side="0"><span class="duel-letter">A</span>${esc(current[0].line)}</button>
        <span class="duel-vs" aria-hidden="true">of</span>
        <button class="duel-card" data-side="1"><span class="duel-letter">B</span>${esc(current[1].line)}</button>
      </div>
      <button class="btn btn-ghost btn-block" data-skip>Allebei even leuk, sla over</button>
    `;
    root.querySelector('.duel').addEventListener('click', (e) => {
      const btn = e.target.closest('[data-side]');
      if (!btn) return;
      btn.classList.add('chosen');
      choose(Number(btn.dataset.side));
    });
    root.querySelector('[data-skip]').addEventListener('click', () => choose(null));
  }

  function choose(side) {
    for (const p of current) apps[p.c] = (apps[p.c] || 0) + 1;
    if (side !== null) {
      const w = current[side];
      wins[w.c] = (wins[w.c] || 0) + 1;
      picks.push({ c: w.c, line: w.line });
    }
    round++;
    setTimeout(() => {
      if (round < ROUNDS) showRound();
      else {
        update({ duel: { wins, apps, picks } });
        showResult();
      }
    }, 200);
  }

  function showResult() {
    const { duel } = getState();
    const scores = duelScores(duel);
    const ranking = CLASSES.map((c) => c.id).sort((a, b) => scores[b] - scores[a] || (duel.wins[b] || 0) - (duel.wins[a] || 0));
    const best = classById[ranking[0]];
    const bestPicks = duel.picks.filter((p) => p.c === best.id);

    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>⚖️ De onthulling</h1>
      </div>
      <section class="card reveal" style="--cc:${best.color}">
        <p class="eyebrow">Je koos het vaakst voor</p>
        <div class="reveal-icon" aria-hidden="true">${best.icon}</div>
        <h2 class="class-name">${esc(best.name)}</h2>
        <p class="muted">${duel.wins[best.id] || 0} van de ${duel.apps[best.id] || 0} keer gekozen</p>
        ${bestPicks.length ? `<ul class="quotes">${bestPicks.map((p) => `<li>“${esc(p.line)}”</li>`).join('')}</ul>` : ''}
      </section>
      <section class="card">
        <h3>Winstpercentage per class</h3>
        <ol class="ranking">
          ${ranking
            .map((id) => {
              const c = classById[id];
              const pct = Math.round(scores[id] * 100);
              return `<li><a href="#/gids/class/${id}" class="rank-row"><span class="rank-name" style="color:${c.color}">${c.icon} ${esc(c.name)}</span>${bar(pct, c.color)}<span class="rank-pct">${duel.wins[id] || 0}/${duel.apps[id] || 0}</span></a></li>`;
            })
            .join('')}
        </ol>
      </section>
      <div class="actions">
        <a class="btn btn-primary" href="#/proefrit">Volgende: Rol-proefrit →</a>
        <button class="btn btn-ghost" data-redo>Opnieuw</button>
      </div>
    `;
    root.querySelector('[data-redo]').addEventListener('click', () => {
      round = 0;
      wins = {};
      apps = {};
      picks = [];
      next = makeScheduler();
      showRound();
    });
  }

  if (getState().duel) showResult();
  else showRound();
}
