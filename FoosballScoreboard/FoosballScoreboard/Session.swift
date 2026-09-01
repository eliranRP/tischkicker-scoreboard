import SwiftUI
import UIKit

enum AppPhase: Equatable {
    case race
    case live
    case matchOver
}

@MainActor
@Observable
final class Session {
    var phase: AppPhase = .race
    var match = Match(raceTo: 5)
    var confirmReset = false
    var renaming: TeamSide?
    var renameDraft = ""

    var isCompactHeight: Bool = false

    func chooseRace(_ n: Int) {
        match.resetMatchKeepingNames(raceTo: n)
        phase = .live
        updateIdleTimer()
    }

    func addGoal(_ side: TeamSide) {
        guard phase == .live else { return }
        match.addGoal(side)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        if match.isOver {
            phase = .matchOver
        }
    }

    func undoLastGoal() {
        guard match.canUndo else { return }
        match.undoLastGoal()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if phase == .matchOver, !match.isOver {
            phase = .live
        }
    }

    func requestNewMatch() {
        confirmReset = true
    }

    func confirmNewMatch() {
        match.resetMatchKeepingNames()
        phase = .live
        confirmReset = false
        updateIdleTimer()
    }

    func playAgain() {
        match.startNextSet()
        phase = .live
        updateIdleTimer()
    }

    func changeRace() {
        match.resetMatchKeepingNames()
        phase = .race
        updateIdleTimer()
    }

    func beginRename(_ side: TeamSide) {
        renameDraft = match.customName(for: side)
        renaming = side
    }

    func saveRename() {
        guard let side = renaming else { return }
        match.setCustomName(renameDraft, for: side)
        renaming = nil
        renameDraft = ""
    }

    func cancelRename() {
        renaming = nil
        renameDraft = ""
    }

    func updateIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = (phase != .race)
    }

    func displayName(_ side: TeamSide) -> String {
        L10n.teamName(side, custom: match.customName(for: side))
    }
}

extension Session {
    static func preview(phase: AppPhase, red: Int, blue: Int, raceTo: Int = 5, redSets: Int = 0, blueSets: Int = 0) -> Session {
        let session = Session()
        session.match.raceTo = raceTo
        session.match.redScore = red
        session.match.blueScore = blue
        session.match.goalLog = Array(repeating: TeamSide.red, count: red) + Array(repeating: TeamSide.blue, count: blue)
        session.match.redSets = redSets
        session.match.blueSets = blueSets
        session.phase = phase
        return session
    }
}
