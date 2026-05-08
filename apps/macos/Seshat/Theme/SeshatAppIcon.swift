import SwiftUI

struct SeshatAppIcon: View {
    let size: CGFloat

    private static let paperCream = Color(red: 252/255, green: 250/255, blue: 247/255)
    private static let bodyWarm = Color(red: 42/255, green: 37/255, blue: 34/255)

    private var shapeSize: CGFloat { size * 0.8047 }
    private var cornerRadius: CGFloat { shapeSize * 0.2237 }

    private var markSize: CGFloat {
        shapeSize < 52 ? shapeSize * 0.62 : shapeSize * 0.55
    }

    private var markStroke: CGFloat {
        max(1.0, markSize / 50)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Self.paperCream)
                .overlay {
                    SeshatMark(lineWidth: markStroke, color: Self.bodyWarm)
                        .frame(width: markSize, height: markSize)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.40), Color.white.opacity(0)],
                            startPoint: .top,
                            endPoint: UnitPoint(x: 0.5, y: 0.30)
                        ))
                        .allowsHitTesting(false)
                }
                .frame(width: shapeSize, height: shapeSize)
                .shadow(color: Color.black.opacity(0.18), radius: size * 0.018, y: size * 0.012)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(alignment: .center, spacing: 24) {
        SeshatAppIcon(size: 256)
        VStack(spacing: 16) {
            SeshatAppIcon(size: 128)
            HStack(spacing: 12) {
                SeshatAppIcon(size: 64)
                SeshatAppIcon(size: 32)
                SeshatAppIcon(size: 16)
            }
        }
    }
    .padding(48)
    .background(Color.seshatBgSubtle)
}
