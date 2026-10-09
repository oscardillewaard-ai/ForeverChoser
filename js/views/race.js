import { CLASSES, classById } from '../data.js';
import { RACE_QUIZ } from '../games-data.js';
import { getState, update } from '../store.js';
import { combinedScores, raceRanking } from '../scoring.js';
import { bar, comboName, esc, factionBadge } from '../ui.js';

export function renderRace(root) {
  let step = 0;
  let answers = {};
  let classId = combinedScores(getState())?.ranking[0] || null;

  function showStep() {
    if (step >= RACE_QUIZ.length) return showClassPick();
    const q = RACE_QUIZ[step];
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>🧬 Rassen-raad</h1>
      </div>
      <div class="progress-row">
        <div class="progress"><span style="width:${(step / (RACE_QUIZ.length + 1)) * 100}%"></span></div>
        <span class="muted">${step + 1}/${RACE_QUIZ.length + 1}</span>
      </div>
      <section class="card question">
        <h2>${esc(q.q)}</h2>
        ${q.hint ? `<p class="muted small">${esc(q.hint)}</p>` : ''}
        <div class="answers">
          ${q.a.map((a) => `<button class="answer ${answers[q.key] === a.v ? 'chosen' : ''}" data-v="${a.v}">${esc(a.t)}</button>`).join('')}
        </div>
      </section>
      ${step > 0 ? '<button class="btn btn-ghost" data-back>← Vorige vraag</button>' : ''}
    `;
    root.querySelector('.answers').addEventListener('click', (e) => {
      const btn = e.target.closest('[data-v]');
      if (!btn) return;
      answers[q.key] = btn.dataset.v;
      btn.classList.add('chosen');
      setTimeout(() => {
        step++;
        showStep();
      }, 180);
    });
    root.querySelector('[data-back]')?.addEventListener('click', () => {
      step--;
      showStep();
    });
  }

  function showClassPick() {
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>🧬 Rassen-raad</h1>
      </div>
      <div class="progress-row">
        <div class="progress"><span style="width:${(RACE_QUIZ.length / (RACE_QUIZ.length + 1)) * 100}%"></span></div>
        <span class="muted">${RACE_QUIZ.length + 1}/${RACE_QUIZ.length + 1}</span>
      </div>
      <section class="card question">
        <h2>Voor welke class zoek je een ras?</h2>
        ${classId ? '<p class="muted small">Voorgeselecteerd: je beste match uit de tests.</p>' : ''}
        <div class="chip-grid">
          ${CLASSES.map((c) => `<button class="chip ${c.id === classId ? 'chosen' : ''}" data-c="${c.id}" style="--cc:${c.color}">${c.icon} ${esc(c.name)}</button>`).join('')}
        </div>
      </section>
      <div class="actions">
        <button class="btn btn-ghost" data-back>← Vorige</button>
        <button class="btn btn-primary" data-go ${classId ? '' : 'disabled'}>Toon mijn rassen</button>
      </div>
    `;
    const go = root.querySelector('[data-go]');
    root.querySelector('.chip-grid').addEventListener('click', (e) => {
      const btn = e.target.closest('[data-c]');
      if (!btn) return;
      classId = btn.dataset.c;
      root.querySelectorAll('.chip').forEach((c) => c.classList.toggle('chosen', c === btn));
      go.disabled = false;
    });
    root.querySelector('[data-back]').addEventListener('click', () => {
      step = RACE_QUIZ.length - 1;
      showStep();
    });
    go.addEventListener('click', () => {
      const ranking = raceRanking(answers, classId);
      update({ race: { answers, classId, ranking: ranking.map((r) => r.race.id) } });
      showResult();
    });
  }

  function showResult() {
    const saved = getState().race;
    answers = saved.answers;
    classId = saved.classId;
    const c = classById[classId];
    let ranking = raceRanking(answers, classId);
    let factionNote = '';
    if (!ranking.length) {
      // Deze class bestaat niet bij de gekozen faction: toon beide kanten.
      ranking = raceRanking({ ...answers, faction: 'any' }, classId);
      factionNote = `<p class="notice">Bij jouw faction kan geen enkel ras ${esc(c.name)} spelen, dus je ziet beide kanten.</p>`;
    }
    const best = ranking[0];

    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>🧬 De raad heeft gesproken</h1>
      </div>
      ${factionNote}
      <section class="card reveal" style="--cc:${c.color}">
        <p class="eyebrow">Jouw combinatie</p>
        <div class="reveal-icon" aria-hidden="true">${best.race.icon}${c.icon}</div>
        <h2 class="class-name">${esc(comboName(best.race.id, classId))}</h2>
        <div class="badges">${factionBadge(best.race.faction)}${best.novelty ? '<span class="badge new">★ Nieuw in Forever</span>' : ''}</div>
        ${best.reasons.length ? `<ul class="reasons">${best.reasons.map((r) => `<li>${esc(r)}</li>`).join('')}</ul>` : ''}
        ${best.race.note ? `<p class="notice">${esc(best.race.note)}</p>` : ''}
      </section>

      <section class="card">
        <h3>Racials van de ${esc(best.race.name)}</h3>
        <ul class="racials">
          ${best.race.racials.map((r) => `<li><span class="badge ${r.type === 'actief' ? 'active' : ''}">${r.type}</span> <strong>${esc(r.name)}</strong><br><span class="muted">${esc(r.text)}</span></li>`).join('')}
        </ul>
        <p class="muted small">Beta-waarden, kunnen bij launch nog veranderen.</p>
      </section>

      <section class="card">
        <h3>Alle rassen voor ${esc(c.name)}</h3>
        <ol class="ranking">
          ${ranking
            .map(
              (o) => `<li><a class="rank-row" href="#/gids/ras/${o.race.id}"><span class="rank-name">${o.race.icon} ${esc(o.race.name)}${o.novelty ? ' <span class="new-star" title="Nieuw in Forever">★</span>' : ''}</span>${bar(o.pct, o.race.faction === 'horde' ? 'var(--horde)' : 'var(--alliance)')}<span class="rank-pct">${o.pct}%</span></a></li>`,
            )
            .join('')}
        </ol>
      </section>

      <section class="card">
        <h3>Andere class proberen?</h3>
        <div class="chip-grid">
          ${CLASSES.map((x) => `<button class="chip ${x.id === classId ? 'chosen' : ''}" data-c="${x.id}" style="--cc:${x.color}">${x.icon} ${esc(x.name)}</button>`).join('')}
        </div>
      </section>

      <div class="actions">
        <a class="btn btn-primary" href="#/resultaat">Naar mijn resultaat →</a>
        <button class="btn btn-ghost" data-redo>Opnieuw</button>
      </div>
    `;
    root.querySelectorAll('.chip-grid')[0].addEventListener('click', (e) => {
      const btn = e.target.closest('[data-c]');
      if (!btn) return;
      const id = btn.dataset.c;
      update({ race: { answers, classId: id, ranking: raceRanking(answers, id).map((r) => r.race.id) } });
      showResult();
      window.scrollTo(0, 0);
    });
    root.querySelector('[data-redo]').addEventListener('click', () => {
      step = 0;
      answers = {};
      showStep();
    });
  }

  if (getState().race) showResult();
  else showStep();
}
