import SwiftUI

struct SeshatStar: Shape {
    var pointCount: Int = 7
    var innerRatio: CGFloat = 11.5 / 28

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerR = radius
        let innerR = radius * innerRatio
        let steps = pointCount * 2

        var path = Path()
        for i in 0..<steps {
            let r = i.isMultiple(of: 2) ? outerR : innerR
            let angle = (.pi * 2 * Double(i)) / Double(steps) - .pi / 2
            let pt = CGPoint(
                x: center.x + r * CGFloat(cos(angle)),
                y: center.y + r * CGFloat(sin(angle))
            )
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}
