# Seshat

Native macOS markdown reader with a CLI. Render `.md` files with Notion-grade typography; manage a folder-based library; open files from the terminal.

> **Status:** MVP scaffolding (Phase 1). Not buildable end-to-end yet.

## Layout

```
.
├── apps/
│   └── macos/             # SwiftUI app — open in Xcode after running xcodegen
│       ├── project.yml    # source of truth; regenerates Seshat.xcodeproj
│       └── Seshat/        # Swift sources, assets, Info.plist
└── cli/
    └── seshat             # Shell shim (Phase 7)
```

## Development

Requires: macOS 14+, Xcode 16+, [xcodegen](https://github.com/yonaskolb/XcodeGen).

```sh
brew install xcodegen
cd apps/macos && xcodegen generate
open Seshat.xcodeproj
```

The `.xcodeproj` is gitignored — regenerate from `project.yml` whenever sources/config change.

