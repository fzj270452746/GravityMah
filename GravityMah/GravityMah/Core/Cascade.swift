import Foundation

struct WaveResult {
    let accords: [Accord]
    let fallMoves: [(from: (Int, Int), to: (Int, Int))]
}

struct CascadeResult {
    let waves: [WaveResult]
    let tally: Int
    let bombsTriggered: Int
    var depth: Int { waves.count }
}

struct Cascade {

    static func resolve(in crucible: inout Crucible) -> CascadeResult {
        var waves: [WaveResult] = []
        var totalTally = 0
        var chainDepth = 0
        var bombsTriggered = 0

        while true {
            let accords = Confluence.detect(in: crucible)
            guard !accords.isEmpty else { break }

            chainDepth += 1
            let multiplier = max(1, chainDepth)
            totalTally += accords.reduce(0) { $0 + $1.positions.count } * 100 * multiplier

            for accord in accords {
                for pos in accord.positions {
                    if case .bomb = crucible[pos.col, pos.row]?.variant {
                        bombsTriggered += 1
                        disperseBomb(at: pos, in: &crucible)
                    } else {
                        crucible[pos.col, pos.row] = nil
                    }
                }
            }

            let moves = crucible.plummet()
            waves.append(WaveResult(accords: accords, fallMoves: moves))
        }

        return CascadeResult(waves: waves, tally: totalTally, bombsTriggered: bombsTriggered)
    }

    private static func disperseBomb(at pos: (col: Int, row: Int), in crucible: inout Crucible) {
        for dc in -1...1 {
            for dr in -1...1 {
                let c = pos.col + dc, r = pos.row + dr
                guard crucible.inBounds(c, r) else { continue }
                if case .anchor = crucible[c, r]?.variant { continue }
                crucible[c, r] = nil
            }
        }
    }
}
