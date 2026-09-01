import SwiftUI

struct ScoreboardView: View {
    @Bindable var session: Session
    var compact: Bool

    private var match: Match { session.match }
    private var isOver: Bool { session.phase == .matchOver }

    var body: some View {
        BoardChrome(title: headerTitle, subtitle: headerSubtitle, compact: compact) {
            PaperCard(compact: compact) {
                VStack(spacing: compact ? 10 : 14) {
                    HStack(spacing: compact ? 10 : 14) {
                        teamColumn(.red)
                        teamColumn(.blue)
                    }
                    .frame(maxHeight: .infinity)

                    if isOver {
                        Button(action: session.playAgain) {
                            Text(L10n.playAgain)
                                .font(AppFont.display(compact ? 22 : 26))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, compact ? 14 : 18)
                                .background(winnerColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Palette.ink, lineWidth: 1.5)
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(L10n.playAgain)
                    }

                    HStack(spacing: 12) {
                        PaperActionButton(title: L10n.lastGoal, enabled: match.canUndo, action: session.undoLastGoal)
                            .accessibilityLabel(L10n.a11yLastGoal)
                        PaperActionButton(title: isOver ? L10n.changeRace : L10n.newMatch, action: {
                            if isOver {
                                session.changeRace()
                            } else {
                                session.requestNewMatch()
                            }
                        })
                        .accessibilityLabel(isOver ? L10n.changeRace : L10n.a11yNewMatch)
                    }

                    VStack(spacing: 4) {
                        Text(L10n.firstTo(match.raceTo))
                            .font(AppFont.display(compact ? 16 : 18))
                            .foregroundStyle(Palette.ink)
                        if match.hasSetsOnBoard {
                            Text(L10n.sets(match.redSets, match.blueSets))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Palette.inkMuted)
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
        .confirmationDialog(L10n.resetTitle, isPresented: $session.confirmReset, titleVisibility: .visible) {
            Button(L10n.resetConfirm, role: .destructive, action: session.confirmNewMatch)
            Button(L10n.cancel, role: .cancel) { session.confirmReset = false }
        } message: {
            Text(L10n.resetMessage)
        }
        .alert(L10n.renameTitle, isPresented: renamePresented) {
            TextField(session.renaming.map(session.displayName) ?? "", text: $session.renameDraft)
                .textInputAutocapitalization(.words)
            Button(L10n.save, action: session.saveRename)
            Button(L10n.cancel, role: .cancel, action: session.cancelRename)
        }
    }

    private var renamePresented: Binding<Bool> {
        Binding(
            get: { session.renaming != nil },
            set: { if !$0 { session.cancelRename() } }
        )
    }

    private var headerTitle: String {
        if isOver, let winner = match.winner {
            return L10n.wins(session.displayName(winner))
        }
        return L10n.liveTitle
    }

    private var headerSubtitle: String {
        isOver ? L10n.overSubtitle : L10n.liveSubtitle
    }

    private var winnerColor: Color {
        match.winner == .blue ? Palette.teamBlue : Palette.teamRed
    }

    private func teamColumn(_ side: TeamSide) -> some View {
        TeamColumnView(
            side: side,
            name: session.displayName(side),
            score: match.score(for: side),
            raceTo: match.raceTo,
            isOver: isOver,
            isWinner: match.winner == side,
            compact: compact,
            onGoal: { session.addGoal(side) },
            onRename: { session.beginRename(side) }
        )
    }
}

struct TeamColumnView: View {
    let side: TeamSide
    let name: String
    let score: Int
    let raceTo: Int
    let isOver: Bool
    let isWinner: Bool
    let compact: Bool
    let onGoal: () -> Void
    let onRename: () -> Void

    private var color: Color { side == .red ? Palette.teamRed : Palette.teamBlue }

    var body: some View {
        VStack(spacing: compact ? 8 : 12) {
            Button(action: onRename) {
                Text(name)
                    .font(AppFont.caption(compact ? 15 : 17))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 14)
                    .padding(.vertical, compact ? 6 : 8)
                    .frame(maxWidth: .infinity)
                    .background(color, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.a11yEditName(name))

            Button(action: onGoal) {
                VStack(spacing: compact ? 8 : 12) {
                    GeometryReader { geo in
                        let size = min(geo.size.width * 0.95, geo.size.height)
                        Text("\(score)")
                            .font(AppFont.score(max(size, 28)))
                            .foregroundStyle(Palette.ink)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel(L10n.a11yScore(name, score))

                    TallyGrid(filled: min(score, raceTo), total: raceTo, color: color)

                    if !isOver {
                        Text(L10n.addGoal)
                            .font(AppFont.display(compact ? 20 : 24))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, compact ? 12 : 16)
                            .background(color, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Palette.ink, lineWidth: 1.5)
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(isOver)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .accessibilityLabel(L10n.a11yAddGoal(name))
            .accessibilityAddTraits(.isButton)
        }
        .padding(compact ? 8 : 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(color, lineWidth: isWinner ? 3 : 2)
        )
        .opacity(isOver && !isWinner ? 0.5 : 1)
    }
}

struct TallyGrid: View {
    let filled: Int
    let total: Int
    let color: Color

    var body: some View {
        let columns = Array(
            repeating: GridItem(.flexible(minimum: 8, maximum: 22), spacing: 5),
            count: 5
        )
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(0..<total, id: \.self) { index in
                Rectangle()
                    .fill(index < filled ? color : Color.clear)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Rectangle()
                            .stroke(Palette.ink, lineWidth: 1.5)
                    )
                    .frame(maxWidth: 20, maxHeight: 20)
            }
        }
        .frame(maxWidth: 140)
    }
}
