import { CLASSES, RACES, TRAITS, classById, isNewCombo } from './data.js';
import { QUIZ } from './games-data.js';

// Gewichten van de drie class-tests in het eindresultaat.
export const WEIGHTS = { quiz: 0.45, duel: 0.3, trial: 0.25 };

function cosine(user, profile) {
  let dot = 0;
  let nu = 0;
  let np = 0;
  for (const t of Object.keys(TRAITS)) {
    const u = user[t] || 0;
    const p = profile[t] || 0;
    dot += u * p;
    nu += u * u;
    np += p * p;
  }
  if (!nu || !np) return 0;
  return dot / Math.sqrt(nu * np);
}

export function quizTraits(answers) {
  const vec = {};
  answers.forEach((ai, qi) => {
    const ans = QUIZ[qi]?.a[ai];
    if (!ans) return;
    for (const [t, w] of Object.entries(ans.w)) vec[t] = (vec[t] || 0) + w;
  });
  return vec;
}

export function quizScores(traits) {
  return Object.fromEntries(CLASSES.map((c) => [c.id, cosine(traits, c.traits)]));
}

export function topTraits(traits, n = 4) {
  return Object.entries(traits)
    .filter(([, v]) => v > 0)
    .sort((a, b) => b[1] - a[1])
    .slice(0, n)
    .map(([t]) => t);
}

// Eigenschappen die de speler belangrijk vindt én sterk bij de class horen.
export function sharedTraits(traits, classId, n = 3) {
  const profile = classById[classId].traits;
  return topTraits(traits, 8)
    .filter((t) => (profile[t] || 0) >= 2)
    .slice(0, n);
}

// "Allebei even leuk" (ties) telt als een halve overwinning voor beide classes.
export function duelScores(duel) {
  return Object.fromEntries(
    CLASSES.map((c) => {
      const apps = duel.apps[c.id] || 0;
      const won = (duel.wins[c.id] || 0) + 0.5 * (duel.ties?.[c.id] || 0);
      return [c.id, apps ? won / apps : 0];
    }),
  );
}

// Rol-proefrit: elke class krijgt de hoogste beoordeling van de rollen die hij kan spelen.
// Een rol die nog niet beoordeeld is telt als neutraal (3 sterren).
export function trialScores(trial) {
  const rating = {
    tank: trial.tank?.rating,
    heal: trial.heal?.rating,
    dps: trial.dps?.rating,
  };
  return Object.fromEntries(
    CLASSES.map((c) => {
      const roles = c.roles.map((r) => (r === 'melee' || r === 'ranged' ? 'dps' : r));
      const vals = roles.map((r) => rating[r] ?? 3);
      return [c.id, (Math.max(...vals) - 1) / 4];
    }),
  );
}

export function trialDone(trial) {
  return ['heal', 'tank', 'dps'].some((k) => trial?.[k]?.rating);
}

function spread(scores) {
  const vals = Object.values(scores);
  return Math.max(...vals) - Math.min(...vals);
}

function normalize(scores) {
  const min = Math.min(...Object.values(scores));
  const range = spread(scores);
  return Object.fromEntries(Object.entries(scores).map(([k, v]) => [k, (v - min) / range]));
}

// Een test die geen verschil tussen classes maakt (alles overgeslagen, alleen DPS
// beoordeeld) telt niet mee; anders zou de eerste class in de lijst "winnen".
export function combinedScores(state) {
  const parts = [];
  if (state.quiz && spread(state.quiz.scores) > 1e-9) parts.push({ key: 'quiz', scores: normalize(state.quiz.scores) });
  if (state.duel) {
    const d = duelScores(state.duel);
    if (spread(d) > 1e-9) parts.push({ key: 'duel', scores: normalize(d) });
  }
  if (trialDone(state.trial)) {
    // Absolute waarden: 4 sterren voor tanken weegt minder zwaar dan 5 sterren.
    const t = trialScores(state.trial);
    if (spread(t) > 1e-9) parts.push({ key: 'trial', scores: t });
  }
  if (!parts.length) return null;
  const totalW = parts.reduce((s, p) => s + WEIGHTS[p.key], 0);
  const scores = Object.fromEntries(
    CLASSES.map((c) => [c.id, parts.reduce((s, p) => s + p.scores[c.id] * WEIGHTS[p.key], 0) / totalW]),
  );
  const ranking = CLASSES.map((c) => c.id).sort((a, b) => scores[b] - scores[a]);
  return { scores, ranking, sources: parts.map((p) => p.key) };
}

export function noveltyOf(race, classId) {
  if (race.skyborne) return 3;
  return isNewCombo(race, classId) ? 2 : 0;
}

// Rangschikt de rassen die de gekozen class kunnen spelen.
export function raceRanking(answers, classId) {
  const a = answers || {};
  const out = [];
  for (const race of RACES) {
    if (!race.classes.includes(classId)) continue;
    if (a.faction && a.faction !== 'any' && race.faction !== a.faction) continue;
    const syn = race.synergy[classId] || 0;
    const nov = noveltyOf(race, classId);
    const reasons = [];
    let score = syn;

    if (syn >= 3) reasons.push('Racials passen uitstekend bij deze class');
    else if (syn === 2) reasons.push('Racials passen goed bij deze class');

    if (a.look && race.look.includes(a.look)) {
      score += 2;
      reasons.push('Past bij het uiterlijk dat je zoekt');
    }
    if (a.vibe && race.vibe.includes(a.vibe)) {
      score += a.focus === 'rp' ? 3 : 2;
      reasons.push('Het verhaal sluit aan bij jouw smaak');
    }
    switch (a.focus) {
      case 'pve':
        score += syn;
        break;
      case 'pvp':
        score += race.pvp;
        if (race.pvp >= 3 && race.pvpWhy) reasons.push(race.pvpWhy);
        break;
      case 'quest':
        score += race.quest;
        if (race.quest >= 3) reasons.push('Handige racials voor questen en verkennen');
        break;
      case 'rp':
        score += nov * 0.5;
        break;
      default:
        break;
    }
    if (a.novelty === 'new') {
      score += nov;
      if (nov) reasons.push(race.skyborne ? 'Gloednieuw ras in Forever' : 'Nieuwe combinatie in Forever');
    } else if (a.novelty === 'classic') {
      score -= nov;
      if (!nov) reasons.push('Een klassieke combinatie');
    }
    out.push({ race, score, reasons, novelty: nov });
  }
  out.sort((x, y) => y.score - x.score || (y.race.synergy[classId] || 0) - (x.race.synergy[classId] || 0));
  const max = out[0]?.score || 1;
  const min = Math.min(...out.map((o) => o.score), 0);
  return out.map((o) => ({ ...o, pct: Math.round(((o.score - min) / (max - min || 1)) * 100) }));
}
