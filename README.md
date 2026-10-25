# Handball Dansk

A Danish-English language trainer for handball players joining a Danish team.
The current application is a standalone HTML file with 213 phrases across 11
sections, from coach shouts and positions to everyday conversation.

## Run

**[Open Handball Dansk online](https://fzaire.github.io/danish-english-handball-language/)**
(recommended, works on phones and computers). It is served over HTTPS, so the
microphone and pronunciation checks work. On a phone, use **Add to Home Screen**
to open it like an app.

### Offline copy

[Download the trainer HTML file directly](https://github.com/fzaire/danish-english-handball-language/releases/latest/download/danish-handball-trainer.html).
This downloads the latest released trainer instead of displaying its source.
Open the downloaded file in your browser. To choose where it is saved, enable
your browser's "Ask where to save each file before downloading" setting.

Download or clone this repository, then open
[danish-handball-trainer.html](./danish-handball-trainer.html) in a browser.
No build step, package installation, or backend is required.

Microphone access may be blocked for downloaded files, especially on phones;
use the online link for pronunciation checks.

## Features

- Search Danish and English phrases.
- Listen using your device's Danish voice at normal or slow speed.
- Practise speaking with browser speech recognition and transcript-based scores.
- Optionally record audio for playback during practice.
- Take multiple-choice listening quizzes. Phrases with "/" alternatives become
  separate questions, you can go back to earlier questions, and each answer is
  followed by a required pronunciation recording before moving on (skipped
  automatically when speech recognition or the microphone is unavailable).
- Track XP, streaks, and best phrase scores in browser local storage.

## Browser requirements and limitations

Chrome, Edge, and Safari are recommended. Speech synthesis voices and Danish
speech recognition availability depend on the browser and operating system.
Firefox can display the phrases but does not provide the recognition feature.
Installing a Danish system voice improves audio output.

Pronunciation scores compare the recognised transcript with the expected text;
they are not phoneme-level assessments. Speech recognition may require an
internet connection and may send audio to the browser vendor's speech service.
Progress is local to the current browser and device.

## Enable the microphone

The microphone is used for pronunciation checks in the practice sheet and the
quiz. When you first tap 🎤, the browser asks for permission: choose **Allow**.
If you previously blocked it, or the app shows "Microphone blocked", allow it
in the browser, then in the operating system, and reload the page.

### 1. Allow the page in the browser

| Browser | Steps |
|---|---|
| Chrome (computer) | Click the icon left of the address bar > **Site settings** > **Microphone** > **Allow**. All sites: `chrome://settings/content/microphone`. |
| Edge (computer) | Click the icon left of the address bar > **Permissions for this site** > **Microphone** > **Allow**. All sites: `edge://settings/content/microphone`. |
| Safari (Mac) | **Safari** > **Settings** > **Websites** > **Microphone** > set this page to **Allow**. |
| Chrome (Android) | Tap the icon left of the address bar > **Permissions** > **Microphone** > **Allow**. |
| Safari (iPhone/iPad) | Tap **aA** in the address bar > **Website Settings** > **Microphone** > **Allow**. |

### 2. Allow the browser in the operating system

| System | Steps |
|---|---|
| macOS | **System Settings** > **Privacy & Security** > **Microphone** > turn on your browser. Restart the browser. |
| Windows | **Settings** > **Privacy & security** > **Microphone** > turn on **Microphone access** and **Let desktop apps access your microphone**. |
| Android | **Settings** > **Apps** > your browser > **Permissions** > **Microphone** > **Allow**. |
| iPhone/iPad | **Settings** > **Apps** > **Safari** > **Microphone** > **Allow**. For Safari speech recognition, also turn on **Settings** > **General** > **Keyboard** > **Enable Dictation**. |

### Still not working?

- Use Chrome, Edge or Safari; Firefox has no speech recognition.
- Close other apps using the microphone (video calls, recorders).
- Speech recognition usually needs an internet connection.
- Phones often block the microphone for downloaded HTML files. Use the
  [online version](https://fzaire.github.io/danish-english-handball-language/)
  instead.

## Project documents

- [PDF phrasebook](./Danish_for_Handball_Samuel.pdf)
- [Word phrasebook](./Danish_for_Handball_Samuel.docx)
- [Product specification](./specification.md): roadmap for future development;
  features described there are not all implemented in the current trainer.
- [Changelog](./CHANGELOG.md): release history. When contributing, add your
  user-visible changes to its **Unreleased** section.

## Contributing

Bug reports, phrase corrections from Danish speakers and improvements are
welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md).

Local memory databases are excluded from version control.
