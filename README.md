# Handball Dansk

A Danish-English language trainer for handball players joining a Danish team.
The current application is a standalone HTML file with 213 phrases across 11
sections, from coach shouts and positions to everyday conversation.

## Run

Download or clone this repository, then open
[danish-handball-trainer.html](./danish-handball-trainer.html) in a browser.
No build step, package installation, or backend is required.

For hosted use, serve the file over HTTPS. Microphone access depends on browser
permissions and may be restricted for local files or insecure HTTP pages.

## Features

- Search Danish and English phrases.
- Listen using your device's Danish voice at normal or slow speed.
- Practise speaking with browser speech recognition and transcript-based scores.
- Optionally record audio for playback during practice.
- Take multiple-choice listening quizzes.
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

## Project documents

- [PDF phrasebook](./Danish_for_Handball_Samuel.pdf)
- [Word phrasebook](./Danish_for_Handball_Samuel.docx)
- [Product specification](./specification.md): roadmap for future development;
  features described there are not all implemented in the current trainer.

Local memory databases are excluded from version control.
