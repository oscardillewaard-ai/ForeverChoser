import { classById, raceById, FACTIONS, ROLES } from './data.js';

export function esc(s) {
  return String(s ?? '').replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]);
}

// "a", "a en b", "a, b en c"
export function listNl(items) {
  if (items.length < 2) return items.join('');
  return `${items.slice(0, -1).join(', ')} en ${items[items.length - 1]}`;
}

export function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

export function rand(min, max) {
  return min + Math.random() * (max - min);
}

let toastTimer;
export function toast(msg) {
  let el = document.getElementById('toast');
  if (!el) {
    el = document.createElement('div');
    el.id = 'toast';
    el.className = 'toast';
    el.setAttribute('role', 'status');
    document.body.appendChild(el);
  }
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 2200);
}

export function classBadge(id, extra = '') {
  const c = classById[id];
  return `<span class="badge class-badge ${extra}" style="--cc:${c.color}">${c.icon} ${esc(c.name)}</span>`;
}

export function raceBadge(id) {
  const r = raceById[id];
  return `<span class="badge race-badge ${r.faction}">${r.icon} ${esc(r.name)}</span>`;
}

export function factionBadge(f) {
  return `<span class="badge faction ${f}">${FACTIONS[f].icon} ${FACTIONS[f].label}</span>`;
}

export function roleBadges(roles) {
  return roles.map((r) => `<span class="badge role">${ROLES[r].icon} ${ROLES[r].label}</span>`).join('');
}

export function dots(n, max = 5, label = '') {
  let out = `<span class="dots" role="img" aria-label="${esc(label)} ${n} van ${max}">`;
  for (let i = 1; i <= max; i++) out += `<i class="${i <= n ? 'on' : ''}"></i>`;
  return out + '</span>';
}

export function bar(pct, color = 'var(--gold)') {
  const p = Math.max(0, Math.min(100, Math.round(pct)));
  return `<span class="bar"><span style="width:${p}%;background:${color}"></span></span>`;
}

// Combinatie van ras en class, zoals in de character creation: "Troll Warlock".
export function comboName(raceId, classId) {
  const r = raceById[raceId];
  return `${r.short || r.name} ${classById[classId].name}`;
}

export function starsInput(name, value = 0) {
  let out = `<div class="stars" role="radiogroup" aria-label="Beoordeling">`;
  for (let i = 1; i <= 5; i++) {
    out += `<button type="button" class="star ${i <= value ? 'on' : ''}" data-star="${i}" role="radio" aria-checked="${i === value}" aria-label="${i} ster${i > 1 ? 'ren' : ''}">★</button>`;
  }
  return out + `</div><input type="hidden" name="${esc(name)}" value="${value}">`;
}

export function bindStars(root, onChange) {
  root.querySelectorAll('.stars').forEach((group) => {
    group.addEventListener('click', (e) => {
      const btn = e.target.closest('[data-star]');
      if (!btn) return;
      const v = Number(btn.dataset.star);
      group.querySelectorAll('.star').forEach((s) => {
        const on = Number(s.dataset.star) <= v;
        s.classList.toggle('on', on);
        s.setAttribute('aria-checked', String(Number(s.dataset.star) === v));
      });
      const input = group.nextElementSibling;
      if (input) input.value = v;
      onChange?.(v);
    });
  });
}

export async function shareText(title, text) {
  const url = location.href.split('#')[0];
  if (navigator.share) {
    try {
      await navigator.share({ title, text, url });
      return;
    } catch (err) {
      if (err?.name === 'AbortError') return;
    }
  }
  try {
    await navigator.clipboard.writeText(`${text}\n${url}`);
    toast('Gekopieerd naar je klembord');
  } catch {
    toast('Delen lukte niet op dit apparaat');
  }
}
