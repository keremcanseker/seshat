import AppKit

// Renders the real SF Symbols used by the landing's macOS menu bar to white
// PNGs at 4x. Run on a Mac from apps/web:
//   swift scripts/sf-symbols.swift public/mb
let out = CommandLine.arguments[1]
let symbols: [(String, String, CGFloat, NSFont.Weight)] = [
  ("apple.logo", "apple", 13, .medium),
  ("battery.100", "battery", 13, .regular),
  ("wifi", "wifi", 13, .medium),
  ("switch.2", "control-centre", 13, .medium),
  ("magnifyingglass", "spotlight", 13, .semibold),
]
let scale: CGFloat = 4
for (name, file, pt, weight) in symbols {
  let cfg = NSImage.SymbolConfiguration(pointSize: pt, weight: weight, scale: .medium)
  guard let base = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(cfg) else {
    print("missing \(name)"); continue
  }
  let w = Int((base.size.width * scale).rounded(.up)), h = Int((base.size.height * scale).rounded(.up))
  let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: w, pixelsHigh: h, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
  rep.size = NSSize(width: w, height: h)
  NSGraphicsContext.saveGraphicsState()
  NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
  let rect = NSRect(x: 0, y: 0, width: w, height: h)
  base.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1)
  NSColor.white.set()
  rect.fill(using: .sourceIn)
  NSGraphicsContext.restoreGraphicsState()
  let png = rep.representation(using: .png, properties: [:])!
  try! png.write(to: URL(fileURLWithPath: "\(out)/mb-\(file).png"))
  print("\(file): \(base.size.width)x\(base.size.height) pt -> \(w)x\(h) px")
}
