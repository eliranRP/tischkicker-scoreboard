import Foundation

enum TeamSide: String, CaseIterable, Hashable {
    case red
    case blue
}

struct Match: Equatable {
    var raceTo: Int
    var redScore: Int = 0
    var blueScore: Int = 0
    var redCustomName: String = ""
    var blueCustomName: String = ""
    var goalLog: [TeamSide] = []
    var redSets: Int = 0
    var blueSets: Int = 0

    func score(for side: TeamSide) -> Int {
        side == .red ? redScore : blueScore
    }

    func customName(for side: TeamSide) -> String {
        side == .red ? redCustomName : blueCustomName
    }

    mutating func setCustomName(_ name: String, for side: TeamSide) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if side == .red {
            redCustomName = trimmed
        } else {
            blueCustomName = trimmed
        }
    }

    var winner: TeamSide? {
        if redScore >= raceTo { return .red }
        if blueScore >= raceTo { return .blue }
        return nil
    }

    var isOver: Bool { winner != nil }

    var canUndo: Bool { !goalLog.isEmpty }

    var hasSetsOnBoard: Bool { redSets > 0 || blueSets > 0 }

    mutating func addGoal(_ side: TeamSide) {
        guard !isOver else { return }
        if side == .red {
            redScore += 1
        } else {
            blueScore += 1
        }
        goalLog.append(side)
    }

    mutating func undoLastGoal() {
        guard let last = goalLog.popLast() else { return }
        if last == .red {
            redScore = max(0, redScore - 1)
        } else {
            blueScore = max(0, blueScore - 1)
        }
    }

    mutating func resetScores() {
        redScore = 0
        blueScore = 0
        goalLog = []
    }

    mutating func startNextSet() {
        if let winner {
            if winner == .red {
                redSets += 1
            } else {
                blueSets += 1
            }
        }
        resetScores()
    }

    mutating func resetMatchKeepingNames(raceTo: Int? = nil) {
        let names = (redCustomName, blueCustomName)
        self = Match(raceTo: raceTo ?? self.raceTo)
        redCustomName = names.0
        blueCustomName = names.1
    }
}
