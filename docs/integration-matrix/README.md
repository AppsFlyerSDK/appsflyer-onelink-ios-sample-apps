# Integration matrix — v7 reference

This directory maps the DevHub iOS code-generation matrix to v7-correct snippets. Each snippet is copied **verbatim** from one of the three sample apps in this repo (`obj-c/`, `swift/basic_app/`, `swiftui/basic_app_swiftui/`), so the docs and runnable code stay in lockstep.

The v7 default spine is [`registerSessionReadyListener`](flags/session-ready-listener.md) — the SDK's official timing gate. Every other flag layers onto it. If you're coming from v6, the [v6 → v7 migration page](migration/v6-to-v7.md) covers why the `NotificationCenter.didBecomeActive → start()` workaround is gone and what the SceneDelegate flag means now.

## Preset permutations

| Preset | Description | Swift snippet | ObjC snippet | Source sample |
|--------|-------------|---------------|--------------|---------------|
| `minimal` | Debug + initialize + delegates + handleLaunchOptions + registerSessionReadyListener + start. No ATT, no CUID, no SceneDelegate. | [`snippets/swift/minimal.swift`](snippets/swift/minimal.swift) | [`snippets/objc/minimal.m`](snippets/objc/minimal.m) | derived from `swift/basic_app/` and `obj-c/` |
| `all-flags-on` | Every matrix flag enabled: Debug + CUID + delegates + handleLaunchOptions + Session-ready listener wrapping ATT + start with completion handler. | [`snippets/swift/all-flags-on.swift`](snippets/swift/all-flags-on.swift) | [`snippets/objc/all-flags-on.m`](snippets/objc/all-flags-on.m) | `swift/basic_app/basic_app/AppDelegate.swift`, `obj-c/obj-c/AppDelegate.m` |
| `scene-delegate` | The SceneDelegate file alone (deep-link routing). Pairs with any AppDelegate preset. | [`snippets/swift/scene-delegate.swift`](snippets/swift/scene-delegate.swift) | [`snippets/objc/scene-delegate.m`](snippets/objc/scene-delegate.m) | `swift/basic_app/basic_app/SceneDelegate.swift`, `obj-c/obj-c/SceneDelegate.m` |
| `att-only` | `minimal` + ATT request inside the session-ready block, before `start()`. | combine [`minimal.swift`](snippets/swift/minimal.swift) with the ATT block from [`all-flags-on.swift`](snippets/swift/all-flags-on.swift) | combine [`minimal.m`](snippets/objc/minimal.m) with the ATT block from [`all-flags-on.m`](snippets/objc/all-flags-on.m) | `swift/basic_app/basic_app/AppDelegate.swift`, `obj-c/obj-c/AppDelegate.m` |
| `cuid-only` | `minimal` + CUID assignment before delegates. | combine [`minimal.swift`](snippets/swift/minimal.swift) with the CUID line from [`all-flags-on.swift`](snippets/swift/all-flags-on.swift) | combine [`minimal.m`](snippets/objc/minimal.m) with the CUID line from [`all-flags-on.m`](snippets/objc/all-flags-on.m) | `swift/basic_app/basic_app/AppDelegate.swift`, `obj-c/obj-c/AppDelegate.m` |

The full 16-cell cross product of the four toggleable flags is not enumerated — only the named presets above. Add or remove the matching block from `all-flags-on` to build any other combination.

## Per-flag pages

| Flag | Page | DevHub label |
|------|------|--------------|
| Debug logs | [flags/debug-logs.md](flags/debug-logs.md) | Debug logs |
| SceneDelegate support | [flags/scene-delegate.md](flags/scene-delegate.md) | SceneDelegate |
| ATT | [flags/att.md](flags/att.md) | ATT |
| Customer User ID | [flags/customer-user-id.md](flags/customer-user-id.md) | Customer User ID (CUID) |
| Session-ready listener | [flags/session-ready-listener.md](flags/session-ready-listener.md) | Session-ready listener (v7 default spine — always on) |

## Migration

- [v6 → v7 SceneDelegate migration](migration/v6-to-v7.md) — why the `didBecomeActive` observer is gone, what the SceneDelegate flag means in v7, and what to do for SwiftUI lifecycle apps.

## Sample app reference

| Sample | AppDelegate | SceneDelegate |
|--------|-------------|---------------|
| obj-c | `obj-c/obj-c/AppDelegate.m` | `obj-c/obj-c/SceneDelegate.m` |
| swift | `swift/basic_app/basic_app/AppDelegate.swift` | `swift/basic_app/basic_app/SceneDelegate.swift` |
| swiftui | `swiftui/basic_app_swiftui/AppDelegate.swift` | n/a — `WindowGroup` owns scene management; deep links handled via `.onContinueUserActivity` + `.onOpenURL` in `swiftui/basic_app_swiftui/Screens/MainView.swift` |

Grep `[Matrix flag]` in any of the AppDelegate files to find the marked region for each toggle.
