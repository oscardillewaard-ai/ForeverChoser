import { FACTS, LAUNCH_DATE, RESEARCH_DATE } from '../data.js';
import { getState } from '../store.js';
import { combinedScores, trialDone } from '../scoring.js';
import { classBadge, esc } from '../ui.js';

const CORE = [
  {
    href: '#/quiz',
    icon: '🔮',
    title: 'Orakel-quiz',
    text: '12 vragen over hoe jij speelt. Het Orakel zoekt de class die bij je past.',
    done: (s) => !!s.quiz,
  },
  {
    href: '#/duel',
    icon: '⚖️',
    title: 'Dit of Dat',
    text: '15 blinde duels tussen class-fantasieën. Pas aan het eind zie je wie je koos.',
    done: (s) => !!s.duel,
  },
  {
    href: '#/proefrit',
    icon: '🎮',
    title: 'Rol-proefrit',
    text: 'Speel 30 seconden healer, tank en DPS. Welke rol voelt als thuiskomen?',
    done: (s) => trialDone(s.trial),
  },
  {
    href: '#/ras',
    icon: '🧬',
    title: 'Rassen-raad',
    text: 'Faction, uiterlijk, verhaal en racials: welk ras past bij jouw class?',
    done: (s) => !!s.race,
  },
];

const EXTRA = [
  { href: '#/rad', icon: '🎡', title: 'Rad van het Lot', text: 'Laat het lot een combinatie kiezen.' },
  { href: '#/namen', icon: '📜', title: 'Namen-smidse', text: 'Een naam die past bij je ras.' },
  { href: '#/gids', icon: '📖', title: 'Gids', text: 'Alle classes, rassen, racials en combinaties.' },
];

export function renderHome(root) {
  const s = getState();
  const doneCount = CORE.filter((g) => g.done(s)).length;
  const combined = combinedScores(s);
  const fact = FACTS[Math.floor(Math.random() * FACTS.length)];

  root.innerHTML = `
    <section class="hero">
      <p class="eyebrow">World of Warcraft: Forever · start ${LAUNCH_DATE} (NL: 5 nov, 00:00)</p>
      <h1>Welke held word jij?</h1>
      <p class="lead">Speel de tests en mini-games en ontdek welke class en welk ras bij je passen. Zes nieuwe combinaties en een gloednieuw ras: de keuze was nog nooit zo groot.</p>
      <div class="progress-row">
        <div class="progress"><span style="width:${(doneCount / CORE.length) * 100}%"></span></div>
        <span class="muted">${doneCount}/${CORE.length} tests</span>
      </div>
      ${
        combined
          ? `<a class="card current-pick" href="#/resultaat">
              <span class="muted">Jouw beste match tot nu toe</span>
              <span>${classBadge(combined.ranking[0], 'big')}</span>
              <span class="link">Bekijk resultaat →</span>
            </a>`
          : `<a class="btn btn-primary btn-block" href="#/quiz">Begin met de Orakel-quiz</a>`
      }
    </section>

    <h2 class="section-title">De tests</h2>
    <div class="grid">
      ${CORE.map(
        (g, i) => `
        <a class="card game-card ${g.done(s) ? 'done' : ''}" href="${g.href}">
          <span class="game-icon" aria-hidden="true">${g.icon}</span>
          <span class="game-body">
            <span class="game-title">${i + 1}. ${esc(g.title)} ${g.done(s) ? '<span class="check" aria-label="voltooid">✓</span>' : ''}</span>
            <span class="muted">${esc(g.text)}</span>
          </span>
        </a>`,
      ).join('')}
    </div>

    <h2 class="section-title">Extra</h2>
    <div class="grid grid-3">
      ${EXTRA.map(
        (g) => `
        <a class="card mini-card" href="${g.href}">
          <span class="game-icon" aria-hidden="true">${g.icon}</span>
          <span class="game-title">${esc(g.title)}</span>
          <span class="muted small">${esc(g.text)}</span>
        </a>`,
      ).join('')}
    </div>

    <aside class="card fact">
      <span class="eyebrow">Wist je dat… · ${esc(fact.title)}</span>
      <p>${esc(fact.text)}</p>
      <a class="link" href="#/gids/weetjes">Meer weetjes →</a>
    </aside>

    <details class="card install-help">
      <summary>📲 App op je telefoon zetten</summary>
      <p><strong>Android (Chrome):</strong> tik op <em>Installeer</em> bovenin, of via het menu ⋮ op <em>App installeren</em>.</p>
      <p><strong>iPhone (Safari):</strong> tik op het deel-icoon en kies <em>Zet op beginscherm</em>.</p>
      <p>Daarna werkt de app ook offline.</p>
    </details>

    <footer class="footer">
      Fan-project, niet verbonden aan Blizzard Entertainment. World of Warcraft is een handelsmerk van Blizzard.
      Gegevens uit beta- en pre-launchbronnen, stand ${RESEARCH_DATE}; waarden kunnen nog veranderen.
    </footer>
  `;
}
