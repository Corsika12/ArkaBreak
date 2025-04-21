# ArkaBreak

> 📱 Native SwiftUI App — Retro Breakout game
> **Status**: MVP development in progress

---

# ✨ Table of Contents

1. 🎯 [Context](#🎯-context)
2. 🚀 [Roadmap](#🚀-roadmap)
3. 📂 [Structure](#📂-structure)
4. 🔐 [Data Storage](#🔐-data-storage)
5. ⚙️ [Settings](#⚙️-settings)
6. 🌟 [Credits](#🌟-credits)

---

## 🎯 Context
- **Method:** Agile project developed with Enzo (11 years old).
- **Technologies:** SwiftUI (MVVM architecture), Combine.
- **Minimum Deployments:** iOS 18.0; visionOS.
- **Targeted Device Families:**  iPhone, iPad, and Apple Vision Pro.
- **Main Objective:** Fun and educational learning of SwiftUI and gaming logic.

---

## 🚀 Roadmap
> See [`roadmap.md`](./roadmap.md) for sprint‑level plans and features.

---

## 📂 Structure

ArkaBreak/
├── 📂 App/
│   └── ArkaBreakApp.swift
│
├── 📂 Models/
│   ├── AudioFiles.swift
│   ├── Bonus.swift
│   └── GameModel.swift
│
├── 📂 ViewModels/
│   ├── BonusVM.swift
│   ├── CountdownManager.swift
│   ├── GameEngineVM.swift
│   └── PaddleVM.swift
│
├── 📂 Views/
│   ├── GameOverView.swift
│   ├── GameView.swift
│   ├── HomeView.swift
│   ├── OptionsView.swift
│   └── ScoresView.swift
│
├── 📂 Extensions/
│   └── ExtensionsGame.swift
│
├── 📂 Packages/
│   ├── AudioManager.swift
│   ├── CreditsAudio.md
│   └── info.plist
│
├── 📂 Resources/
│   ├── 📂 Sounds
│   ├── Assets.xcassets
│   └── LaunchScreen/
│
├── 📂 Storage/
│   └── (future: HighscoreStorage.swift)
│
└── Roadmap.md


## 🔐 Data Storage
- Player name is persisted locally using Swift's `@AppStorage`.
- 🎖 Highscores will be saved (future implementation).

---

## ⚙️ Settings
- **Player nickname:** Editable and saved via `@AppStorage("playerName")`.
- **Planned settings:** Sound effects; Difficulty level selector (e.g., Easy, Normal, Hard).

---

## 🌟 Credits
**Project:** Retro arcade game by the Safe e-Power team.
**Authors:** Enzo & Emmanuel CARRIE

**Audio Credits:** See [`CreditsAudio.md`](./Packages/CreditsAudio.md) for full attribution (FreeMusicArchive & Freesound.org licensed sounds).