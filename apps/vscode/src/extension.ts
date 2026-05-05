import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    vscode.commands.registerCommand("seshat.openInReader", (resource?: vscode.Uri) => {
      const target = resolveMarkdownUri(resource);
      if (!target) {
        vscode.window.showWarningMessage("Seshat: no Markdown file to open.");
        return;
      }
      void openInSeshat("open", target);
    }),
    vscode.commands.registerCommand("seshat.openInWorkspace", (resource?: vscode.Uri) => {
      const target = resolveMarkdownUri(resource);
      if (!target) {
        vscode.window.showWarningMessage("Seshat: no Markdown file to reveal.");
        return;
      }
      void openInSeshat("global", target);
    }),
  );
}

export function deactivate() {}

function resolveMarkdownUri(resource: vscode.Uri | undefined): vscode.Uri | undefined {
  if (resource && resource.scheme === "file") return resource;
  const active = vscode.window.activeTextEditor?.document;
  if (active && active.uri.scheme === "file" && active.languageId === "markdown") {
    return active.uri;
  }
  return undefined;
}

async function openInSeshat(host: "open" | "global", file: vscode.Uri) {
  const encoded = encodeURIComponent(file.fsPath);
  const url = vscode.Uri.parse(`seshat://${host}?path=${encoded}`);
  const ok = await vscode.env.openExternal(url);
  if (!ok) {
    vscode.window.showErrorMessage(
      "Seshat could not open the document. Is the Seshat app installed and registered for the seshat:// URL scheme?",
    );
  }
}
