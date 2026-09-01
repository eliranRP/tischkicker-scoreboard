import Foundation

enum L10n {
    static var teamRed: String { String(localized: "team.red") }
    static var teamBlue: String { String(localized: "team.blue") }
    static var addGoal: String { String(localized: "action.addGoal") }
    static var lastGoal: String { String(localized: "action.lastGoal") }
    static var newMatch: String { String(localized: "action.newMatch") }
    static var raceQuestion: String { String(localized: "race.question") }
    static var afterWork: String { String(localized: "race.afterWork") }
    static var longMatch: String { String(localized: "race.longMatch") }
    static var raceTitle: String { String(localized: "header.race.title") }
    static var raceSubtitle: String { String(localized: "header.race.subtitle") }
    static var liveTitle: String { String(localized: "header.live.title") }
    static var liveSubtitle: String { String(localized: "header.live.subtitle") }
    static var overSubtitle: String { String(localized: "header.over.subtitle") }
    static var playAgain: String { String(localized: "match.playAgain") }
    static var nextSet: String { String(localized: "match.nextSet") }
    static var changeRace: String { String(localized: "match.changeRace") }
    static var resetTitle: String { String(localized: "confirm.reset.title") }
    static var resetMessage: String { String(localized: "confirm.reset.message") }
    static var resetConfirm: String { String(localized: "confirm.reset.confirm") }
    static var cancel: String { String(localized: "confirm.cancel") }
    static var renameTitle: String { String(localized: "rename.title") }
    static var save: String { String(localized: "rename.save") }
    static var a11yLastGoal: String { String(localized: "a11y.lastGoal") }
    static var a11yNewMatch: String { String(localized: "a11y.newMatch") }

    static func teamName(_ side: TeamSide, custom: String) -> String {
        if !custom.isEmpty { return custom }
        return side == .red ? teamRed : teamBlue
    }

    static func firstTo(_ n: Int) -> String {
        String.localizedStringWithFormat(String(localized: "race.firstTo %lld"), Int64(n))
    }

    static func wins(_ team: String) -> String {
        String.localizedStringWithFormat(String(localized: "header.over.title"), team)
    }

    static func sets(_ red: Int, _ blue: Int) -> String {
        String.localizedStringWithFormat(String(localized: "match.setsFormat %lld %lld"), Int64(red), Int64(blue))
    }

    static func a11yAddGoal(_ team: String) -> String {
        String.localizedStringWithFormat(String(localized: "a11y.addGoal %@"), team)
    }

    static func a11yScore(_ team: String, _ score: Int) -> String {
        String.localizedStringWithFormat(String(localized: "a11y.score %@ %lld"), team, Int64(score))
    }

    static func a11yPickRace(_ n: Int) -> String {
        String.localizedStringWithFormat(String(localized: "a11y.pickRace %lld"), Int64(n))
    }

    static func a11yEditName(_ team: String) -> String {
        String.localizedStringWithFormat(String(localized: "a11y.editName %@"), team)
    }
}
