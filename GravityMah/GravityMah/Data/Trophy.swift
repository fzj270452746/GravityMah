import Foundation

struct Achievement {
    let id: String
    let title: String
    let desc: String
    let icon: String  // SF Symbol name

    var isUnlocked: Bool { Reliquary.shared.isAchievementUnlocked(id) }
}

extension Achievement {
    static let all: [Achievement] = [
        // ── Progress ──────────────────────────────────────────────────
        Achievement(id: "first_group",  title: "First Match",     desc: "Clear your first group",                   icon: "sparkles"),
        Achievement(id: "level_1",      title: "Awakening",       desc: "Complete Level 1",                         icon: "1.circle.fill"),
        Achievement(id: "novice_done",  title: "Novice Graduate", desc: "Complete all 10 Novice levels",            icon: "graduationcap.fill"),
        Achievement(id: "adept_done",   title: "Adept Graduate",  desc: "Complete all 10 Adept levels",             icon: "bolt.fill"),
        Achievement(id: "expert_done",  title: "Expert Graduate", desc: "Complete all 10 Expert levels",            icon: "tornado"),
        Achievement(id: "master_done",  title: "Master Graduate", desc: "Complete all 10 Master levels",            icon: "wand.and.stars"),
        Achievement(id: "legend_done",  title: "Legend",          desc: "Complete all 50 levels",                   icon: "crown.fill"),
        // ── Unlock milestones ─────────────────────────────────────────
        Achievement(id: "unlock_10",    title: "Explorer",        desc: "Unlock 10 levels",                         icon: "map.fill"),
        Achievement(id: "unlock_25",    title: "Adventurer",      desc: "Unlock 25 levels",                         icon: "safari.fill"),
        Achievement(id: "unlock_50",    title: "Conqueror",       desc: "Unlock all 50 levels",                     icon: "trophy.fill"),
        // ── Chain ─────────────────────────────────────────────────────
        Achievement(id: "chain_2",      title: "Chain Reaction",  desc: "Achieve a x2 chain",                       icon: "link"),
        Achievement(id: "chain_3",      title: "Triple Chain",    desc: "Achieve a x3 chain",                       icon: "link.badge.plus"),
        Achievement(id: "chain_4",      title: "Quad Chain",      desc: "Achieve a x4 chain",                       icon: "bolt.horizontal.fill"),
        Achievement(id: "chain_5",      title: "Penta Chain",     desc: "Achieve a x5 chain",                       icon: "star.fill"),
        Achievement(id: "chain_6",      title: "Hexa Chain",      desc: "Achieve a x6 chain",                       icon: "star.circle.fill"),
        Achievement(id: "bomb_novice",  title: "Blast Primer",    desc: "Trigger a bomb in one game",                icon: "burst.fill"),
        Achievement(id: "bomb_expert",  title: "Shockwave",       desc: "Trigger 3 bombs in one game",               icon: "flame.fill"),
        // ── Score ─────────────────────────────────────────────────────
        Achievement(id: "score_1000",   title: "Point Scorer",    desc: "Score 1,000 in one game",                  icon: "checkmark.seal.fill"),
        Achievement(id: "score_5000",   title: "High Scorer",     desc: "Score 5,000 in one game",                  icon: "target"),
        Achievement(id: "score_10000",  title: "Score Master",    desc: "Score 10,000 in one game",                 icon: "medal.fill"),
        // ── Stars ─────────────────────────────────────────────────────
        Achievement(id: "perfect_1",    title: "Perfectionist",   desc: "3-star any level",                         icon: "star.fill"),
        Achievement(id: "perfect_5",    title: "Star Collector",  desc: "3-star 5 levels",                          icon: "star.leadinghalf.filled"),
        Achievement(id: "perfect_20",   title: "Star Master",     desc: "3-star 20 levels",                         icon: "sparkle"),
        // ── Groups cleared ────────────────────────────────────────────
        Achievement(id: "groups_50",    title: "Cleaner",         desc: "Clear 50 groups total",                    icon: "trash.fill"),
        Achievement(id: "groups_200",   title: "Centurion",       desc: "Clear 200 groups total",                   icon: "shield.fill"),
        Achievement(id: "groups_1000",  title: "Millennium",      desc: "Clear 1,000 groups total",                 icon: "building.columns.fill"),
        // ── Games played ──────────────────────────────────────────────
        Achievement(id: "games_10",     title: "Dedicated",       desc: "Play 10 games",                            icon: "gamecontroller.fill"),
        Achievement(id: "games_50",     title: "Veteran",         desc: "Play 50 games",                            icon: "rosette"),
        // ── Special ───────────────────────────────────────────────────
        Achievement(id: "efficient",    title: "Efficient",       desc: "Finish a level with 70%+ steps remaining",  icon: "bolt.circle.fill"),
        Achievement(id: "survivor",     title: "Survivor",        desc: "Finish a level with exactly 1 step left",   icon: "heart.fill"),
        Achievement(id: "comeback",     title: "Comeback",        desc: "Complete a level after a reshuffle",        icon: "arrow.clockwise.circle.fill"),
    ]
}
