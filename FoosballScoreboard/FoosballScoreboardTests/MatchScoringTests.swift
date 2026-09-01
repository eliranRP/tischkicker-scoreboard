import XCTest
@testable import FoosballScoreboard

/// Logic tests for first-to-N scoring. No UI identifiers.
/// Mac: Product → Test, or
/// `xcodebuild -project FoosballScoreboard/FoosballScoreboard.xcodeproj -scheme FoosballScoreboard -destination 'platform=iOS Simulator,name=iPhone 16' test`
final class MatchScoringTests: XCTestCase {
    func testRaceFirstToFiveEndsWhenATeamReachesFive() {
        var match = Match(raceTo: 5)
        for _ in 0..<4 { match.addGoal(.red) }
        match.addGoal(.blue)
        XCTAssertFalse(match.isOver)
        XCTAssertNil(match.winner)

        match.addGoal(.red)
        XCTAssertEqual(match.redScore, 5)
        XCTAssertEqual(match.blueScore, 1)
        XCTAssertTrue(match.isOver)
        XCTAssertEqual(match.winner, .red)
    }

    func testRaceFirstToTenDoesNotEndAtFive() {
        var match = Match(raceTo: 10)
        for _ in 0..<5 { match.addGoal(.blue) }
        XCTAssertEqual(match.blueScore, 5)
        XCTAssertFalse(match.isOver)
        XCTAssertNil(match.winner)

        for _ in 0..<5 { match.addGoal(.blue) }
        XCTAssertEqual(match.blueScore, 10)
        XCTAssertTrue(match.isOver)
        XCTAssertEqual(match.winner, .blue)
    }

    func testGoalIncrementsForTwoTeams() {
        var match = Match(raceTo: 10)
        match.addGoal(.red)
        match.addGoal(.red)
        match.addGoal(.blue)
        XCTAssertEqual(match.score(for: .red), 2)
        XCTAssertEqual(match.score(for: .blue), 1)
        XCTAssertEqual(match.goalLog, [.red, .red, .blue])
    }

    func testUndoLastGoalRevertsTheMostRecentSide() {
        var match = Match(raceTo: 5)
        match.addGoal(.red)
        match.addGoal(.blue)
        match.addGoal(.blue)
        match.undoLastGoal()
        XCTAssertEqual(match.redScore, 1)
        XCTAssertEqual(match.blueScore, 1)
        XCTAssertEqual(match.goalLog, [.red, .blue])
        match.undoLastGoal()
        XCTAssertEqual(match.blueScore, 0)
        XCTAssertEqual(match.redScore, 1)
    }

    func testUndoIsSafeWhenScoreIsZeroZero() {
        var match = Match(raceTo: 5)
        XCTAssertFalse(match.canUndo)
        match.undoLastGoal()
        XCTAssertEqual(match.redScore, 0)
        XCTAssertEqual(match.blueScore, 0)
        XCTAssertTrue(match.goalLog.isEmpty)
        XCTAssertFalse(match.isOver)
    }

    func testResetMatchKeepingNamesZerosScoresAndSetsButKeepsRaceAndNames() {
        var match = Match(raceTo: 10)
        match.setCustomName("Kitchen", for: .red)
        match.setCustomName("Bar", for: .blue)
        match.addGoal(.red)
        match.addGoal(.blue)
        match.redSets = 2
        match.blueSets = 1

        match.resetMatchKeepingNames()

        XCTAssertEqual(match.raceTo, 10)
        XCTAssertEqual(match.redScore, 0)
        XCTAssertEqual(match.blueScore, 0)
        XCTAssertTrue(match.goalLog.isEmpty)
        XCTAssertEqual(match.redSets, 0)
        XCTAssertEqual(match.blueSets, 0)
        XCTAssertEqual(match.customName(for: .red), "Kitchen")
        XCTAssertEqual(match.customName(for: .blue), "Bar")
        XCTAssertFalse(match.isOver)
    }

    func testResetMatchCanChangeRaceTarget() {
        var match = Match(raceTo: 5)
        match.resetMatchKeepingNames(raceTo: 10)
        XCTAssertEqual(match.raceTo, 10)
        XCTAssertEqual(match.redScore, 0)
        XCTAssertEqual(match.blueScore, 0)
    }

    func testMatchOverRecordsWinnerWhenRaceTargetReached() {
        var match = Match(raceTo: 5)
        for _ in 0..<5 { match.addGoal(.blue) }
        XCTAssertTrue(match.isOver)
        XCTAssertEqual(match.winner, .blue)
        match.addGoal(.red)
        XCTAssertEqual(match.redScore, 0, "Further goals must not count after the match is over")
        XCTAssertEqual(match.blueScore, 5)
        XCTAssertEqual(match.winner, .blue)
    }

    func testStartNextSetKeepsSetCountsAndRaceThenZerosScores() {
        var match = Match(raceTo: 5)
        match.setCustomName("Home", for: .red)
        for _ in 0..<5 { match.addGoal(.red) }
        XCTAssertEqual(match.winner, .red)

        match.startNextSet()

        XCTAssertEqual(match.redSets, 1)
        XCTAssertEqual(match.blueSets, 0)
        XCTAssertEqual(match.redScore, 0)
        XCTAssertEqual(match.blueScore, 0)
        XCTAssertEqual(match.raceTo, 5)
        XCTAssertEqual(match.customName(for: .red), "Home")
        XCTAssertFalse(match.isOver)
        XCTAssertTrue(match.hasSetsOnBoard)
    }

    func testPlayAgainThenWinForOtherSideAccumulatesSets() {
        var match = Match(raceTo: 5)
        for _ in 0..<5 { match.addGoal(.red) }
        match.startNextSet()
        for _ in 0..<5 { match.addGoal(.blue) }
        match.startNextSet()
        XCTAssertEqual(match.redSets, 1)
        XCTAssertEqual(match.blueSets, 1)
        XCTAssertEqual(match.raceTo, 5)
        XCTAssertEqual(match.redScore, 0)
        XCTAssertEqual(match.blueScore, 0)
    }

    func testCustomTeamNamesDoNotAffectScoring() {
        var match = Match(raceTo: 5)
        match.setCustomName("  Rot-Weiß  ", for: .red)
        match.setCustomName("Blau", for: .blue)
        XCTAssertEqual(match.customName(for: .red), "Rot-Weiß")

        match.addGoal(.red)
        match.addGoal(.blue)
        match.addGoal(.red)
        XCTAssertEqual(match.redScore, 2)
        XCTAssertEqual(match.blueScore, 1)

        match.setCustomName("", for: .red)
        XCTAssertEqual(match.customName(for: .red), "")
        match.addGoal(.red)
        XCTAssertEqual(match.redScore, 3)
    }

    func testUndoWinningGoalClearsWinner() {
        var match = Match(raceTo: 5)
        for _ in 0..<5 { match.addGoal(.red) }
        XCTAssertTrue(match.isOver)
        match.undoLastGoal()
        XCTAssertFalse(match.isOver)
        XCTAssertNil(match.winner)
        XCTAssertEqual(match.redScore, 4)
        XCTAssertTrue(match.canUndo)
    }
}
