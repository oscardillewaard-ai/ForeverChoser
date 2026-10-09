import { CLASSES, FACTS, RACES, RESEARCH_DATE, SOURCES, classById, raceById, isNewCombo, racesForClass } from '../data.js';
import { classBadge, classVars, dots, esc, factionBadge, roleBadges } from '../ui.js';

const TABS = [
  { id: '', label: 'Classes' },
  { id: 'rassen', label: 'Rassen' },
  { id: 'matrix', label: 'Combinaties' },
  { id: 'weetjes', label: 'Weetjes' },
  { id: 'bronnen', label: 'Bronnen' },
];

function tabs(active) {
  return `<nav class="tabs" aria-label="Gids">${TABS.map((t) => `<a href="#/gids${t.id ? '/' + t.id : ''}" class="${t.id === active ? 'active' : ''}"${t.id === active ? ' aria-current="page"' : ''}>${t.label}</a>`).join('')}</nav>`;
}

export function renderGuide(root, [sub = '']) {
  const [kind, id] = sub.split('/');
  if (kind === 'class' && classById[id]) return classDetail(root, classById[id]);
  if (kind === 'ras' && raceById[id]) return raceDetail(root, raceById[id]);

  const views = { '': classList, rassen: raceList, matrix, weetjes: facts, bronnen: sources };
  const view = views[kind] || classList;
  root.innerHTML = `
    <div class="page-head"><h1>📖 Gids</h1></div>
    ${tabs(views[kind] ? kind : '')}
    <div class="guide-body">${view()}</div>
  `;
}

function classList() {
  return `
    <div class="grid">
      ${CLASSES.map(
        (c) => `
        <a class="card class-card" href="#/gids/class/${c.id}" style="${classVars(c)}">
          <span class="class-card-head"><span class="game-icon" aria-hidden="true">${c.icon}</span><span class="game-title" style="color:${c.text}">${esc(c.name)}</span></span>
          <span class="muted small">${esc(c.tagline)}</span>
          <span class="badges">${roleBadges(c.roles)}</span>
        </a>`,
      ).join('')}
    </div>`;
}

function raceList() {
  const group = (f, title) => `
    <h2 class="section-title">${title}</h2>
    <div class="grid">
      ${RACES.filter((r) => r.faction === f)
        .map(
          (r) => `
        <a class="card race-card ${r.faction}" href="#/gids/ras/${r.id}">
          <span class="class-card-head"><span class="game-icon" aria-hidden="true">${r.icon}</span><span class="game-title">${esc(r.name)}</span></span>
          <span class="muted small">${r.classes.length} classes${r.newClasses.length && !r.skyborne ? ` · nieuw: ${r.newClasses.map((c) => classById[c].name).join(', ')}` : ''}${r.skyborne ? ' · nieuw ras' : ''}</span>
        </a>`,
        )
        .join('')}
    </div>`;
  return group('alliance', '🦁 Alliance') + group('horde', '🐺 Horde');
}

function matrix() {
  const cell = (r, c) => {
    if (!r.classes.includes(c.id)) return '<td class="no" aria-label="niet speelbaar">·</td>';
    const isNew = r.skyborne || isNewCombo(r, c.id);
    return `<td class="${isNew ? 'new' : 'yes'}"><a href="#/gids/ras/${r.id}" aria-label="${esc(r.name)} ${esc(c.name)}${isNew ? ', nieuw' : ''}">${isNew ? '★' : '✓'}</a></td>`;
  };
  return `
    <p class="muted">56 combinaties in totaal: 28 per faction. ★ = nieuw in Forever, ✓ = bestond al in Classic. Skyborne (A) = High Order (Alliance), (H) = Windshaper (Horde).</p>
    <div class="table-scroll">
      <table class="matrix">
        <thead><tr><th scope="col">Ras</th>${CLASSES.map((c) => `<th scope="col" title="${esc(c.name)}" style="color:${c.text}"><span aria-hidden="true">${c.icon}</span><span class="th-label" aria-label="${esc(c.name)}">${esc(c.abbr)}</span></th>`).join('')}</tr></thead>
        <tbody>
          ${RACES.map((r) => `<tr class="${r.faction}"><th scope="row"><a href="#/gids/ras/${r.id}">${r.icon} ${esc(r.skyborne ? `Skyborne (${r.faction === 'horde' ? 'H' : 'A'})` : r.name)}</a></th>${CLASSES.map((c) => cell(r, c)).join('')}</tr>`).join('')}
        </tbody>
      </table>
    </div>
    <h3 class="section-title">De zes nieuwe combinaties</h3>
    <ul class="plain">
      <li>${classBadge('hunter')} Human Hunter</li>
      <li>${classBadge('priest')} Gnome Priest</li>
      <li>${classBadge('shaman')} Dwarf Shaman: de eerste Alliance Shaman</li>
      <li>${classBadge('mage')} Orc Mage</li>
      <li>${classBadge('warlock')} Troll Warlock</li>
      <li>${classBadge('paladin')} Undead Paladin: de eerste Horde Paladin</li>
    </ul>
    <p class="muted small">Plus het nieuwe ras Skyborne met vijf classes per faction. Night Elf en Tauren krijgen geen nieuwe class.</p>`;
}

function facts() {
  return `<div class="grid">${FACTS.map((f) => `<section class="card"><h3>${esc(f.title)}</h3><p class="muted">${esc(f.text)}</p></section>`).join('')}</div>`;
}

function sources() {
  return `
    <section class="card">
      <h3>Hoe betrouwbaar is dit?</h3>
      <p class="muted">Het onderzoek is gedaan op ${RESEARCH_DATE}, tijdens de beta en vóór de launch. De race/class-combinaties zijn officieel aangekondigd en stemmen in alle bronnen overeen. Exacte waarden van racials en class-wijzigingen komen uit beta-data en fan-gidsen; waar bronnen elkaar tegenspreken, noemt de app geen getal.</p>
      <p class="muted">De moeilijkheid en solo-sterkte per class zijn een indicatie: gebaseerd op Classic-ervaring en de consensus van beta-gidsen, niet op metingen.</p>
    </section>
    <section class="card">
      <h3>Bronnen</h3>
      <ul class="sources">${SOURCES.map((s) => `<li><a href="${esc(s.url)}" target="_blank" rel="noopener">${esc(s.label)}</a></li>`).join('')}</ul>
    </section>`;
}

function classDetail(root, c) {
  const byFaction = (f) =>
    racesForClass(c.id)
      .filter((r) => r.faction === f)
      .map((r) => `<a class="badge race-badge ${r.faction}" href="#/gids/ras/${r.id}">${r.icon} ${esc(r.name)}${r.skyborne || isNewCombo(r, c.id) ? ' ★' : ''}</a>`)
      .join('');
  root.innerHTML = `
    <div class="page-head">
      <a class="back" href="#/gids">← Gids</a>
    </div>
    <section class="card reveal" style="${classVars(c)}">
      <div class="reveal-icon" aria-hidden="true">${c.icon}</div>
      <h1 class="class-name">${esc(c.name)}</h1>
      <p class="muted">${esc(c.tagline)}</p>
      <div class="badges">${roleBadges(c.roles)}</div>
    </section>
    <section class="card">
      <p>${esc(c.fantasy)}</p>
      <dl class="stats">
        <dt>Specs</dt><dd>${c.specs.map(esc).join(' · ')}</dd>
        <dt>Resource</dt><dd>${esc(c.resource)}</dd>
        <dt>Armor</dt><dd>${esc(c.armor)}</dd>
        <dt>Moeilijkheid</dt><dd>${dots(c.difficulty, 5, 'Moeilijkheid')}</dd>
        <dt>Solo levelen</dt><dd>${dots(c.soloEase, 5, 'Solo levelen')}</dd>
      </dl>
      <p class="muted small">Moeilijkheid en solo-sterkte zijn een indicatie, zie <a href="#/gids/bronnen">Bronnen</a>.</p>
    </section>
    <div class="grid grid-2">
      <section class="card"><h3>👍 Sterk</h3><ul class="plain">${c.pros.map((p) => `<li>${esc(p)}</li>`).join('')}</ul></section>
      <section class="card"><h3>👎 Let op</h3><ul class="plain">${c.cons.map((p) => `<li>${esc(p)}</li>`).join('')}</ul></section>
    </div>
    <section class="card">
      <h3>★ Nieuw in Forever</h3>
      <ul class="plain">${c.forever.map((p) => `<li>${esc(p)}</li>`).join('')}</ul>
      <p class="muted small">Op basis van Blizzards class deep dives en beta-gidsen; kan nog veranderen.</p>
    </section>
    <section class="card">
      <h3>Rassen</h3>
      <div class="race-group">${factionBadge('alliance')}<div class="badges">${byFaction('alliance')}</div></div>
      <div class="race-group">${factionBadge('horde')}<div class="badges">${byFaction('horde')}</div></div>
    </section>
  `;
}

function raceDetail(root, r) {
  root.innerHTML = `
    <div class="page-head">
      <a class="back" href="#/gids/rassen">← Rassen</a>
    </div>
    <section class="card reveal ${r.faction}">
      <div class="reveal-icon" aria-hidden="true">${r.icon}</div>
      <h1 class="class-name">${esc(r.name)}</h1>
      <div class="badges">${factionBadge(r.faction)}${r.skyborne ? '<span class="badge new">★ Nieuw ras</span>' : ''}</div>
    </section>
    <section class="card">
      <p>${esc(r.lore)}</p>
      <dl class="stats">
        <dt>Startgebied</dt><dd>${esc(r.start)}</dd>
        <dt>Hoofdstad</dt><dd>${esc(r.capital)}</dd>
      </dl>
      ${r.note ? `<p class="notice">${esc(r.note)}</p>` : ''}
    </section>
    <section class="card">
      <h3>Racials</h3>
      <ul class="racials">
        ${r.racials.map((x) => `<li><span class="badge ${x.type === 'actief' ? 'active' : ''}">${x.type}</span> <strong>${esc(x.name)}</strong><br><span class="muted">${esc(x.text)}</span></li>`).join('')}
      </ul>
      <p class="muted small">Elk ras heeft in Forever twee actieve en twee passieve racials. Beta-waarden.</p>
    </section>
    <section class="card">
      <h3>Classes</h3>
      <div class="badges">${r.classes.map((id) => `<a href="#/gids/class/${id}">${classBadge(id)}${isNewCombo(r, id) && !r.skyborne ? ' ★' : ''}</a>`).join(' ')}</div>
      <h3 class="section-title">Racials passen het best bij</h3>
      <div class="badges">${Object.entries(r.synergy)
        .filter(([, v]) => v >= 3)
        .map(([id]) => classBadge(id))
        .join('') || '<span class="muted small">Geen uitschieters: een allround ras.</span>'}</div>
    </section>
  `;
}
