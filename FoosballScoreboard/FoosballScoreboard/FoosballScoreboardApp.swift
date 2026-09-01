import SwiftUI

@main
struct FoosballScoreboardApp: App {
    @State private var session = Session()

    init() {
        BundledFonts.register()
    }

    var body: some Scene {
        WindowGroup {
            RootView(session: session)
                .preferredColorScheme(.light)
        }
    }
}

struct RootView: View {
    @Bindable var session: Session

    var body: some View {
        GeometryReader { geo in
            let compact = geo.size.height < 520
            content(compact: compact)
                .onAppear {
                    session.isCompactHeight = compact
                    session.updateIdleTimer()
                }
                .onChange(of: compact) { _, newValue in
                    session.isCompactHeight = newValue
                }
                .onChange(of: session.phase) { _, _ in
                    session.updateIdleTimer()
                }
        }
        .background(Palette.felt.ignoresSafeArea())
        .dynamicTypeSize(.medium ... .accessibility2)
        .persistentSystemOverlays(session.phase == .race ? .automatic : .hidden)
    }

    @ViewBuilder
    private func content(compact: Bool) -> some View {
        switch session.phase {
        case .race:
            RacePickerView(session: session, compact: compact)
        case .live, .matchOver:
            ScoreboardView(session: session, compact: compact)
        }
    }
}

#Preview("Race DE") {
    RootView(session: .preview(phase: .race, red: 0, blue: 0))
        .environment(\.locale, Locale(identifier: "de"))
}

#Preview("Live 0-0") {
    RootView(session: .preview(phase: .live, red: 0, blue: 0))
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview("Live 4-3 DE") {
    RootView(session: .preview(phase: .live, red: 4, blue: 3))
        .environment(\.locale, Locale(identifier: "de"))
}

#Preview("Live 3-2 EN") {
    RootView(session: .preview(phase: .live, red: 3, blue: 2))
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview("Match won") {
    RootView(session: .preview(phase: .matchOver, red: 5, blue: 3))
        .environment(\.locale, Locale(identifier: "de"))
}
