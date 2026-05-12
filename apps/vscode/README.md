# Seshat VSCode Extension

Open the Markdown file you're editing in the [Seshat](../../README.md) reader, or reveal it inside the Seshat workspace sidebar.

## What it adds

| Command | Where it appears | What it does |
|---|---|---|
| **Open in Seshat** | Editor title bar (book icon), explorer context menu, Command Palette | Opens the current `.md` file in a new Seshat reader window via `seshat://open?path=…` |
| **Reveal in Seshat Workspace** | Command Palette | Opens the Seshat workspace and selects this file in the sidebar via `seshat://global?path=…` (the macOS app copies the file into `~/Seshat/Inbox/` if it's outside the library) |

Both commands are scoped to `resourceLangId == markdown && resourceScheme == file`, so they only show up for real markdown files on disk.

## Prerequisite

The Seshat macOS app must be installed and launched at least once. macOS registers the `seshat://` URL scheme via Launch Services on first launch — without that, `vscode.env.openExternal(...)` will fail to find a handler and the extension shows a "Seshat could not open the document" warning.

## Install

```sh
code --install-extension apps/vscode/seshat-vscode-0.1.0.vsix
```

Compatible with VSCode, Cursor, VSCodium, and other forks (uses only the public `vscode.commands` and `vscode.env.openExternal` APIs).

## Development

```sh
cd apps/vscode
bun install
bun run watch
```

Then press **F5** in VSCode with this folder open to launch a *Extension Development Host* window where the extension is loaded. Edit `src/extension.ts`, save, and the host picks up changes on relaunch.

## Repackage the `.vsix`

```sh
cd apps/vscode
npx vsce package
```

Produces `seshat-vscode-<version>.vsix` in this directory.

## Marketplace publishing

Not yet — `.vsix` only. See Linear KER-294 / KER-298 / KER-302 for the Marketplace track.
