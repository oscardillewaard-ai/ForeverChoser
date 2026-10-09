// Voortgang wordt alleen lokaal op het apparaat bewaard (localStorage).
// Zonder opslag (privévenster, geblokkeerde site-data) werkt de app gewoon,
// alleen onthoudt hij dan niets.

const KEY = 'foreverchoser:v1';

function defaults() {
  return {
    quiz: null, // { answers: number[], scores: {classId: number}, traits: {trait: number} }
    duel: null, // { wins: {classId: n}, apps: {classId: n}, picks: [{c, line}] }
    trial: {}, // { heal|tank|dps: { score, rating, detail } }
    race: null, // { answers: {key: value}, classId, ranking: [raceId] }
    names: [], // favoriete namen
    wheel: [], // laatste worpen [{classId, raceId}]
  };
}

let state = load();

function load() {
  try {
    const raw = localStorage.getItem(KEY);
    if (!raw) return defaults();
    return { ...defaults(), ...JSON.parse(raw) };
  } catch {
    return defaults();
  }
}

function save() {
  try {
    localStorage.setItem(KEY, JSON.stringify(state));
  } catch {
    // Opslag niet beschikbaar: de sessie werkt verder zonder te onthouden.
  }
}

export function getState() {
  return state;
}

export function update(patch) {
  state = { ...state, ...patch };
  save();
}

export function resetAll() {
  state = defaults();
  save();
}
