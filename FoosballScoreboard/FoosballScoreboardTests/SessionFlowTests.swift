import XCTest
@testable import FoosballScoreboard

/// Session orchestration: race picker, live goals, reset vs play-again.
/// Confirm dialogs are UI-only (`confirmReset`); these tests cover the actions themselves.
@MainActor
final class SessionFlowTests: XCTestCase {
    func testChooseRaceFirstToFiveAndTen() {
        let session = Session()
        XCTAssertEqual(session.phase, .race)

        session.chooseRace(5)
        XCTAssertEqual(session.phase, .live)
        XCTAssertEqual(session.match.raceTo, 5)
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 0)

        let ten = Session()
        ten.chooseRace(10)
        XCTAssertEqual(ten.phase, .live)
        XCTAssertEqual(ten.match.raceTo, 10)
        XCTAssertFalse(ten.match.isOver)
    }

    func testGoalIncrementsForTwoTeamsWhileLive() {
        let session = Session()
        session.chooseRace(10)
        session.addGoal(.red)
        session.addGoal(.blue)
        session.addGoal(.red)
        XCTAssertEqual(session.match.redScore, 2)
        XCTAssertEqual(session.match.blueScore, 1)
        XCTAssertEqual(session.phase, .live)
    }

    func testAddGoalIsIgnoredBeforeTheMatchStarts() {
        let session = Session()
        XCTAssertEqual(session.phase, .race)
        session.addGoal(.red)
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.phase, .race)
    }

    func testUndoLastGoalAndSafeAtZeroZero() {
        let session = Session()
        session.chooseRace(5)
        session.undoLastGoal()
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 0)
        XCTAssertFalse(session.match.canUndo)

        session.addGoal(.blue)
        session.addGoal(.red)
        session.undoLastGoal()
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 1)
        XCTAssertEqual(session.phase, .live)
    }

    func testRequestNewMatchOnlySetsConfirmFlagUntilConfirmed() {
        let session = Session()
        session.chooseRace(5)
        session.addGoal(.red)
        session.requestNewMatch()
        XCTAssertTrue(session.confirmReset)
        XCTAssertEqual(session.match.redScore, 1, "Reset must wait for confirmNewMatch")
        XCTAssertEqual(session.phase, .live)
    }

    func testConfirmNewMatchResetsScoresAndKeepsRaceAsDistinctFromPlayAgain() {
        let session = Session()
        session.chooseRace(10)
        session.match.redSets = 1
        session.addGoal(.red)
        session.addGoal(.blue)
        session.requestNewMatch()
        session.confirmNewMatch()

        XCTAssertFalse(session.confirmReset)
        XCTAssertEqual(session.phase, .live)
        XCTAssertEqual(session.match.raceTo, 10)
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 0)
        XCTAssertEqual(session.match.redSets, 0, "New match clears set counts; play again does not")
        XCTAssertEqual(session.match.blueSets, 0)
    }

    func testMatchOverWhenTeamReachesRaceAndWinnerIsRecorded() {
        let session = Session()
        session.chooseRace(5)
        for _ in 0..<4 { session.addGoal(.red) }
        XCTAssertEqual(session.phase, .live)
        session.addGoal(.red)
        XCTAssertEqual(session.phase, .matchOver)
        XCTAssertEqual(session.match.winner, .red)
        session.addGoal(.blue)
        XCTAssertEqual(session.match.blueScore, 0)
        XCTAssertEqual(session.phase, .matchOver)
    }

    func testUndoAfterWinningGoalReturnsToLive() {
        let session = Session()
        session.chooseRace(5)
        for _ in 0..<5 { session.addGoal(.blue) }
        XCTAssertEqual(session.phase, .matchOver)
        session.undoLastGoal()
        XCTAssertEqual(session.phase, .live)
        XCTAssertNil(session.match.winner)
        XCTAssertEqual(session.match.blueScore, 4)
    }

    func testPlayAgainKeepsSetCountsAndSameRace() {
        let session = Session()
        session.chooseRace(5)
        session.match.setCustomName("Kitchen", for: .red)
        for _ in 0..<5 { session.addGoal(.red) }
        XCTAssertEqual(session.phase, .matchOver)

        session.playAgain()

        XCTAssertEqual(session.phase, .live)
        XCTAssertEqual(session.match.raceTo, 5)
        XCTAssertEqual(session.match.redSets, 1)
        XCTAssertEqual(session.match.blueSets, 0)
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 0)
        XCTAssertEqual(session.match.customName(for: .red), "Kitchen")
        XCTAssertFalse(session.match.isOver)
    }

    func testChangeRaceReturnsToPickerAndClearsSets() {
        let session = Session()
        session.chooseRace(10)
        for _ in 0..<10 { session.addGoal(.blue) }
        session.playAgain()
        XCTAssertEqual(session.match.blueSets, 1)

        session.changeRace()

        XCTAssertEqual(session.phase, .race)
        XCTAssertEqual(session.match.redScore, 0)
        XCTAssertEqual(session.match.blueScore, 0)
        XCTAssertEqual(session.match.redSets, 0)
        XCTAssertEqual(session.match.blueSets, 0)
        XCTAssertEqual(session.match.raceTo, 10, "Race value is kept until chooseRace; phase is picker")
    }

    func testOptionalTeamNamesDoNotAffectScoring() {
        let session = Session()
        session.chooseRace(5)
        session.match.setCustomName("Altbau", for: .red)
        session.match.setCustomName("Neubau", for: .blue)
        session.addGoal(.red)
        session.addGoal(.blue)
        session.addGoal(.red)
        XCTAssertEqual(session.match.redScore, 2)
        XCTAssertEqual(session.match.blueScore, 1)
        XCTAssertEqual(session.displayName(.red), "Altbau")
        XCTAssertEqual(session.displayName(.blue), "Neubau")
        XCTAssertEqual(session.phase, .live)
    }
}
