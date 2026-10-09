import { TRAITS, classById } from '../data.js';
import { getState, resetAll } from '../store.js';
import { WEIGHTS, combinedScores, duelScores, raceRanking, sharedTraits, trialDone } from '../scoring.js';
import { bar, comboName, esc, factionBadge, listNl, roleBadges, shareText } from '../ui.js';

const SOURCE_LABEL = { quiz: '🔮 Orakel-quiz', duel: '⚖️ Dit of Dat', trial: '🎮 Rol-proefrit' };

function reasonsFor(state, classId) {
  const out = [];
  if (state.quiz) {
    const shared = sharedTraits(state.quiz.traits, classId, 2);
    if (shared.length) out.push(`Orakel-quiz: je houdt van ${listNl(shared.map((t) => TRAITS[t].label.toLowerCase()))}.`);
  }
  if (state.duel) {
    const s = duelScores(state.duel);
    const w = state.duel.wins[classId] || 0;
    const a = state.duel.apps[classId] || 0;
    if (a && s[classId] >= 0.5) out.push(`In Dit of Dat koos je ${w} van de ${a} keer voor deze class.`);
  }
  if (trialDone(state.trial)) {
    const roles = classById[classId].roles.map((r) => (r === 'melee' || r === 'ranged' ? 'dps' : r));
    const best = [...new Set(roles)].map((r) => [r, state.trial[r]?.rating || 0]).sort((x, y) => y[1] - x[1])[0];
    const label = { heal: 'healen', tank: 'tanken', dps: 'DPS' }[best[0]];
    if (best[1] >= 4) out.push(`Je gaf ${label} ${best[1]} sterren, en dat kan deze class.`);
  }
  return out;
}

export function renderResults(root) {
  const state = getState();
  const combined = combinedScores(state);

  if (!combined) {
    root.innerHTML = `
      <div class="page-head"><h1>🏆 Jouw resultaat</h1></div>
      <section class="card empty">
        <p class="reveal-icon" aria-hidden="true">🔮</p>
        <h2>Nog geen resultaat</h2>
        <p class="muted">Doe minstens één test. Hoe meer tests, hoe beter het advies.</p>
        <a class="btn btn-primary" href="#/quiz">Start de Orakel-quiz</a>
      </section>`;
    return;
  }

  const top = combined.ranking[0];
  const c = classById[top];
  const raceAnswers = state.race?.answers || {};
  const races = raceRanking(raceAnswers, top);
  const bestRace = races[0];
  const reasons = reasonsFor(state, top);
  const missing = ['quiz', 'duel', 'trial'].filter((k) => !combined.sources.includes(k));
  const combo = comboName(bestRace.race.id, top);

  root.innerHTML = `
    <div class="page-head"><h1>🏆 Jouw resultaat</h1></div>
    <section class="card reveal hero-result" style="--cc:${c.color}">
      <p class="eyebrow">Jouw held in WoW Forever</p>
      <div class="reveal-icon" aria-hidden="true">${bestRace.race.icon}${c.icon}</div>
      <h2 class="class-name">${esc(combo)}</h2>
      <div class="badges">${factionBadge(bestRace.race.faction)}${roleBadges(c.roles)}</div>
      <p class="muted">${esc(c.tagline)}</p>
      ${reasons.length ? `<ul class="reasons">${reasons.map((r) => `<li>${esc(r)}</li>`).join('')}</ul>` : ''}
      ${bestRace.race.note ? `<p class="notice">${esc(bestRace.race.note)}</p>` : ''}
      <div class="actions">
        <button class="btn btn-primary" data-share>📣 Deel</button>
        <a class="btn" href="#/gids/class/${top}">Meer over de ${esc(c.name)}</a>
      </div>
    </section>

    ${
      missing.length
        ? `<section class="card notice-card">
            <p>Nog niet gedaan: ${missing.map((k) => `<a href="#/${k === 'trial' ? 'proefrit' : k}">${SOURCE_LABEL[k]}</a>`).join(', ')}. Elke extra test maakt het advies scherper.</p>
          </section>`
        : ''
    }
    ${!state.race ? `<section class="card notice-card"><p>Het ras hierboven is een algemene suggestie. Doe de <a href="#/ras">🧬 Rassen-raad</a> voor een ras dat bij jouw smaak past.</p></section>` : ''}

    <section class="card">
      <h3>Top 3 classes</h3>
      <ol class="podium">
        ${combined.ranking
          .slice(0, 3)
          .map((id, i) => {
            const x = classById[id];
            const r = raceRanking(raceAnswers, id)[0];
            return `<li style="--cc:${x.color}"><a href="#/gids/class/${id}"><span class="medal">${['🥇', '🥈', '🥉'][i]}</span><span><strong style="color:${x.color}">${x.icon} ${esc(x.name)}</strong><br><span class="muted small">bijvoorbeeld als ${esc(comboName(r.race.id, id))}</span></span><span class="rank-pct">${Math.round(combined.scores[id] * 100)}</span></a></li>`;
          })
          .join('')}
      </ol>
    </section>

    <section class="card">
      <h3>Alle classes</h3>
      <ol class="ranking">
        ${combined.ranking
          .map((id) => {
            const x = classById[id];
            const pct = Math.round(combined.scores[id] * 100);
            return `<li><a href="#/gids/class/${id}" class="rank-row"><span class="rank-name" style="color:${x.color}">${x.icon} ${esc(x.name)}</span>${bar(pct, x.color)}<span class="rank-pct">${pct}</span></a></li>`;
          })
          .join('')}
      </ol>
      <details class="how">
        <summary>Hoe wordt dit berekend?</summary>
        <p class="muted small">Elke test geeft per class een score. Die scores worden per test geschaald van 0 tot 100 en daarna gewogen gemiddeld: ${Object.entries(WEIGHTS)
          .map(([k, w]) => `${SOURCE_LABEL[k]} ${Math.round(w * 100)}%`)
          .join(', ')}. Tests die je nog niet deed tellen niet mee. Bij de Rol-proefrit telt hoe leuk je een rol vond, niet je score.</p>
      </details>
    </section>

    <section class="card">
      <h3>Beste rassen voor de ${esc(c.name)}</h3>
      <ol class="ranking">
        ${races
          .slice(0, 4)
          .map(
            (o) => `<li><a class="rank-row" href="#/gids/ras/${o.race.id}"><span class="rank-name">${o.race.icon} ${esc(o.race.name)}${o.novelty ? ' <span class="new-star">★</span>' : ''}</span>${bar(o.pct, o.race.faction === 'horde' ? 'var(--horde)' : 'var(--alliance)')}<span class="rank-pct">${o.pct}%</span></a></li>`,
          )
          .join('')}
      </ol>
    </section>

    <div class="actions">
      <a class="btn" href="#/namen">📜 Bedenk een naam</a>
      <button class="btn btn-ghost" data-reset>Alles wissen</button>
    </div>
  `;

  root.querySelector('[data-share]').addEventListener('click', () => {
    const top3 = combined.ranking.slice(0, 3).map((id) => classById[id].name).join(', ');
    shareText('Mijn WoW Forever held', `ForeverChoser zegt: ik word een ${combo}! Mijn top 3: ${top3}. Welke held word jij?`);
  });
  root.querySelector('[data-reset]').addEventListener('click', () => {
    if (confirm('Alle antwoorden, scores en bewaarde namen wissen?')) {
      resetAll();
      renderResults(root);
    }
  });
}
