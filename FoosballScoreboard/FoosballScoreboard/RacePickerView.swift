import SwiftUI

struct RacePickerView: View {
    @Bindable var session: Session
    var compact: Bool

    var body: some View {
        BoardChrome(title: L10n.raceTitle, subtitle: L10n.raceSubtitle, compact: compact) {
            PaperCard(compact: compact) {
                VStack(spacing: compact ? 16 : 24) {
                    Text(L10n.raceQuestion)
                        .font(AppFont.display(compact ? 28 : 36))
                        .foregroundStyle(Palette.ink)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    if compact {
                        HStack(spacing: 14) {
                            raceButton(to: 5, color: Palette.teamRed, caption: L10n.afterWork)
                            raceButton(to: 10, color: Palette.teamBlue, caption: L10n.longMatch)
                        }
                    } else {
                        VStack(spacing: 16) {
                            raceButton(to: 5, color: Palette.teamRed, caption: L10n.afterWork)
                            raceButton(to: 10, color: Palette.teamBlue, caption: L10n.longMatch)
                        }
                    }

                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func raceButton(to n: Int, color: Color, caption: String) -> some View {
        Button {
            session.chooseRace(n)
        } label: {
            VStack(spacing: 6) {
                Text(L10n.firstTo(n))
                    .font(AppFont.display(compact ? 26 : 34))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                Text(caption)
                    .font(.system(size: compact ? 14 : 16, weight: .regular))
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, compact ? 22 : 30)
            .background(color, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(L10n.a11yPickRace(n))
    }
}
