import SwiftUI

struct SeshatMark: View {
    var lineWidth: CGFloat = 1.5
    var color: Color = .primary

    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 100
            let stroke = StrokeStyle(
                lineWidth: lineWidth,
                lineCap: .round,
                lineJoin: .round
            )
            let shading = GraphicsContext.Shading.color(color)

            context.stroke(starPath(scale: scale), with: shading, style: stroke)
            context.stroke(headdressPath(scale: scale), with: shading, style: stroke)
            context.fill(capsPath(scale: scale), with: shading)
        }
        .accessibilityLabel("Seshat mark")
    }

    private func starPath(scale: CGFloat) -> Path {
        let cx: CGFloat = 50, cy: CGFloat = 56
        let outerR: CGFloat = 28, innerR: CGFloat = 11.5

        var path = Path()
        for i in 0..<14 {
            let r = i.isMultiple(of: 2) ? outerR : innerR
            let angle = (.pi * 2 * Double(i)) / 14 - .pi / 2
            let pt = CGPoint(
                x: (cx + r * CGFloat(cos(angle))) * scale,
                y: (cy + r * CGFloat(sin(angle))) * scale
            )
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }

    private func headdressPath(scale: CGFloat) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 28 * scale, y: 24 * scale))
        path.addQuadCurve(
            to: CGPoint(x: 72 * scale, y: 24 * scale),
            control: CGPoint(x: 50 * scale, y: 6 * scale)
        )
        path.move(to: CGPoint(x: 50 * scale, y: 6 * scale))
        path.addLine(to: CGPoint(x: 50 * scale, y: 28 * scale))
        return path
    }

    private func capsPath(scale: CGFloat) -> Path {
        var path = Path()
        for cx in [28.0, 72.0] {
            path.addEllipse(in: CGRect(
                x: (cx - 1.6) * scale,
                y: (24 - 1.6) * scale,
                width: 3.2 * scale,
                height: 3.2 * scale
            ))
        }
        return path
    }
}

#Preview {
    HStack(spacing: 24) {
        SeshatMark(lineWidth: 1.4, color: .seshatBodyText)
            .frame(width: 96, height: 96)
        SeshatMark(lineWidth: 2.0, color: .seshatAccent)
            .frame(width: 48, height: 48)
        SeshatMark(lineWidth: 2.2, color: .seshatBodyText)
            .frame(width: 24, height: 24)
        SeshatMark(lineWidth: 2.4, color: .seshatBodyText)
            .frame(width: 16, height: 16)
    }
    .padding(48)
    .background(Color.seshatPaper)
}
