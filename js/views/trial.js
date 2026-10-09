import { getState, update } from '../store.js';
import { bindStars, esc, rand, starsInput } from '../ui.js';

const DURATION = 30000;
const TICK = 100;

const GAMES = {
  heal: {
    icon: '💚',
    title: 'Healer',
    goal: 'Houd je groep 30 seconden in leven.',
    rules: [
      'Tik op een groepslid voor een <strong>Flash Heal</strong> (+35 HP, 14 mana).',
      '<strong>Groepsheal</strong> geeft iedereen +20 HP voor 26 mana.',
      'Na elke spreuk volgt een korte global cooldown. Let op je mana!',
    ],
    classes: 'Priest, Paladin, Shaman en Druid',
    play: healGame,
  },
  tank: {
    icon: '🛡️',
    title: 'Tank',
    goal: 'Houd alle vijanden 30 seconden op jou gericht.',
    rules: [
      'Vijanden die van doelwit wisselen kleuren rood en vallen een groepslid aan.',
      'Tik op zo’n vijand om hem te <strong>taunten</strong>: dan richt hij zich weer op jou.',
      '<strong>Thunder Clap</strong> trekt alle vijanden tegelijk terug (8 s cooldown).',
    ],
    classes: 'Warrior, Paladin en Druid',
    play: tankGame,
  },
  dps: {
    icon: '⚔️',
    title: 'DPS',
    goal: 'Doe zoveel mogelijk schade in 30 seconden.',
    rules: [
      '<strong>Aanval</strong> kan altijd; <strong>Krachtslag</strong> heeft 5 s cooldown.',
      'Licht <strong>Kans!</strong> op? Snel tikken voor een dikke treffer.',
      '<strong>Woede</strong> verdubbelt 6 s je schade. Vuur onder je voeten? Tik <strong>Stap weg</strong>!',
    ],
    classes: 'Alle classes; Rogue, Mage, Warlock en Hunter zijn pure DPS',
    play: dpsGame,
  },
};

export function renderTrialHub(root) {
  const { trial } = getState();
  root.innerHTML = `
    <div class="page-head">
      <a class="back" href="#/">← Start</a>
      <h1>🎮 Rol-proefrit</h1>
    </div>
    <p class="lead">Elke rol voelt anders. Speel ze alle drie 30 seconden en geef daarna aan hoe leuk je het vond. <strong>Je plezier telt mee in het resultaat, niet je score.</strong></p>
    <div class="grid">
      ${Object.entries(GAMES)
        .map(([k, g]) => {
          const r = trial[k];
          return `
          <a class="card game-card ${r?.rating ? 'done' : ''}" href="#/proefrit/${k}">
            <span class="game-icon" aria-hidden="true">${g.icon}</span>
            <span class="game-body">
              <span class="game-title">${g.title} ${r?.rating ? `<span class="check">${'★'.repeat(r.rating)}</span>` : ''}</span>
              <span class="muted">${g.goal}</span>
              <span class="muted small">Rol van: ${g.classes}</span>
            </span>
          </a>`;
        })
        .join('')}
    </div>
    <div class="actions">
      <a class="btn btn-primary" href="#/ras">Volgende: Rassen-raad →</a>
    </div>
  `;
}

export function renderTrialGame(root, [kind]) {
  const game = GAMES[kind];
  let stop = null;

  function intro() {
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/proefrit">← Proefrit</a>
        <h1>${game.icon} ${game.title}</h1>
      </div>
      <section class="card">
        <h2>${game.goal}</h2>
        <ul class="rules">${game.rules.map((r) => `<li>${r}</li>`).join('')}</ul>
      </section>
      <button class="btn btn-primary btn-block" data-start>Start (30 seconden)</button>
    `;
    root.querySelector('[data-start]').addEventListener('click', play);
  }

  function play() {
    root.innerHTML = `
      <div class="page-head">
        <h1>${game.icon} ${game.title}</h1>
        <span class="timer" aria-live="off">30</span>
      </div>
      <div class="arena"></div>
    `;
    const timerEl = root.querySelector('.timer');
    stop = game.play(root.querySelector('.arena'), {
      onTime: (msLeft) => {
        timerEl.textContent = Math.ceil(msLeft / 1000);
      },
      onEnd: (result) => {
        stop = null;
        finish(result);
      },
    });
  }

  function finish(result) {
    const prev = getState().trial[kind];
    root.innerHTML = `
      <div class="page-head">
        <a class="back" href="#/proefrit">← Proefrit</a>
        <h1>${game.icon} Klaar!</h1>
      </div>
      <section class="card result-card">
        <p class="eyebrow">${esc(result.grade)}</p>
        <h2>${esc(result.headline)}</h2>
        <p class="muted">${esc(result.detail)}</p>
      </section>
      <section class="card">
        <h3>Hoe leuk vond je deze rol?</h3>
        <p class="muted small">Dit telt mee voor je class-advies.</p>
        ${starsInput('rating', prev?.rating || 0)}
      </section>
      <div class="actions">
        <button class="btn btn-primary" data-save disabled>Opslaan</button>
        <button class="btn btn-ghost" data-again>Nog een keer</button>
      </div>
    `;
    const saveBtn = root.querySelector('[data-save]');
    let rating = prev?.rating || 0;
    saveBtn.disabled = !rating;
    bindStars(root, (v) => {
      rating = v;
      saveBtn.disabled = false;
    });
    saveBtn.addEventListener('click', () => {
      update({ trial: { ...getState().trial, [kind]: { score: result.score, rating, detail: result.headline } } });
      const nextKind = Object.keys(GAMES).find((k) => !getState().trial[k]?.rating);
      location.hash = nextKind ? `#/proefrit/${nextKind}` : '#/proefrit';
    });
    root.querySelector('[data-again]').addEventListener('click', intro);
  }

  intro();
  return () => stop?.();
}

// Gemeenschappelijke spellus: roept tick(elapsed, now) aan tot de tijd op is.
function loop(hooks, tick, end) {
  const t0 = performance.now();
  let finished = false;
  const id = setInterval(() => {
    const now = performance.now();
    const elapsed = now - t0;
    hooks.onTime(Math.max(0, DURATION - elapsed));
    const early = tick(elapsed, now);
    if (elapsed >= DURATION || early) {
      finish();
    }
  }, TICK);
  function finish() {
    if (finished) return;
    finished = true;
    clearInterval(id);
    hooks.onEnd(end());
  }
  return () => {
    finished = true;
    clearInterval(id);
  };
}

function flash(el, cls = 'shake') {
  el.classList.remove(cls);
  void el.offsetWidth;
  el.classList.add(cls);
}

function healGame(arena, hooks) {
  const party = [
    { n: 'Tank', i: '🛡️', hp: 100, tank: true },
    { n: 'Rogue', i: '🗡️', hp: 100 },
    { n: 'Mage', i: '🔥', hp: 100 },
    { n: 'Hunter', i: '🏹', hp: 100 },
    { n: 'Jij', i: '✨', hp: 100, self: true },
  ];
  let mana = 100;
  let gcdUntil = 0;
  let healed = 0;
  let overheal = 0;
  let nextSpike = 2500;
  let nextAoe = 6000;

  arena.innerHTML = `
    <div class="resource"><span class="muted small">Mana</span><div class="bar mana"><span></span></div></div>
    <div class="frames">
      ${party
        .map(
          (p, i) => `
        <button class="frame" data-i="${i}">
          <span class="frame-name">${p.i} ${p.n}</span>
          <span class="hp"><span></span></span>
          <span class="hp-num">100</span>
        </button>`,
        )
        .join('')}
    </div>
    <button class="btn spell btn-block" data-group>🌟 Groepsheal <small>26 mana</small></button>
    <p class="event" aria-live="polite">Tik op een groepslid om te healen.</p>
  `;
  const frames = [...arena.querySelectorAll('.frame')];
  const manaEl = arena.querySelector('.mana > span');
  const eventEl = arena.querySelector('.event');
  const groupBtn = arena.querySelector('[data-group]');

  const alive = () => party.filter((p) => p.hp > 0);
  const hurt = (p, dmg) => {
    if (p.hp <= 0) return;
    p.hp = Math.max(0, p.hp - dmg);
  };
  const heal = (p, amount) => {
    if (p.hp <= 0) return;
    const real = Math.min(amount, 100 - p.hp);
    healed += real;
    overheal += amount - real;
    p.hp += real;
  };

  function cast(cost, el, fn) {
    const now = performance.now();
    if (now < gcdUntil || mana < cost) {
      flash(el);
      if (mana < cost) eventEl.textContent = '💧 Niet genoeg mana!';
      return;
    }
    mana -= cost;
    gcdUntil = now + 1000;
    fn();
    arena.classList.add('on-gcd');
    setTimeout(() => arena.classList.remove('on-gcd'), 1000);
    draw();
  }

  arena.querySelector('.frames').addEventListener('click', (e) => {
    const btn = e.target.closest('.frame');
    if (!btn) return;
    const p = party[Number(btn.dataset.i)];
    if (p.hp <= 0) return flash(btn);
    cast(14, btn, () => heal(p, 35));
  });
  groupBtn.addEventListener('click', () => cast(26, groupBtn, () => alive().forEach((p) => heal(p, 20))));

  function draw() {
    party.forEach((p, i) => {
      const f = frames[i];
      f.querySelector('.hp > span').style.width = `${p.hp}%`;
      f.querySelector('.hp-num').textContent = Math.ceil(p.hp);
      f.classList.toggle('low', p.hp > 0 && p.hp < 35);
      f.classList.toggle('dead', p.hp <= 0);
    });
    manaEl.style.width = `${mana}%`;
  }

  return loop(
    hooks,
    (elapsed) => {
      const intensity = 0.8 + 0.6 * (elapsed / DURATION);
      hurt(party[0], rand(0.5, 1.0) * intensity);
      if (elapsed > nextSpike) {
        const targets = alive().filter((p) => !p.tank);
        if (targets.length) {
          const t = targets[Math.floor(Math.random() * targets.length)];
          hurt(t, rand(20, 30));
          eventEl.textContent = `💥 ${t.n === 'Jij' ? 'Jij wordt' : `De ${t.n} wordt`} hard geraakt!`;
        }
        nextSpike += rand(3500, 5500) / intensity;
      }
      if (elapsed > nextAoe) {
        alive().forEach((p) => hurt(p, rand(10, 15)));
        eventEl.textContent = '🔥 AoE! Iedereen krijgt schade.';
        nextAoe += rand(6000, 8000);
      }
      mana = Math.min(100, mana + 0.2);
      draw();
      return party[4].hp <= 0;
    },
    () => {
      const survivors = alive().length;
      const avg = Math.round(alive().reduce((s, p) => s + p.hp, 0) / (survivors || 1));
      const ohPct = Math.round((overheal / (healed + overheal || 1)) * 100);
      return {
        score: survivors,
        grade: survivors === 5 ? 'Perfect: niemand gevallen' : survivors >= 3 ? 'Goed gedaan' : 'Zware dungeon',
        headline: `${survivors} van de 5 overleefden`,
        detail: `${Math.round(healed)} HP geheeld, ${ohPct}% overheal, gemiddeld ${avg}% health over.`,
      };
    },
  );
}

function tankGame(arena, hooks) {
  const allies = [
    { n: 'Healer', i: '💚', hp: 100 },
    { n: 'Mage', i: '🔥', hp: 100 },
    { n: 'Rogue', i: '🗡️', hp: 100 },
  ];
  const mobs = ['👹', '🐗', '🕷️', '🦇', '🐺'].map((i) => ({ i, target: -1 }));
  let gcdUntil = 0;
  let clapReady = 0;
  let nextSwap = 1500;
  let onTank = 0;
  let total = 0;

  arena.innerHTML = `
    <div class="allies">
      ${allies.map((a) => `<div class="ally"><span>${a.i} ${a.n}</span><span class="hp"><span></span></span></div>`).join('')}
    </div>
    <div class="mobs">
      ${mobs.map((m, i) => `<button class="mob" data-i="${i}"><span class="mob-icon">${m.i}</span><span class="mob-target"></span></button>`).join('')}
    </div>
    <button class="btn spell btn-block" data-clap>⚡ Thunder Clap <small>alle vijanden</small></button>
    <p class="event" aria-live="polite">Tik op rode vijanden om ze terug te taunten.</p>
  `;
  const allyEls = [...arena.querySelectorAll('.ally')];
  const mobEls = [...arena.querySelectorAll('.mob')];
  const clapBtn = arena.querySelector('[data-clap]');
  const eventEl = arena.querySelector('.event');

  const aliveAllies = () => allies.map((a, i) => i).filter((i) => allies[i].hp > 0);

  arena.querySelector('.mobs').addEventListener('click', (e) => {
    const btn = e.target.closest('.mob');
    if (!btn) return;
    const m = mobs[Number(btn.dataset.i)];
    const now = performance.now();
    if (m.target === -1) {
      eventEl.textContent = 'Die vijand valt jou al aan.';
      return;
    }
    if (now < gcdUntil) return flash(btn);
    m.target = -1;
    gcdUntil = now + 400;
    eventEl.textContent = `🛡️ Getaunt! ${m.i} valt jou weer aan.`;
    flash(btn, 'pulse');
    draw();
  });
  clapBtn.addEventListener('click', () => {
    const now = performance.now();
    if (now < clapReady) return flash(clapBtn);
    mobs.forEach((m) => (m.target = -1));
    clapReady = now + 8000;
    eventEl.textContent = '⚡ Alle vijanden op jou!';
    draw();
  });

  function draw() {
    const now = performance.now();
    allies.forEach((a, i) => {
      allyEls[i].querySelector('.hp > span').style.width = `${a.hp}%`;
      allyEls[i].classList.toggle('dead', a.hp <= 0);
    });
    mobs.forEach((m, i) => {
      const el = mobEls[i];
      const loose = m.target !== -1;
      el.classList.toggle('loose', loose);
      el.querySelector('.mob-target').textContent = loose ? `→ ${allies[m.target].i} ${allies[m.target].n}` : '→ 🛡️ Jij';
    });
    const cd = Math.max(0, clapReady - now);
    clapBtn.disabled = cd > 0;
    clapBtn.querySelector('small').textContent = cd > 0 ? `${Math.ceil(cd / 1000)} s` : 'alle vijanden';
  }

  return loop(
    hooks,
    (elapsed) => {
      const intensity = 0.9 + 0.8 * (elapsed / DURATION);
      if (elapsed > nextSwap) {
        const candidates = mobs.filter((m) => m.target === -1);
        const living = aliveAllies();
        if (candidates.length && living.length) {
          const m = candidates[Math.floor(Math.random() * candidates.length)];
          m.target = living[Math.floor(Math.random() * living.length)];
          eventEl.textContent = `${m.i} valt de ${allies[m.target].n} aan!`;
        }
        nextSwap += rand(1100, 2000) / intensity;
      }
      for (const m of mobs) {
        total++;
        if (m.target === -1) {
          onTank++;
          continue;
        }
        const a = allies[m.target];
        a.hp = Math.max(0, a.hp - 0.55 * intensity);
        if (a.hp <= 0) {
          const living = aliveAllies();
          m.target = living.length ? living[Math.floor(Math.random() * living.length)] : -1;
        }
      }
      const healerAlive = allies[0].hp > 0;
      allies.forEach((a, i) => {
        const attacked = mobs.some((m) => m.target === i);
        if (healerAlive && a.hp > 0 && !attacked) a.hp = Math.min(100, a.hp + 0.25);
      });
      draw();
      return aliveAllies().length === 0;
    },
    () => {
      const pct = Math.round((onTank / (total || 1)) * 100);
      const living = aliveAllies().length;
      return {
        score: pct,
        grade: pct >= 85 ? 'Rotsvast' : pct >= 65 ? 'Degelijke tank' : 'Chaos in de dungeon',
        headline: `${pct}% van de tijd hield je de aandacht vast`,
        detail: `${living} van de 3 groepsleden overleefden.`,
      };
    },
  );
}

function dpsGame(arena, hooks) {
  let dmg = 0;
  let gcdUntil = 0;
  let strikeReady = 0;
  let furyReady = 0;
  let furyUntil = 0;
  let procUntil = 0;
  let nextProc = rand(2500, 4500);
  let fireAt = rand(5000, 7000);
  let fireDeadline = 0;
  let stunnedUntil = 0;
  let fireHits = 0;
  let firesDodged = 0;

  arena.innerHTML = `
    <div class="boss">
      <span class="boss-icon" aria-hidden="true">🐲</span>
      <span class="boss-name">Oefendraak</span>
      <span class="dmg-total">0</span>
      <span class="muted small">schade</span>
      <div class="floaters" aria-hidden="true"></div>
    </div>
    <div class="fire" hidden>
      <span>🔥 Vuur onder je voeten!</span>
      <button class="btn btn-danger" data-move>🏃 Stap weg</button>
    </div>
    <div class="abilities">
      <button class="ability" data-a="hit">🗡️<span>Aanval</span><small>12</small></button>
      <button class="ability" data-a="strike">💥<span>Krachtslag</span><small>45</small></button>
      <button class="ability" data-a="proc" disabled>✨<span>Kans!</span><small>80</small></button>
      <button class="ability" data-a="fury">😤<span>Woede</span><small>×2</small></button>
    </div>
    <p class="event" aria-live="polite">Start met Woede en houd Krachtslag op cooldown.</p>
  `;
  const totalEl = arena.querySelector('.dmg-total');
  const floaters = arena.querySelector('.floaters');
  const fireEl = arena.querySelector('.fire');
  const eventEl = arena.querySelector('.event');
  const btn = Object.fromEntries([...arena.querySelectorAll('.ability')].map((b) => [b.dataset.a, b]));

  function deal(base, label) {
    const now = performance.now();
    const amount = Math.round(base * (now < furyUntil ? 2 : 1));
    dmg += amount;
    const f = document.createElement('span');
    f.className = `floater ${base >= 45 ? 'big' : ''}`;
    f.textContent = `${amount}${label ? ' ' + label : ''}`;
    f.style.left = `${rand(15, 70)}%`;
    floaters.appendChild(f);
    setTimeout(() => f.remove(), 900);
  }

  arena.querySelector('.abilities').addEventListener('click', (e) => {
    const b = e.target.closest('.ability');
    if (!b) return;
    const now = performance.now();
    const a = b.dataset.a;
    if (now < stunnedUntil) return flash(b);
    if (a === 'fury') {
      if (now < furyReady) return flash(b);
      furyUntil = now + 6000;
      furyReady = now + 18000;
      eventEl.textContent = '😤 Woede! 6 seconden dubbele schade.';
      return draw();
    }
    if (now < gcdUntil) return flash(b);
    if (a === 'hit') deal(12);
    if (a === 'strike') {
      if (now < strikeReady) return flash(b);
      deal(45);
      strikeReady = now + 5000;
    }
    if (a === 'proc') {
      if (now > procUntil) return flash(b);
      deal(80, '✨');
      procUntil = 0;
    }
    gcdUntil = now + 800;
    arena.classList.add('on-gcd');
    setTimeout(() => arena.classList.remove('on-gcd'), 800);
    draw();
  });
  arena.querySelector('[data-move]').addEventListener('click', () => {
    if (!fireDeadline) return;
    fireDeadline = 0;
    firesDodged++;
    fireEl.hidden = true;
    eventEl.textContent = '🏃 Netjes ontweken!';
  });

  function draw() {
    const now = performance.now();
    totalEl.textContent = dmg;
    const strikeCd = Math.max(0, strikeReady - now);
    btn.strike.classList.toggle('cooldown', strikeCd > 0);
    btn.strike.querySelector('small').textContent = strikeCd > 0 ? `${Math.ceil(strikeCd / 1000)} s` : '45';
    const furyCd = Math.max(0, furyReady - now);
    btn.fury.classList.toggle('cooldown', furyCd > 0);
    btn.fury.querySelector('small').textContent = now < furyUntil ? 'actief!' : furyCd > 0 ? `${Math.ceil(furyCd / 1000)} s` : '×2';
    btn.fury.classList.toggle('active', now < furyUntil);
    const procOn = now < procUntil;
    btn.proc.disabled = !procOn;
    btn.proc.classList.toggle('glow', procOn);
    arena.classList.toggle('stunned', now < stunnedUntil);
  }

  return loop(
    hooks,
    (elapsed, now) => {
      if (elapsed > nextProc) {
        procUntil = now + 2500;
        nextProc = elapsed + rand(3000, 5500);
      }
      if (!fireDeadline && elapsed > fireAt) {
        fireDeadline = now + 1800;
        fireEl.hidden = false;
        fireAt = elapsed + rand(5500, 8000);
      }
      if (fireDeadline && now > fireDeadline) {
        fireDeadline = 0;
        fireHits++;
        fireEl.hidden = true;
        stunnedUntil = now + 1500;
        eventEl.textContent = '🔥 Au! Je stond in het vuur en bent even uitgeschakeld.';
      }
      draw();
      return false;
    },
    () => {
      const dps = Math.round(dmg / (DURATION / 1000));
      return {
        score: dmg,
        grade: dmg >= 1300 ? 'Bovenaan de meter' : dmg >= 900 ? 'Stevige DPS' : 'Nog even oefenen',
        headline: `${dmg} schade (${dps} DPS)`,
        detail: `Vuur ontweken: ${firesDodged} van de ${firesDodged + fireHits} keer.`,
      };
    },
  );
}
