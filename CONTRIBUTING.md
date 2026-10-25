# Contributing to Handball Dansk

Thank you for helping foreign handball players learn Danish. This guide
explains how to report problems, suggest phrases and submit changes.

## Ways to contribute

- **Report a bug**: something does not display, play, record or score
  correctly.
- **Correct or suggest phrases**: wrong translations, unnatural Danish, or
  phrases players hear at training and in the locker room.
- **Improve pronunciation hints**: clearer explanations of Danish sounds.
- **Improve the app or documentation**: features, accessibility, browser
  support, README and guides.

Native Danish speakers, especially handball players and coaches, are
particularly welcome to review phrases.

## Before you start

- Search [existing issues](https://github.com/fzaire/danish-english-handball-language/issues)
  to avoid duplicates.
- **New feature ideas** go to [Discussions → Ideas](https://github.com/fzaire/danish-english-handball-language/discussions/categories/ideas),
  where everyone can upvote them. Accepted ideas become Feature issues with
  Given/When/Then acceptance scenarios. The full process is described in
  [FEATURE_WORKFLOW.md](./FEATURE_WORKFLOW.md).
- Pick work from issues labelled [`status:ready`](https://github.com/fzaire/danish-english-handball-language/issues?q=is%3Aopen+label%3Astatus%3Aready).
- Small fixes (typos, a wrong translation) can go straight to a pull request.

## Reporting bugs

Open an [issue](https://github.com/fzaire/danish-english-handball-language/issues/new)
and include:

- What you did, what you expected, and what happened instead.
- Device, operating system and browser with version (for example
  "iPhone 15, iOS 18, Safari").
- How you opened the app: the [online version](https://fzaire.github.io/danish-english-handball-language/)
  or a downloaded file.
- For microphone or scoring problems: the message shown under the 🎤 button,
  and the phrase you were practising.
- A screenshot if the problem is visual, and any errors from the browser
  console.

Microphone issues are often permission settings; check the
[microphone guide](./README.md#enable-the-microphone) first.

## Suggesting or correcting phrases

Open an issue or a pull request with, for each phrase:

- The Danish phrase and its English meaning.
- The section it belongs to (for example "Coach shouts").
- Where it is used (training, match, locker room) and, ideally, a native
  speaker's confirmation.

Phrases are stored in the `DATA` array in
[danish-handball-trainer.html](./danish-handball-trainer.html). Each row is:

```js
["Danish", "English", "optional text to speak and score"]
```

- Use `/` for alternatives: `["Skud / Skyd!", "Shot / Shoot!"]`. Give the
  English the same number of parts so the quiz can split them into separate
  questions.
- If the English parts are shortened (for example
  `"Good morning / evening / night"`), add an entry to `QSPLIT` with the full
  pairings.
- Use the third value when the written form differs from what is spoken, for
  example digits: `["1. bølge / 2. bølge", "First / second wave", "første bølge / anden bølge"]`.

## Development setup

The trainer is a single HTML file with plain HTML, CSS and JavaScript. There
is no build step, framework or package to install.

1. [Fork](https://github.com/fzaire/danish-english-handball-language/fork) the
   repository and clone your fork.
2. Create a branch from `main` with a descriptive name, for example
   `fix/quiz-back-button` or `content/add-injury-phrases`.
3. Serve the folder locally so the microphone is allowed (`localhost` counts as
   a secure address):

   ```sh
   python3 -m http.server 8000
   ```

4. Open <http://localhost:8000/danish-handball-trainer.html> in Chrome, Edge
   or Safari.

## Building the phrasebook documents

The phrasebook source is
[Danish_english_vocabulary_for_Handball.md](./Danish_english_vocabulary_for_Handball.md).
Edit only the Markdown; the HTML and PDF in `docs/` are generated.

Requirements: [pandoc](https://pandoc.org/installing.html) and Chrome,
Chromium or Edge.

```sh
scripts/build-docs.sh                 # build the phrasebook
scripts/build-docs.sh other-file.md   # build specific Markdown files
CHROME=/path/to/chrome scripts/build-docs.sh
```

Styling lives in `scripts/docs.css`. The **Build docs** GitHub Actions
workflow runs the script on pull requests (output available as a `docs`
artifact) and, on `main`, commits the regenerated files so GitHub Pages
serves them.

## Coding guidelines

- Keep the app a single, self-contained file that works without a server, a
  build step or third-party libraries.
- Follow the existing compact style and naming in the file.
- Escape any text inserted as HTML with the existing `esc()` helper.
- Keep features working when speech synthesis, speech recognition or the
  microphone are unavailable; show a clear message instead of failing.
- Keep accessibility in mind: labelled buttons, sufficient contrast, and never
  colour alone to show a result.
- Respect privacy: do not add analytics, tracking or uploads of recordings.
  The first users may be minors.
- Add comments only where the code needs clarification.

## Testing your change

There is no automated test suite yet. Before opening a pull request, check
manually:

- [ ] All sections display their phrases, and search works.
- [ ] 🔊 and 🐢 play the phrase.
- [ ] Practice: 🎤 records and shows a score with hints.
- [ ] Quiz: answer, record, **Next**, **Back** and the final screen work.
- [ ] No errors appear in the browser console.
- [ ] Tested on at least one phone browser and one desktop browser for UI or
      microphone changes.

## Commit messages

- Use the imperative mood and keep the first line under about 70 characters:
  `Add injury phrases for shoulder and wrist`.
- Explain why in the body when the change is not obvious.
- Keep each commit focused on one change.

## Changelog

Add every user-visible change to the **Unreleased** section of
[CHANGELOG.md](./CHANGELOG.md) in the same pull request. Follow the rules at
the top of that file.

## Pull requests

1. Make sure your branch is up to date with `main`.
2. Fill in the description: what changed, why, how you tested it (devices and
   browsers), and link the related issue (`Closes #12`).
3. Add screenshots for visual changes.
4. Keep pull requests small and focused; split unrelated changes.
5. A maintainer reviews the change. Address the feedback by pushing new
   commits to the same branch.

## Releases

Maintainers publish releases. Merges to `main` go live on
[GitHub Pages](https://fzaire.github.io/danish-english-handball-language/)
automatically. For a versioned release, the maintainer finalises the
changelog, tags the version and creates a GitHub release with
`danish-handball-trainer.html` attached, so the README download link serves
the new version.

## Questions

Open an [issue](https://github.com/fzaire/danish-english-handball-language/issues)
with your question. Please be respectful and constructive in all discussions.
