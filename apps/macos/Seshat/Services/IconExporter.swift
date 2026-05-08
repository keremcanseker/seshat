import AppKit
import SwiftUI

@MainActor
enum IconExporter {
    private static let sizes: [Int] = [16, 32, 64, 128, 256, 512, 1024]

    static func exportAll(to outputDirectory: URL) throws {
        try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

        for size in sizes {
            let renderer = ImageRenderer(content: SeshatAppIcon(size: CGFloat(size)))
            renderer.scale = 1.0
            renderer.proposedSize = .init(width: CGFloat(size), height: CGFloat(size))

            guard let cgImage = renderer.cgImage else {
                throw ExportError.renderFailed(size: size)
            }
            let bitmap = NSBitmapImageRep(cgImage: cgImage)
            bitmap.size = NSSize(width: size, height: size)

            guard let data = bitmap.representation(using: .png, properties: [:]) else {
                throw ExportError.encodeFailed(size: size)
            }

            let fileURL = outputDirectory.appendingPathComponent("icon_\(size).png")
            try data.write(to: fileURL)
            seshatLog("IconExporter: wrote \(fileURL.path) (\(size)x\(size))")
        }

        try writeContentsJSON(to: outputDirectory)
    }

    private static func writeContentsJSON(to outputDirectory: URL) throws {
        let json = """
        {
          "images" : [
            { "filename" : "icon_16.png",   "idiom" : "mac", "scale" : "1x", "size" : "16x16" },
            { "filename" : "icon_32.png",   "idiom" : "mac", "scale" : "2x", "size" : "16x16" },
            { "filename" : "icon_32.png",   "idiom" : "mac", "scale" : "1x", "size" : "32x32" },
            { "filename" : "icon_64.png",   "idiom" : "mac", "scale" : "2x", "size" : "32x32" },
            { "filename" : "icon_128.png",  "idiom" : "mac", "scale" : "1x", "size" : "128x128" },
            { "filename" : "icon_256.png",  "idiom" : "mac", "scale" : "2x", "size" : "128x128" },
            { "filename" : "icon_256.png",  "idiom" : "mac", "scale" : "1x", "size" : "256x256" },
            { "filename" : "icon_512.png",  "idiom" : "mac", "scale" : "2x", "size" : "256x256" },
            { "filename" : "icon_512.png",  "idiom" : "mac", "scale" : "1x", "size" : "512x512" },
            { "filename" : "icon_1024.png", "idiom" : "mac", "scale" : "2x", "size" : "512x512" }
          ],
          "info" : { "author" : "xcode", "version" : 1 }
        }
        """
        let url = outputDirectory.appendingPathComponent("Contents.json")
        try json.write(to: url, atomically: true, encoding: .utf8)
        seshatLog("IconExporter: wrote \(url.path)")
    }

    enum ExportError: LocalizedError {
        case renderFailed(size: Int)
        case encodeFailed(size: Int)

        var errorDescription: String? {
            switch self {
            case .renderFailed(let size): return "Failed to render app icon at \(size)pt"
            case .encodeFailed(let size): return "Failed to encode app icon PNG at \(size)pt"
            }
        }
    }
}
