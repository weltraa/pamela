<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Release][release-shield]][release-url]
[![Platform][platform-shield]][platform-url]
[![Swift][swift-shield]][swift-url]
[![License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/weltraa/pamela">
    <img src="app/Assets.xcassets/AppIcon.appiconset/PamelaAppIcon-1024.png" alt="Pamela" width="80" height="80">
  </a>

  <h3 align="center">Pamela</h3>

  <p align="center">
    A personal mission &amp; everyday log assistant for iOS.
    <br />
    Track your habits, your reading, your films and your sober streaks — all in one place.
    <br />
    <br />
    <a href="https://github.com/weltraa/pamela/issues/new?labels=bug">Report Bug</a>
    &middot;
    <a href="https://github.com/weltraa/pamela/issues/new?labels=enhancement">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

Pamela — **P**erson**a**l **M**ission & **E**veryday **L**og **A**ssistant — is an
iOS app that keeps the things you're working on in one place, the way a game keeps
your mission log: what you set out to do, and how far along you are.

It is built for a single person on a single device. Everything you record stays on
your iPhone: no account, no sign-in, no network calls, no analytics.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Features

**Tasks** — a day-by-day checklist with a week calendar.

* One-off, daily or weekly tasks, with the weekdays you pick.
* Swipe right to complete, swipe left to delete, tap a title to rename it.
* Completion is recorded per day, so a daily task starts fresh each morning
  without losing its history.
* Each section shows how many of its tasks are done.

**Books** — the shelf you own, chapter by chapter.

* Title, year and up to two authors, plus "et al." for the rest.
* Give a book its table of contents, then tick chapters off as you read.
* Every book shows the share of chapters you've finished.

**Movies** — the films you've watched.

* Title, year and up to two directors, plus "et al.".
* Filter the list by year or by director.
* The same film can't be added twice, though remakes keep their own year.

**Sobriety** — time free of something, counted live.

* A deck of cards, Wallet-style; tap one to bring it to the front.
* Counts years down to seconds from the date and time you set, ticking every second.

**Appearance** — three themes.

* Classic Light and Classic Dark follow Apple's system colors.
* Retro rebuilds the app in the skeuomorphic iOS 6 look: glossy bars, linen
  backdrop and bordered cards.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* [![Swift][swift-badge]][swift-url]
* [![SwiftUI][swiftui-badge]][swiftui-url]
* [![SwiftData][swiftdata-badge]][swiftdata-url]
* [![Xcode][xcode-badge]][xcode-url]
* [![SwiftLint][swiftlint-badge]][swiftlint-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

* macOS with Xcode 26.5 or later
* An iPhone running iOS 26.5 or later, or the iOS Simulator
* An Apple ID added to Xcode, to sign the app for a physical device

### Installation

1. Clone the repo
   ```sh
   git clone git@github.com:weltraa/pamela.git
   ```
2. Open the project in Xcode
   ```sh
   open Pamela/Pamela.xcodeproj
   ```
3. Let Xcode resolve the SwiftLint plugin package, then trust it when prompted
   (**Trust & Enable**).
4. Pick your signing team under **Pamela → Signing & Capabilities**.
5. Select your device or a simulator and run with `⌘R`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Source-available under the [PolyForm Strict License 1.0.0](LICENSE). Not open
source: redistribution and modification are not permitted.

Copyright (c) 2026 weltraa. All rights reserved.

<!-- MARKDOWN LINKS & IMAGES -->
[release-shield]: https://img.shields.io/github/v/tag/weltraa/pamela?style=for-the-badge&label=release
[release-url]: https://github.com/weltraa/pamela/tags
[platform-shield]: https://img.shields.io/badge/platform-iOS%2026.5%2B-lightgrey?style=for-the-badge&logo=apple
[platform-url]: https://www.apple.com/ios/
[swift-shield]: https://img.shields.io/badge/Swift-6-F05138?style=for-the-badge&logo=swift&logoColor=white
[license-shield]: https://img.shields.io/badge/license-PolyForm%20Strict%201.0.0-blue?style=for-the-badge
[license-url]: LICENSE
[swift-badge]: https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white
[swift-url]: https://www.swift.org/
[swiftui-badge]: https://img.shields.io/badge/SwiftUI-0071E3?style=for-the-badge&logo=swift&logoColor=white
[swiftui-url]: https://developer.apple.com/xcode/swiftui/
[swiftdata-badge]: https://img.shields.io/badge/SwiftData-1D63ED?style=for-the-badge&logo=swift&logoColor=white
[swiftdata-url]: https://developer.apple.com/xcode/swiftdata/
[xcode-badge]: https://img.shields.io/badge/Xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white
[xcode-url]: https://developer.apple.com/xcode/
[swiftlint-badge]: https://img.shields.io/badge/SwiftLint-FA7343?style=for-the-badge&logo=swift&logoColor=white
[swiftlint-url]: https://github.com/realm/SwiftLint
