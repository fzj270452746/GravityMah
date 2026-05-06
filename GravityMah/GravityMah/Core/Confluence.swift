import Foundation

struct Accord {
    enum Kind { case sequence, triplet }
    let positions: [(col: Int, row: Int)]
    let kind: Kind
}

// Detects all matching groups in the crucible (horizontal + vertical)
struct Confluence {

    static func detect(in crucible: Crucible) -> [Accord] {
        var found: [Accord] = []
        found += scanRows(crucible)
        found += scanCols(crucible)
        return deduplicated(found)
    }

    // Returns true if any adjacent swap would create at least one accord
    static func hasMoves(in crucible: Crucible) -> Bool {
        for col in 0..<crucible.cols {
            for row in 0..<crucible.rows {
                guard let s = crucible[col, row], s.variant.isMovable else { continue }
                if col + 1 < crucible.cols,
                   let r = crucible[col+1, row], r.variant.isMovable {
                    var c = crucible
                    c.swapShards(at: (col, row), and: (col+1, row))
                    if !detect(in: c).isEmpty { return true }
                }
                if row + 1 < crucible.rows,
                   let r = crucible[col, row+1], r.variant.isMovable {
                    var c = crucible
                    c.swapShards(at: (col, row), and: (col, row+1))
                    if !detect(in: c).isEmpty { return true }
                }
            }
        }
        return false
    }

    // MARK: - Private

    private static func scanRows(_ c: Crucible) -> [Accord] {
        var result: [Accord] = []
        for row in 0..<c.rows {
            let line = (0..<c.cols).map { (col: $0, shard: c[$0, row]) }
            result += matchesIn(line.map { ($0.col, row, $0.shard) })
        }
        return result
    }

    private static func scanCols(_ c: Crucible) -> [Accord] {
        var result: [Accord] = []
        for col in 0..<c.cols {
            let line = (0..<c.rows).map { (row: $0, shard: c[col, $0]) }
            result += matchesIn(line.map { (col, $0.row, $0.shard) })
        }
        return result
    }

    private static func matchesIn(_ cells: [(Int, Int, Shard?)]) -> [Accord] {
        var result: [Accord] = []

        var i = 0
        while i < cells.count {
            guard let shard = cells[i].2, let val = shard.variant.matchValue else {
                i += 1
                continue
            }

            var run: [(col: Int, row: Int)] = [(cells[i].0, cells[i].1)]
            var j = i + 1
            while j < cells.count,
                  let next = cells[j].2,
                  let nv = next.variant.matchValue,
                  (nv == val || nv == -1 || val == -1) {
                run.append((cells[j].0, cells[j].1))
                j += 1
            }

            if run.count >= 3 {
                result.append(Accord(positions: run, kind: .triplet))
                i = j
                continue
            }

            i += 1
        }

        if cells.count >= 3 {
            for start in 0...(cells.count - 3) {
                guard let s0 = cells[start].2, let v0 = s0.variant.matchValue,
                      let s1 = cells[start + 1].2, let v1 = s1.variant.matchValue,
                      let s2 = cells[start + 2].2, let v2 = s2.variant.matchValue else {
                    continue
                }

                if isSequence([v0, v1, v2]) {
                    result.append(Accord(
                        positions: [
                            (cells[start].0, cells[start].1),
                            (cells[start + 1].0, cells[start + 1].1),
                            (cells[start + 2].0, cells[start + 2].1)
                        ],
                        kind: .sequence
                    ))
                }
            }
        }

        return result
    }

    // 3 values form a consecutive run (wilds = -1 substitute any value)
    private static func isSequence(_ values: [Int]) -> Bool {
        let nonWilds = values.filter { $0 != -1 }.sorted()
        let wildCount = values.count - nonWilds.count
        guard Set(nonWilds).count == nonWilds.count else { return false } // no duplicates
        let span = nonWilds.isEmpty ? 0 : nonWilds.last! - nonWilds.first!
        return span <= values.count - 1 && span + wildCount >= values.count - 1
    }

    private static func deduplicated(_ accords: [Accord]) -> [Accord] {
        // remove exact duplicates by position set
        var seen: [Set<String>: Bool] = [:]
        return accords.filter { accord in
            let key = Set(accord.positions.map { "\($0.col),\($0.row)" })
            if seen[key] != nil { return false }
            seen[key] = true
            return true
        }
    }
}
