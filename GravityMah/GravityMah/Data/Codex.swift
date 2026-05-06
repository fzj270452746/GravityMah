import Foundation

// Level definitions and board generation
struct Codex {

    enum Objective {
        case clearAccords(Int)
        case reachScore(Int)
        case chainDepth(Int)
        case triggerBombs(Int)

        func isMet(by arbiter: Arbiter) -> Bool {
            switch self {
            case .clearAccords(let n): return arbiter.accordsCleared >= n
            case .reachScore(let n):   return arbiter.tally >= n
            case .chainDepth(let n):   return arbiter.longestChain >= n
            case .triggerBombs(let n): return arbiter.bombsTriggered >= n
            }
        }

        var description: String {
            switch self {
            case .clearAccords(let n): return "Clear \(n) groups"
            case .reachScore(let n):   return "Score \(n)"
            case .chainDepth(let n):   return "Chain ×\(n)"
            case .triggerBombs(let n): return "Trigger \(n) bombs"
            }
        }
    }

    struct Stratum {
        let index: Int
        let cols: Int
        let rows: Int
        let stepLimit: Int
        let objective: Objective
        let seed: [[ShardVariant?]]
        let title: String
    }

    static let strata: [Stratum] = buildStrata()

    static func conjure(stratum: Stratum) -> Crucible {
        var c = Crucible(cols: stratum.cols, rows: stratum.rows)
        for col in 0..<stratum.cols {
            for row in 0..<stratum.rows {
                let variant: ShardVariant
                if col < stratum.seed.count, row < stratum.seed[col].count,
                   let v = stratum.seed[col][row] {
                    variant = v
                } else {
                    variant = .numeral(Int.random(in: 1...9))
                }
                c[col, row] = Shard(variant)
            }
        }
        return scrambleIfNeeded(c)
    }

    // MARK: - Private

    private static func scrambleIfNeeded(_ input: Crucible) -> Crucible {
        var c = input
        var attempts = 0
        while !Confluence.detect(in: c).isEmpty, attempts < 20 {
            c = shuffled(c)
            attempts += 1
        }
        return c
    }

    private static func shuffled(_ input: Crucible) -> Crucible {
        var c = input
        for col in 0..<c.cols {
            for row in 0..<c.rows {
                guard let s = c[col, row], s.variant.isMovable else { continue }
                let rc = Int.random(in: 0..<c.cols)
                let rr = Int.random(in: 0..<c.rows)
                if let t = c[rc, rr], t.variant.isMovable {
                    c.swapShards(at: (col, row), and: (rc, rr))
                }
            }
        }
        return c
    }

    // MARK: - Level data
    // Tiers: 1-10 Novice (6×6), 11-20 Adept (6×7), 21-30 Expert (7×7),
    //        31-40 Master (7×8), 41-50 Legend (8×8/8×9)

    private static func buildStrata() -> [Stratum] {
        [
            // ── Novice 1–10 ────────────────────────────────────────────
            Stratum(index:  0, cols: 6, rows: 6, stepLimit: 20,
                    objective: .clearAccords(3),    seed: noviceAwakeningSeed(), title: "Awakening"),
            Stratum(index:  1, cols: 6, rows: 6, stepLimit: 18,
                    objective: .clearAccords(5),    seed: noviceRippleSeed(), title: "Ripple"),
            Stratum(index:  2, cols: 6, rows: 6, stepLimit: 16,
                    objective: .reachScore(800),    seed: noviceCurrentSeed(), title: "Current"),
            Stratum(index:  3, cols: 6, rows: 6, stepLimit: 16,
                    objective: .clearAccords(7),    seed: noviceRapidsSeed(), title: "Rapids"),
            Stratum(index:  4, cols: 6, rows: 6, stepLimit: 15,
                    objective: .chainDepth(2),      seed: anchorLessonSeed(), title: "Resonance"),
            Stratum(index:  5, cols: 6, rows: 6, stepLimit: 15,
                    objective: .reachScore(1200),   seed: anchorCorridorSeed(), title: "Echo"),
            Stratum(index:  6, cols: 6, rows: 6, stepLimit: 14,
                    objective: .clearAccords(9),    seed: anchorPocketSeed(), title: "Vortex"),
            Stratum(index:  7, cols: 6, rows: 6, stepLimit: 14,
                    objective: .chainDepth(2),      seed: anchorBridgeSeed(), title: "Tide"),
            Stratum(index:  8, cols: 6, rows: 6, stepLimit: 13,
                    objective: .triggerBombs(1),    seed: bombPrimerSeed(), title: "Surge"),
            Stratum(index:  9, cols: 6, rows: 6, stepLimit: 13,
                    objective: .clearAccords(11),   seed: bombCrossfireSeed(), title: "Dawn"),

            // ── Adept 11–20 ────────────────────────────────────────────
            Stratum(index: 10, cols: 6, rows: 7, stepLimit: 16,
                    objective: .clearAccords(8),    seed: wildPrimerSeed(), title: "Tremor"),
            Stratum(index: 11, cols: 6, rows: 7, stepLimit: 15,
                    objective: .chainDepth(3),      seed: wildBridgeSeed(), title: "Fission"),
            Stratum(index: 12, cols: 6, rows: 7, stepLimit: 15,
                    objective: .chainDepth(3),      seed: [], title: "Chain"),
            Stratum(index: 13, cols: 6, rows: 7, stepLimit: 14,
                    objective: .clearAccords(10),   seed: [], title: "Blast"),
            Stratum(index: 14, cols: 6, rows: 7, stepLimit: 14,
                    objective: .reachScore(2200),   seed: [], title: "Impact"),
            Stratum(index: 15, cols: 6, rows: 7, stepLimit: 13,
                    objective: .clearAccords(12),   seed: [], title: "Aftershock"),
            Stratum(index: 16, cols: 6, rows: 7, stepLimit: 13,
                    objective: .chainDepth(3),      seed: [], title: "Vibration"),
            Stratum(index: 17, cols: 6, rows: 7, stepLimit: 12,
                    objective: .reachScore(2600),   seed: [], title: "Thunder"),
            Stratum(index: 18, cols: 6, rows: 7, stepLimit: 12,
                    objective: .clearAccords(14),   seed: [], title: "Collapse"),
            Stratum(index: 19, cols: 6, rows: 7, stepLimit: 12,
                    objective: .chainDepth(4),      seed: [], title: "Critical"),

            // ── Expert 21–30 ───────────────────────────────────────────
            Stratum(index: 20, cols: 7, rows: 7, stepLimit: 16,
                    objective: .clearAccords(10),   seed: [], title: "Whirlpool"),
            Stratum(index: 21, cols: 7, rows: 7, stepLimit: 15,
                    objective: .reachScore(2800),   seed: [], title: "Torrent"),
            Stratum(index: 22, cols: 7, rows: 7, stepLimit: 15,
                    objective: .chainDepth(3),      seed: [], title: "Turbulence"),
            Stratum(index: 23, cols: 7, rows: 7, stepLimit: 14,
                    objective: .clearAccords(13),   seed: [], title: "Flood"),
            Stratum(index: 24, cols: 7, rows: 7, stepLimit: 14,
                    objective: .reachScore(3200),   seed: [], title: "Deluge"),
            Stratum(index: 25, cols: 7, rows: 7, stepLimit: 13,
                    objective: .clearAccords(15),   seed: [], title: "Tempest"),
            Stratum(index: 26, cols: 7, rows: 7, stepLimit: 13,
                    objective: .chainDepth(4),      seed: [], title: "Breaker"),
            Stratum(index: 27, cols: 7, rows: 7, stepLimit: 12,
                    objective: .reachScore(3800),   seed: [], title: "Tsunami"),
            Stratum(index: 28, cols: 7, rows: 7, stepLimit: 12,
                    objective: .clearAccords(17),   seed: [], title: "Abyss"),
            Stratum(index: 29, cols: 7, rows: 7, stepLimit: 12,
                    objective: .chainDepth(4),      seed: [], title: "Extreme"),

            // ── Master 31–40 ───────────────────────────────────────────
            Stratum(index: 30, cols: 7, rows: 8, stepLimit: 16,
                    objective: .clearAccords(12),   seed: [], title: "Magnet"),
            Stratum(index: 31, cols: 7, rows: 8, stepLimit: 15,
                    objective: .reachScore(4000),   seed: [], title: "Gravity"),
            Stratum(index: 32, cols: 7, rows: 8, stepLimit: 15,
                    objective: .chainDepth(4),      seed: [], title: "Collapse"),
            Stratum(index: 33, cols: 7, rows: 8, stepLimit: 14,
                    objective: .clearAccords(15),   seed: [], title: "Singularity"),
            Stratum(index: 34, cols: 7, rows: 8, stepLimit: 14,
                    objective: .reachScore(4500),   seed: [], title: "Dark Matter"),
            Stratum(index: 35, cols: 7, rows: 8, stepLimit: 13,
                    objective: .clearAccords(18),   seed: [], title: "Black Hole"),
            Stratum(index: 36, cols: 7, rows: 8, stepLimit: 13,
                    objective: .chainDepth(5),      seed: [], title: "Event Horizon"),
            Stratum(index: 37, cols: 7, rows: 8, stepLimit: 12,
                    objective: .reachScore(5200),   seed: [], title: "Rift"),
            Stratum(index: 38, cols: 7, rows: 8, stepLimit: 12,
                    objective: .clearAccords(20),   seed: [], title: "Fold"),
            Stratum(index: 39, cols: 7, rows: 8, stepLimit: 12,
                    objective: .chainDepth(5),      seed: [], title: "Entanglement"),

            // ── Legend 41–50 ───────────────────────────────────────────
            Stratum(index: 40, cols: 8, rows: 8, stepLimit: 16,
                    objective: .clearAccords(15),   seed: [], title: "Chaos"),
            Stratum(index: 41, cols: 8, rows: 8, stepLimit: 15,
                    objective: .reachScore(5500),   seed: [], title: "Entropy"),
            Stratum(index: 42, cols: 8, rows: 8, stepLimit: 15,
                    objective: .chainDepth(5),      seed: [], title: "Annihilation"),
            Stratum(index: 43, cols: 8, rows: 8, stepLimit: 14,
                    objective: .clearAccords(20),   seed: [], title: "Void"),
            Stratum(index: 44, cols: 8, rows: 8, stepLimit: 14,
                    objective: .reachScore(6500),   seed: [], title: "Eternity"),
            Stratum(index: 45, cols: 8, rows: 8, stepLimit: 13,
                    objective: .clearAccords(23),   seed: [], title: "Cycle"),
            Stratum(index: 46, cols: 8, rows: 8, stepLimit: 13,
                    objective: .chainDepth(6),      seed: [], title: "Nirvana"),
            Stratum(index: 47, cols: 8, rows: 9, stepLimit: 14,
                    objective: .reachScore(8000),   seed: [], title: "Destiny"),
            Stratum(index: 48, cols: 8, rows: 9, stepLimit: 13,
                    objective: .clearAccords(26),   seed: [], title: "Infinite"),
            Stratum(index: 49, cols: 8, rows: 9, stepLimit: 12,
                    objective: .chainDepth(6),      seed: [], title: "Genesis"),
        ]
    }

    private static func N(_ value: Int) -> ShardVariant? { .numeral(value) }
    private static func A(_ value: Int) -> ShardVariant? { .anchor(value) }
    private static func B() -> ShardVariant? { .bomb }
    private static func W() -> ShardVariant? { .wild }

    private static func noviceAwakeningSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8)],
            [N(2), N(5), N(8), N(3), N(6), N(9)],
            [N(3), N(6), N(9), N(1), N(4), N(7)],
            [N(4), N(7), N(1), N(5), N(8), N(2)],
            [N(5), N(8), N(2), N(6), N(9), N(3)],
            [N(6), N(9), N(3), N(7), N(1), N(4)],
        ]
    }

    private static func noviceRippleSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(3), N(5), N(7), N(9), N(2)],
            [N(2), N(4), N(6), N(8), N(1), N(3)],
            [N(3), N(5), N(7), N(9), N(2), N(4)],
            [N(4), N(6), N(8), N(1), N(3), N(5)],
            [N(5), N(7), N(9), N(2), N(4), N(6)],
            [N(6), N(8), N(1), N(3), N(5), N(7)],
        ]
    }

    private static func noviceCurrentSeed() -> [[ShardVariant?]] {
        [
            [N(2), N(5), N(8), N(2), N(5), N(8)],
            [N(3), N(6), N(9), N(3), N(6), N(9)],
            [N(4), N(7), N(1), N(4), N(7), N(1)],
            [N(5), N(8), N(2), N(5), N(8), N(2)],
            [N(6), N(9), N(3), N(6), N(9), N(3)],
            [N(7), N(1), N(4), N(7), N(1), N(4)],
        ]
    }

    private static func noviceRapidsSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(2), N(8), N(4), N(5), N(9)],
            [N(2), N(3), N(9), N(5), N(6), N(1)],
            [N(3), N(4), N(1), N(6), N(7), N(2)],
            [N(4), N(5), N(2), N(7), N(8), N(3)],
            [N(5), N(6), N(3), N(8), N(9), N(4)],
            [N(6), N(7), N(4), N(9), N(1), N(5)],
        ]
    }

    private static func anchorLessonSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8)],
            [N(2), N(5), N(8), N(3), N(6), N(9)],
            [N(3), N(4), N(9), N(1), N(7), N(7)],
            [N(4), N(7), N(1), N(5), N(8), N(2)],
            [N(5), N(8), N(2), N(6), N(2), N(3)],
            [N(6), N(9), N(3), N(7), N(1), N(4)],
        ]
    }

    private static func anchorCorridorSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(5), N(7), N(2), N(4), N(8)],
            [N(2), N(3), N(8), N(5), N(6), N(9)],
            [N(3), N(6), N(9), N(1), N(7), N(2)],
            [N(4), N(6), N(1), N(7), N(8), N(3)],
            [N(5), N(8), N(2), N(6), N(9), N(4)],
            [N(6), N(9), N(3), N(7), N(1), N(5)],
        ]
    }

    private static func anchorPocketSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(6), N(2), N(5), N(8)],
            [N(2), N(5), N(7), N(3), N(6), N(9)],
            [N(3), N(6), N(8), N(1), N(4), N(7)],
            [N(4), N(7), N(1), N(5), N(8), N(2)],
            [N(5), N(8), N(2), N(6), N(9), N(3)],
            [N(6), N(9), N(3), N(7), N(1), N(4)],
        ]
    }

    private static func anchorBridgeSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(3), N(6), N(2), N(5), N(8)],
            [N(2), N(4), N(7), N(3), N(6), N(9)],
            [N(3), N(5), N(8), N(4), N(7), N(1)],
            [N(4), N(6), N(9), N(5), N(8), N(2)],
            [N(5), N(7), N(1), N(6), N(9), N(3)],
            [N(6), N(8), N(2), N(7), N(1), N(4)],
        ]
    }

    private static func bombPrimerSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8)],
            [N(2), N(5), B(),   N(3), N(6), N(9)],
            [N(3), N(6), N(9), N(1), N(4), N(7)],
            [N(4), N(7), N(1), B(),   N(8), N(2)],
            [N(5), N(8), N(2), N(6), N(9), N(3)],
            [N(6), N(9), N(3), N(7), N(1), N(4)],
        ]
    }

    private static func bombCrossfireSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8)],
            [N(2), N(5), B(),   N(3), N(6), N(9)],
            [N(3), N(6), N(9), N(1), N(4), N(7)],
            [N(4), N(7), N(1), B(),   N(8), N(2)],
            [N(5), N(8), B(),   N(6), N(9), N(3)],
            [N(6), N(9), N(3), N(7), N(1), N(4)],
        ]
    }

    private static func wildPrimerSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8), N(3)],
            [N(2), N(5), N(8), N(3), N(6), N(9), N(4)],
            [N(3), N(6), W(),   N(1), N(4), N(7), N(5)],
            [N(4), N(7), N(1), W(),   N(8), N(2), N(6)],
            [N(5), N(8), N(2), N(6), N(9), N(3), N(7)],
            [N(6), N(9), N(3), N(7), N(1), N(4), N(8)],
        ]
    }

    private static func wildBridgeSeed() -> [[ShardVariant?]] {
        [
            [N(1), N(4), N(7), N(2), N(5), N(8), N(3)],
            [N(2), N(5), N(8), N(3), N(6), N(9), N(4)],
            [N(3), N(6), W(),   N(1), N(4), N(7), N(5)],
            [N(4), N(7), N(1), W(),   N(8), N(2), N(6)],
            [N(5), N(8), N(2), N(6), N(9), N(3), N(7)],
            [N(6), N(9), N(3), N(7), N(1), N(4), N(8)],
        ]
    }
}
