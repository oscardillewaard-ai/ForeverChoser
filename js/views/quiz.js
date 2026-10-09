import { CLASSES, TRAITS, classById } from '../data.js';
import { QUIZ } from '../games-data.js';
import { getState, update } from '../store.js';
import { quizScores, quizTraits, sharedTraits, topTraits } from '../scoring.js';
import { bar, classVars, esc, focusHeading, listNl, roleBadges } from '../ui.js';

export function renderQuiz(root) {
  let index = 0;
  let answers = [];
  let busy = false;
  let timer = 0;

  function showQuestion() {
    const q = QUIZ[index];
    busy = false;
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>🔮 Orakel-quiz</h1>
      </div>
      <div class="progress-row">
        <div class="progress"><span style="width:${(index / QUIZ.length) * 100}%"></span></div>
        <span class="muted">${index + 1}/${QUIZ.length}</span>
      </div>
      <section class="card question">
        <h2>${esc(q.q)}</h2>
        <div class="answers">
          ${q.a.map((a, i) => `<button class="answer ${answers[index] === i ? 'chosen' : ''}" data-i="${i}">${esc(a.t)}</button>`).join('')}
        </div>
      </section>
      ${index > 0 ? '<button class="btn btn-ghost" data-back>← Vorige vraag</button>' : ''}
    `;
    root.querySelector('.answers').addEventListener('click', (e) => {
      const btn = e.target.closest('[data-i]');
      if (!btn || busy) return;
      busy = true;
      answers[index] = Number(btn.dataset.i);
      btn.classList.add('chosen');
      timer = setTimeout(() => {
        if (index < QUIZ.length - 1) {
          index++;
          showQuestion();
        } else {
          finish();
        }
      }, 180);
    });
    root.querySelector('[data-back]')?.addEventListener('click', () => {
      if (busy) return;
      index--;
      showQuestion();
    });
    focusHeading(root);
  }

  function finish() {
    const traits = quizTraits(answers);
    const scores = quizScores(traits);
    update({ quiz: { answers, scores, traits } });
    showResult();
  }

  function showResult() {
    const { quiz } = getState();
    const ranking = CLASSES.map((c) => c.id).sort((a, b) => quiz.scores[b] - quiz.scores[a]);
    const best = classById[ranking[0]];
    const mine = topTraits(quiz.traits, 5);
    const shared = sharedTraits(quiz.traits, best.id);

    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/">← Start</a>
        <h1>🔮 Het Orakel spreekt</h1>
      </div>
      <section class="card reveal" style="${classVars(best)}">
        <p class="eyebrow">Jouw class volgens het Orakel</p>
        <div class="reveal-icon" aria-hidden="true">${best.icon}</div>
        <h2 class="class-name">${esc(best.name)}</h2>
        <p class="muted">${esc(best.tagline)}</p>
        <div class="badges">${roleBadges(best.roles)}</div>
        ${shared.length ? `<p>Je houdt van ${listNl(shared.map((t) => `<strong>${esc(TRAITS[t].label.toLowerCase())}</strong>`))}: daar blinkt de ${esc(best.name)} in uit.</p>` : ''}
      </section>

      <section class="card">
        <h3>Wat jou drijft</h3>
        <div class="badges">${mine.map((t) => `<span class="badge">${TRAITS[t].icon} ${TRAITS[t].label}</span>`).join('')}</div>
      </section>

      <section class="card">
        <h3>Match per class</h3>
        <ol class="ranking">
          ${ranking
            .map((id) => {
              const c = classById[id];
              const pct = Math.round(Math.max(0, quiz.scores[id]) * 100);
              return `<li><a href="#/gids/class/${id}" class="rank-row"><span class="rank-name" style="color:${c.text}">${c.icon} ${esc(c.name)}</span>${bar(pct, c.color)}<span class="rank-pct">${pct}%</span></a></li>`;
            })
            .join('')}
        </ol>
        <p class="muted small">De match is de overeenkomst tussen jouw antwoorden en het profiel van elke class.</p>
      </section>

      <div class="actions">
        <a class="btn btn-primary" href="#/duel">Volgende: Dit of Dat →</a>
        <button class="btn btn-ghost" data-redo>Opnieuw</button>
      </div>
    `;
    root.querySelector('[data-redo]').addEventListener('click', () => {
      index = 0;
      answers = [];
      showQuestion();
    });
    focusHeading(root);
  }

  if (getState().quiz) showResult();
  else showQuestion();
  return () => clearTimeout(timer);
}
