import SwiftUI

struct BoardChrome<Card: View>: View {
    let title: String
    let subtitle: String
    var compact: Bool = false
    @ViewBuilder var card: () -> Card

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: compact ? 4 : 8) {
                Text(title)
                    .font(AppFont.display(compact ? 22 : 30))
                    .foregroundStyle(Palette.paper)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.system(size: compact ? 13 : 15, weight: .regular))
                    .foregroundStyle(Color.white.opacity(0.94))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.top, compact ? 6 : 10)
            .padding(.bottom, compact ? 10 : 14)
            .frame(maxWidth: .infinity)
            .background(Palette.oak.ignoresSafeArea(edges: .top))

            Rectangle()
                .fill(Palette.brass)
                .frame(height: 3)

            ZStack {
                Palette.felt
                card()
            }
        }
        .background(Palette.felt.ignoresSafeArea())
    }
}

struct PaperCard<Content: View>: View {
    var compact: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(compact ? 12 : 18)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Palette.paper, in: RoundedRectangle(cornerRadius: compact ? 22 : 28, style: .continuous))
            .shadow(color: Palette.oakDark.opacity(0.28), radius: 10, y: 4)
            .padding(.horizontal, compact ? 12 : 18)
            .padding(.vertical, compact ? 12 : 20)
    }
}

struct PaperActionButton: View {
    let title: String
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.caption(16))
                .foregroundStyle(Palette.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Palette.paperShadow, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Palette.ink, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.38)
    }
}
