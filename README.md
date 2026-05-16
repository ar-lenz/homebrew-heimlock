# Heimlock

Heimlock is a local-first CI system that transforms messy AI-generated code into clean, reviewable pull requests. It intercepts `git push` operations through a local bare repo "gate", runs a transformation pipeline, and lets you review changes before forwarding to upstream.

This repository is the official Homebrew Cask tap for distributing the Heimlock desktop app and CLI.

---

## Installation

### Via Homebrew

```bash
brew tap ar-lenz/heimlock
brew install --cask heimlock
```

### Via direct download

Download the latest `.dmg` from the [files directory](https://github.com/ar-lenz/homebrew-heimlock/tree/main/files).

---

## System Requirements

- macOS Ventura (13.0) or later
- Apple Silicon (arm64) or Intel (x86_64)

---

## Verifying Installation

```bash
heimlock version
heimlockd version
```

---

## Upgrading

```bash
brew update
brew upgrade --cask heimlock
```

---

## Repository Structure

```
.
├── Casks/
│   └── heimlock.rb     # Homebrew Cask definition
└── files/
    └── *.dmg            # Release DMG archives
```

---

## Changelog

Release notes for each version are available in [CHANGELOG.md](CHANGELOG.md).

---

## Reporting Issues

File all issues in **this repository**. Use the [issue template](ISSUE_TEMPLATE.md) when submitting.


