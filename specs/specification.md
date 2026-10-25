---
title: Handball Dansk — Product Specification
type: specification
status: draft
version: 0.1
created: 2026-10-25
para: Projects
project: handball-dansk
tags: [spec, language-learning, handball, pwa, speech]
baseline: danish-handball-trainer.html (v2)
---

# Handball Dansk — Product Specification

## 1. Summary

A mobile-first, Duolingo-style trainer that teaches a handball player the Danish he needs on court, in the locker room and in daily team life, with spoken audio and automatic pronunciation correction. First user: Samuel, playing in Denmark. Target: any foreign player joining a Danish club.

**Assumptions (proceeding without confirmation):**
- It is a standalone app. Duolingo exposes no plugin/extension API and cannot host custom courses, so "add-on" is out of scope.
- Phase 0 is the existing single-file trainer (213 phrases, browser TTS, transcript-based scoring). This document specifies what it becomes.
- Primary devices: Android/iOS phone browsers (installable PWA) and a laptop browser. No native app store release in v1.

## 2. Problem and causal logic

| Observation | Consequence | Design response |
|---|---|---|
| Coaches speak in fast, flat fragments; the first weeks are comprehension of commands, not conversation | Vocabulary lists alone do not transfer to the court | Content ordered by court exposure (shouts, positions, actions first); listening-first drills at speed |
| Danish spelling is a poor guide to sound (soft d, swallowed endings, stød) | Text-only study produces wrong pronunciation that is hard to unlearn | Every item has recorded native-quality audio; learner is scored on sounds, not letters |
| Browser TTS depends on the device's installed voices; many laptops have no Danish voice | Inconsistent or wrong audio, the core feature fails silently | Pre-generated audio shipped with the app; no runtime dependence on device voices |
| Speech recognisers return a transcript, and are trained to be forgiving | A transcript match proves intelligibility, not accuracy; subtle errors pass | Phoneme-level scoring (section 7), with transcript match kept only as a fallback |
| Browsers block the microphone on non-HTTPS or downloaded files, and in sandboxed frames | A downloaded HTML file often cannot record on a phone | Served over HTTPS as an installable PWA |
| Motivation decays without feedback loops | Learners stop after days | XP, streaks, spaced repetition, team goals |

## 3. Users and use cases

| Persona | Need | Key flows |
|---|---|---|
| Newly arrived player (Samuel) | Understand coach in week 1, speak with teammates | Daily 5-minute lesson; "match day" pack; look up and replay a phrase heard at training |
| Coach / club contact | Help foreign players integrate | Assign a pack; see who has practised (opt-in) |
| Parent / sponsor (Franck) | Know it is working | Weekly progress summary (opt-in by learner) |

## 4. Scope

### In scope (v1)
- Danish listening, speaking and recognition drills for handball and team life.
- Pre-generated native-quality audio, normal and slow.
- Pronunciation scoring with word- and sound-level feedback.
- Gamification: XP, streak, daily goal, per-skill progress, spaced repetition.
- Installable PWA, offline-capable for content already downloaded.
- Team mode: shared leaderboard and weekly goal.

### Out of scope (v1)
- Free conversation with an AI tutor.
- Writing and spelling exercises beyond recognition.
- Other languages or sports (architecture must not prevent them).
- App store native apps.

## 5. Content model

Content is data, versioned and separate from code.

```json
{
  "id": "shouts-017",
  "pack": "shouts",
  "da": "Tal sammen!",
  "variants": ["Tal sammen"],
  "en": "Talk to each other!",
  "phonemes": "t a l  s a m ən",
  "audio": {"normal": "audio/shouts-017.mp3", "slow": "audio/shouts-017.slow.mp3"},
  "tags": ["defence", "coach", "imperative"],
  "difficulty": 1,
  "context": "Shouted by coach during 6-0 defence",
  "pronunciationNotes": ["swallowed -mən ending"]
}
```

| Pack | Source | Items (v0) |
|---|---|---|
| Coach shouts | Phrasebook s7 | 25 |
| Positions & roles | s3 | 11 |
| Game actions | s4 | 29 |
| Systems & tactics | s5 | 19 |
| Referee & rules | s6 | 12 |
| Survival essentials | s1 | 26 |
| Numbers & days | s2 | 25 |
| Training | s8 | 18 |
| Locker room & logistics | s9 | 18 |
| Injuries & medical | s10 | 13 |
| Social & team culture | s11 | 17 |

**Content rules:**
- Each phrase is reviewed by a native Danish handball speaker before release (open question Q3).
- Alternatives separated by "/" become `variants`; each variant is scored independently.
- Numerals are spoken and matched as Danish words.

## 6. Functional requirements

| ID | Requirement | Priority |
|---|---|---|
| F1 | Tap any phrase to play audio at normal speed; second control plays slow | Must |
| F2 | Audio is played from shipped files, never from device TTS, and works offline once the pack is cached | Must |
| F3 | Record learner via microphone; return score 0-100, per-word and per-sound result, and one to three concrete hints | Must |
| F4 | Show target vs. what the learner said, with colour states (correct, close, wrong, missing) | Must |
| F5 | Optional playback of the learner's own recording next to the native audio | Should |
| F6 | Lesson loop: introduce 5 items, listening drill, speaking drill, mixed review; completes in ≤5 minutes | Must |
| F7 | Drill types: listen-and-choose meaning, listen-and-type, read-and-speak, match audio to image/position | Must (first two) |
| F8 | Spaced repetition: items scoring below mastery resurface at increasing intervals | Must |
| F9 | XP, daily streak, daily goal, per-pack progress bars, mastery states (new, learning, mastered) | Must |
| F10 | Situation packs ("Match day", "Injury", "First training") that bundle items across sections | Should |
| F11 | Search across Danish and English | Should |
| F12 | Team mode: invite code, weekly team goal, leaderboard, opt-in progress sharing | Should |
| F13 | Export progress (JSON) and delete all data | Must |
| F14 | Self-test screen: shows device capability (audio, microphone, network), last error | Must |

## 7. Pronunciation scoring

### 7.1 Why the baseline is insufficient
The v0 scorer compares a recogniser transcript with the target text. A recogniser is optimised to guess the intended word, so a wrong vowel or a hard "d" instead of a soft "d" often still returns the right word and scores 100. It measures intelligibility, not pronunciation accuracy.

### 7.2 Target pipeline

```
mic audio (16 kHz, PCM) → VAD/trim → ASR (Danish) → forced alignment to expected phonemes
→ per-phoneme goodness-of-pronunciation (GOP) → aggregate (phoneme → word → utterance)
→ rule-based hint selection → UI
```

| Stage | Option A (cloud service) | Option B (self-hosted) |
|---|---|---|
| Scoring | Azure AI Speech Pronunciation Assessment (accuracy, fluency, completeness, per-phoneme) | wav2vec2/XLS-R Danish model + CTC forced alignment, GOP computed in-house |
| ASR fallback | Same service, da-DK | Whisper-class model (faster-whisper) on local GPU |
| Hosting | Managed | Single service on a 24 GB GPU box (Apple Silicon M-series or RTX 3090 class) behind a small API |
| Data leaves device | Yes (audio to vendor) | No (stays on own infrastructure) |

**Decision rule:** build behind one interface (`score(audio, expectedText) → ScoreResult`) so either option plugs in. **Risk R1:** per-phoneme assessment may not be available or reliable for da-DK in a given cloud service; verify before committing (spike S1). If unavailable, Option B or transcript-only (v0 logic) is the fallback, and the UI states the weaker guarantee.

### 7.3 ScoreResult contract

```json
{
  "overall": 82,
  "words": [{"text": "forstår", "score": 71, "phonemes": [{"p": "ɔ", "score": 54}]}],
  "heard": "jeg forstod ikke",
  "hints": ["å sounds like 'aw'"],
  "engine": "azure|local|transcript",
  "confidence": 0.8
}
```

### 7.4 Hint generation
Deterministic rules map low-scoring phonemes and spelling patterns to hints (soft d, æ/ø/å, swallowed endings, silent final g, soft r, hv-, stød). Hints are authored content, not generated at runtime, so they are consistent and reviewable.

### 7.5 Scoring thresholds
| Score | State | XP |
|---|---|---|
| ≥ 90 | Perfect | +10 on first mastery |
| 80-89 | Mastered | +10 on first mastery |
| 50-79 | Close | +3 |
| < 50 | Retry | +1 |

Mastery requires two scores ≥ 80 on different days (v0: single score; change in F8).

## 8. Audio production

| Item | Requirement |
|---|---|
| Voice | Native Danish; at least one male and one female voice (assumption: neural TTS in v1, human recording of the top 100 coach shouts in v1.1) |
| Variants | Normal and slow (≈0.65×) rendered separately, not time-stretched in the client |
| Format | MP3 ≈64 kbps mono, loudness-normalised (−16 LUFS) |
| Generation | Batch pipeline from content JSON, idempotent, cached by content hash |
| Review | Native speaker signs off each pack; corrections tracked as content changes |
| Size budget | ≈ 213 items × 2 speeds × ~15 KB ≈ 6.5 MB per voice |

## 9. Architecture

```
PWA (static)              API (thin)                  Services
─────────────             ──────────                  ────────
UI + service worker  ──►  auth, sync, teams    ──►    object storage (audio, content)
local store (IndexedDB)   POST /score (audio)  ──►    scoring service (Option A or B)
audio cache               GET  /content/{pack}        analytics (aggregate only)
```

| Concern | Decision |
|---|---|
| Client | Static PWA, no framework required for v1 (vanilla JS or a small framework); installable, offline shell via service worker |
| Local-first | Progress stored in IndexedDB first, synced when online; app fully usable offline except scoring |
| Audio capture | `MediaRecorder` / Web Audio, resample to 16 kHz mono before upload |
| Auth | Passwordless (email magic link) or none in v1 with an anonymous device id; required only for team mode |
| Backend | Single small service; scoring service isolated behind an internal API so the engine can change |
| Hosting | HTTPS static host for the PWA (required for microphone access) |

## 10. Gamification and learning design

- **Daily goal:** 5 minutes or 10 items; streak counts days the goal is met.
- **Skill tree:** packs unlock by priority order: shouts → positions → actions → survival → logistics → tactics → rules → social → medical.
- **Spaced repetition:** Leitner boxes at 1, 2, 4, 8, 16 days; a score < 80 drops the item one box.
- **Situation packs:** short, context-rich drills ("You are late for training": 6 phrases in a mini scene).
- **Hearts/energy:** not used (frustrates adult learners); replaced by retry hints.
- **Team goal:** shared weekly XP target, visible to the squad only.

## 11. Non-functional requirements

| Area | Requirement |
|---|---|
| Performance | Tap-to-audio latency < 200 ms from cache; score returned < 3 s on 4G for a 3-second utterance |
| Offline | Learn, listen and quiz fully offline for downloaded packs; recordings queued for scoring |
| Browser support | Current Chrome and Edge (Android, desktop), Safari (iOS 16+); Firefox for listening only |
| Accessibility | Screen-reader labels, visible focus, text size scaling, no colour-only feedback (icon + label with each state) |
| Reliability | Scoring failure never blocks a lesson; engine falls back to transcript match and says so |
| Security | HTTPS only; signed URLs for audio; rate limiting on `/score` |
| Observability | Capability and error telemetry from the self-test (no audio, no personal text) |

## 12. Privacy and compliance

| Topic | Rule |
|---|---|
| Audio recordings | Processed transiently; not stored by default; storage only if the user enables "keep my recordings" |
| Minors | The first users may be under 18: no personal data collected without a guardian's consent; no minor's age or date of birth stored; team features opt-in |
| Vendor processing | If Option A is used, audio is sent to the vendor; disclosed in the app; vendor retention must be disabled where offered |
| User rights | Export and delete from the app (F13); GDPR-aligned (UK/EU) |
| Analytics | Aggregate only, no audio, no phrase-level user text |

## 13. Phased delivery

| Phase | Outcome | Exit criteria |
|---|---|---|
| 0 (done) | Single-file trainer: TTS, transcript scoring, quiz, XP/streak | Works on laptop Chrome; known limits documented |
| 1 | PWA on HTTPS, shipped audio, offline, self-test | Audio plays identically on 3 devices without installed voices; microphone works on Android and iOS |
| 2 | Scoring service behind the `ScoreResult` interface; spike S1 decided | ≥ 85% agreement with a native speaker's pass/fail on a 100-utterance test set |
| 3 | Spaced repetition, lesson loop, situation packs | Median daily session 5 min; 7-day retention measured |
| 4 | Team mode, coach view | 10 players in one squad, leaderboard live |

## 14. Spikes and open questions

| ID | Question | Why it matters |
|---|---|---|
| S1 | Does the chosen cloud scoring service support phoneme-level assessment for da-DK? | Determines Option A vs B (R1) |
| S2 | Can an open Danish wav2vec2 model yield usable GOP scores on short utterances? | Feasibility of fully local scoring |
| S3 | Which neural voices sound closest to a Copenhagen/Jutland speaker, and are they licensed for redistribution inside an app? | Audio is the core asset |
| Q1 | Which Danish dialect/region should the model voice reflect (club location)? | Pronunciation target |
| Q2 | Is Samuel the only user, or a team/club rollout? | Decides whether F12 and backend are v1 |
| Q3 | Who reviews content as a native handball speaker? | Quality gate |
| Q4 | Cloud services acceptable, or all processing local only? | Decides Option A vs B |

## 15. Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | No phoneme-level scoring for da-DK in available services | Medium | High | Spike S1; Option B; transcript fallback with honest UI |
| R2 | Mobile browsers restrict microphone/speech APIs | Medium | High | HTTPS PWA; self-test (F14); upload-and-score path independent of browser recognition |
| R3 | Synthetic voice sounds unnatural and teaches a wrong accent | Medium | High | Native review; human recording for top phrases |
| R4 | Unofficial TTS endpoints (used in v0 fallback) disappear | High | Medium | Removed in Phase 1 by shipped audio |
| R5 | Scoring strictness mismatch frustrates or flatters learners | Medium | Medium | Calibrate on native-speaker test set; tunable thresholds |

## 16. Acceptance criteria (v1)

1. On a phone with no installed Danish voice, every phrase plays correct Danish audio at normal and slow speed, offline after first load.
2. Recording a phrase returns a score, per-word colouring and at least one relevant hint in under 3 seconds on 4G.
3. A deliberately mispronounced phrase (hard "d" for soft "d") scores lower than the correct pronunciation by at least 15 points on the phoneme-level engine.
4. Daily streak, XP and mastery persist across restarts and work offline, syncing on reconnect.
5. The self-test screen correctly reports microphone, audio and network state.
6. Deleting data from the app removes all local and server-side learner data.
