import Foundation

final class Reliquary {
    static let shared = Reliquary()
    private let defaults = UserDefaults.standard

    private enum Key {
        static let unlockedStrata       = "gm_unlocked"
        static let stratumStars         = "gm_stars"
        static let bestTally            = "gm_best"
        static let soundOn              = "gm_sound"
        static let musicOn              = "gm_music"
        static let hapticsOn            = "gm_haptics"
        static let unlockedAchievements = "gm_achievements"
        static let totalGroupsCleared   = "gm_total_groups"
        static let totalGamesPlayed     = "gm_total_games"
        static let maxChainEver         = "gm_max_chain"
    }

    private init() {
        if defaults.object(forKey: Key.unlockedStrata) == nil {
            defaults.set(1, forKey: Key.unlockedStrata)
        }
    }

    var unlockedCount: Int {
        get { defaults.integer(forKey: Key.unlockedStrata) }
        set { defaults.set(max(unlockedCount, newValue), forKey: Key.unlockedStrata) }
    }

    func stars(for index: Int) -> Int {
        let arr = defaults.array(forKey: Key.stratumStars) as? [Int] ?? []
        guard index < arr.count else { return 0 }
        return arr[index]
    }

    func enshrine(stars: Int, for index: Int) {
        var arr = defaults.array(forKey: Key.stratumStars) as? [Int] ?? Array(repeating: 0, count: 20)
        while arr.count <= index { arr.append(0) }
        arr[index] = max(arr[index], stars)
        defaults.set(arr, forKey: Key.stratumStars)
        if stars > 0 { unlockedCount = index + 2 }
    }

    func bestTally(for index: Int) -> Int {
        let arr = defaults.array(forKey: Key.bestTally) as? [Int] ?? []
        guard index < arr.count else { return 0 }
        return arr[index]
    }

    func enshrine(tally: Int, for index: Int) {
        var arr = defaults.array(forKey: Key.bestTally) as? [Int] ?? Array(repeating: 0, count: 20)
        while arr.count <= index { arr.append(0) }
        arr[index] = max(arr[index], tally)
        defaults.set(arr, forKey: Key.bestTally)
    }

    // MARK: - Achievement tracking

    var totalGroupsCleared: Int {
        get { defaults.integer(forKey: Key.totalGroupsCleared) }
        set { defaults.set(newValue, forKey: Key.totalGroupsCleared) }
    }

    var totalGamesPlayed: Int {
        get { defaults.integer(forKey: Key.totalGamesPlayed) }
        set { defaults.set(newValue, forKey: Key.totalGamesPlayed) }
    }

    var maxChainEver: Int {
        get { defaults.integer(forKey: Key.maxChainEver) }
        set { defaults.set(max(maxChainEver, newValue), forKey: Key.maxChainEver) }
    }

    var totalPerfectLevels: Int {
        let arr = defaults.array(forKey: Key.stratumStars) as? [Int] ?? []
        return arr.filter { $0 == 3 }.count
    }

    func isAchievementUnlocked(_ id: String) -> Bool {
        let arr = defaults.stringArray(forKey: Key.unlockedAchievements) ?? []
        return arr.contains(id)
    }

    @discardableResult
    func unlockAchievement(_ id: String) -> Bool {
        var arr = defaults.stringArray(forKey: Key.unlockedAchievements) ?? []
        guard !arr.contains(id) else { return false }
        arr.append(id)
        defaults.set(arr, forKey: Key.unlockedAchievements)
        return true
    }

    struct GameContext {
        let levelIndex: Int
        let triumph: Bool
        let score: Int
        let stepsLeft: Int
        let stepLimit: Int
        let chainDepth: Int
        let groupsCleared: Int
        let bombsTriggered: Int
        let reshuffled: Bool
    }

    @discardableResult
    func evaluateAchievements(_ ctx: GameContext) -> [Achievement] {
        totalGroupsCleared += ctx.groupsCleared
        totalGamesPlayed   += 1
        maxChainEver        = ctx.chainDepth

        var newlyUnlocked: [Achievement] = []
        for ach in Achievement.all {
            guard !isAchievementUnlocked(ach.id) else { continue }
            if meetsCondition(ach.id, ctx: ctx) {
                unlockAchievement(ach.id)
                newlyUnlocked.append(ach)
            }
        }
        return newlyUnlocked
    }

    private func meetsCondition(_ id: String, ctx: GameContext) -> Bool {
        switch id {
        case "first_group":  return totalGroupsCleared >= 1
        case "level_1":      return ctx.triumph && ctx.levelIndex == 0
        case "novice_done":  return ctx.triumph && ctx.levelIndex == 9
        case "adept_done":   return ctx.triumph && ctx.levelIndex == 19
        case "expert_done":  return ctx.triumph && ctx.levelIndex == 29
        case "master_done":  return ctx.triumph && ctx.levelIndex == 39
        case "legend_done":  return ctx.triumph && ctx.levelIndex == 49
        case "unlock_10":    return unlockedCount >= 10
        case "unlock_25":    return unlockedCount >= 25
        case "unlock_50":    return unlockedCount >= 50
        case "chain_2":      return maxChainEver >= 2
        case "chain_3":      return maxChainEver >= 3
        case "chain_4":      return maxChainEver >= 4
        case "chain_5":      return maxChainEver >= 5
        case "chain_6":      return maxChainEver >= 6
        case "bomb_novice":  return ctx.bombsTriggered >= 1
        case "bomb_expert":  return ctx.bombsTriggered >= 3
        case "score_1000":   return ctx.score >= 1000
        case "score_5000":   return ctx.score >= 5000
        case "score_10000":  return ctx.score >= 10000
        case "perfect_1":    return totalPerfectLevels >= 1
        case "perfect_5":    return totalPerfectLevels >= 5
        case "perfect_20":   return totalPerfectLevels >= 20
        case "groups_50":    return totalGroupsCleared >= 50
        case "groups_200":   return totalGroupsCleared >= 200
        case "groups_1000":  return totalGroupsCleared >= 1000
        case "games_10":     return totalGamesPlayed >= 10
        case "games_50":     return totalGamesPlayed >= 50
        case "efficient":    return ctx.triumph && ctx.stepsLeft >= Int(Double(ctx.stepLimit) * 0.7)
        case "survivor":     return ctx.triumph && ctx.stepsLeft == 1
        case "comeback":     return ctx.triumph && ctx.reshuffled
        default:             return false
        }
    }

    // MARK: - Settings

    var soundOn:   Bool {
        get { defaults.object(forKey: Key.soundOn)   == nil ? true : defaults.bool(forKey: Key.soundOn) }
        set { defaults.set(newValue, forKey: Key.soundOn) }
    }
    var musicOn:   Bool {
        get { defaults.object(forKey: Key.musicOn)   == nil ? true : defaults.bool(forKey: Key.musicOn) }
        set { defaults.set(newValue, forKey: Key.musicOn) }
    }
    var hapticsOn: Bool {
        get { defaults.object(forKey: Key.hapticsOn) == nil ? true : defaults.bool(forKey: Key.hapticsOn) }
        set { defaults.set(newValue, forKey: Key.hapticsOn) }
    }
}
