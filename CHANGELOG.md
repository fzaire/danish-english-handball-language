# Changelog

All notable changes to Handball Dansk are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Contributing to the changelog

- Add every user-visible change to the **Unreleased** section in the same
  commit as the change.
- Group entries under **Added**, **Changed**, **Deprecated**, **Removed**,
  **Fixed** or **Security**.
- Write one short line per change, from the learner's point of view.
- When releasing, rename **Unreleased** to the version and date
  (`## [x.y.z] - YYYY-MM-DD`), add a new empty **Unreleased** section, update
  the comparison links at the bottom, and create the matching GitHub release
  with `danish-handball-trainer.html` attached.

## [Unreleased]

- Trainer: "Phrasebook" links to the HTML and PDF versions on GitHub Pages, shown on both the Learn and Quiz tabs.

### Added

- Online version on GitHub Pages, served over HTTPS so the microphone works on
  phones.
- Microphone setup guide in the README for each browser and operating system.
- This changelog.
- Contribution guide (`CONTRIBUTING.md`).
- Markdown version of the phrasebook (`Danish_english_vocabulary_for_Handball.md`),
  readable directly on GitHub.
- `scripts/build-docs.sh` and a GitHub Actions workflow that build the
  phrasebook as HTML and PDF into `docs/`.
- Favicon and home-screen icon (red Danish cross with a handball) for the
  trainer, the online site and the generated phrasebook.

## [0.2.0] - 2026-10-25

### Added

- Quiz: **Back** button to return to previous questions, keeping answers and
  pronunciation scores.
- Quiz: a pronunciation recording is required after each answer before moving
  on. It is skipped when speech recognition or the microphone is unavailable.
- Quiz: average pronunciation score on the final screen.

### Changed

- Quiz: phrases with "/" alternatives are split into separate questions, each
  with its own English meaning.

## [0.1.0] - 2026-10-25

### Added

- Standalone trainer with 213 Danish handball phrases across 11 sections.
- Listening at normal and slow speed, using the device's Danish voice.
- Speaking practice with transcript-based pronunciation scores and hints.
- Multiple-choice listening quiz, XP, streaks and best scores.
- Direct download link for the trainer HTML file.

### Fixed

- Phrases were not displayed because of a startup error.

[Unreleased]: https://github.com/fzaire/danish-english-handball-language/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/fzaire/danish-english-handball-language/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/fzaire/danish-english-handball-language/releases/tag/v0.1.0
