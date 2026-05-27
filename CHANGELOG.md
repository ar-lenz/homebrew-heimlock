# Changelog

## v0.6.0

## What's Changed

### Window Transparency
macOS window transparency via private API, AppearanceProvider for opacity control, and CSS token refactor to support a single-layer translucency system. Tune opacity in Settings → Appearance.

### Workspace Dashboard
New sessions overview (RunCard + RunDashboard) with status-grouped, searchable cards replacing the auto-select-into-first-run flow. Centralized format and run-status utility modules consumed across all workspace components.

### Design System
Slider, Switch, IconWithStatus, StatusBadge primitives added to the design system, backed by Radix UI.

### Settings Overhaul
Settings rebuilt with a nav/row section system: model picker, provider toggle, agent catalog, appearance, and system sections.

### Default Steps Renamed
Default pipeline steps renamed for clarity — test, strict-review, dependencies, describe-document — and unused steps removed.

### Agent & Session Tracking
OpenCode usage capture, agent session persistence, and Claude Code hook fixes. Idle timeout bounds agent runtime.

### CI/CD
Homebrew tap publishing workflow, release note sync to CHANGELOG.md, and PR template enforcement.

## v0.5.11

## What's Changed

### Agent Sessions & Adapter
Added structured agent session tracking with token parsing, stderr transcript capture, and an opencode adapter for flexible agent integration. The workspace now displays agent final output directly instead of raw prompts.

### Deterministic Tests & Scans
All default pipeline steps (test, document, critique, e2e, performance, regression, security, strict-critique, breaking-changes) now use `HEIMLOCK_` environment variables for deterministic, reproducible execution. Pipeline env vars are wired through the entire executor stack.

### Workspace UI Overhaul
- New workflow graph with Mermaid-style edges, arrowheads, and GraphNode component for fan-out/fan-in visualization
- Activity feed, comment card, and workspace hook updates
- ErrorBoundary component for graceful error handling
- Daemon-health badge no longer flickers during poll

### CLI Improvements
- New `heimlock logs` command for viewing pipeline logs
- `heimlock memory` commands (list/add/rm/edit) for session memory management
- Init wizard improvements with better status feedback
- `pipeline_env` helper for `HEIMLOCK_`/`AIRLOCK_` env var fallback

### Auto-approve & Fix Pipeline
- Daemon auto-approve handler for streamlined PR workflows
- Fix event subscription system (FixStarted/Completed/NoChanges)
- Address comments with fix capture, JSON-tail prompts, and per-comment fix-state badges
- Bulk Fix toolbar in the workspace

### App & Tauri Integration
- Final output forwarded from daemon to frontend via IPC
- ErrorBoundary component for production resilience
- Tauri v2 app configuration updates

### Other Improvements
- Git commit module and diff updates for better patch management
- Patches are now resilient to bad patch input
- Ephemeral dirs (node_modules, etc.) excluded from patch capture
- Config loader and global config tweaks

### CI/CD & Infrastructure
- Release-please automation with Homebrew cask publishing
- PR template enforcement workflow
- Universal macOS binary builds
- Gitleaks secrets pre-scan embedded in daemon
