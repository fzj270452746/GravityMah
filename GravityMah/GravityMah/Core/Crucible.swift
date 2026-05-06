import Foundation

// cells[col][row], row 0 = bottom, gravity pulls toward row 0
struct Crucible {
    let cols: Int
    let rows: Int
    var cells: [[Shard?]]

    init(cols: Int, rows: Int) {
        self.cols  = cols
        self.rows  = rows
        self.cells = Array(repeating: Array(repeating: nil, count: rows), count: cols)
    }

    subscript(col: Int, row: Int) -> Shard? {
        get { cells[col][row] }
        set { cells[col][row] = newValue }
    }

    func inBounds(_ col: Int, _ row: Int) -> Bool {
        col >= 0 && col < cols && row >= 0 && row < rows
    }

    mutating func swapShards(at a: (Int, Int), and b: (Int, Int)) {
        guard inBounds(a.0, a.1), inBounds(b.0, b.1) else { return }
        let tmp = cells[a.0][a.1]
        cells[a.0][a.1] = cells[b.0][b.1]
        cells[b.0][b.1] = tmp
    }

    // Returns positions that changed during gravity application
    @discardableResult
    mutating func plummet() -> [(from: (Int, Int), to: (Int, Int))] {
        var moves: [(from: (Int, Int), to: (Int, Int))] = []
        for col in 0..<cols {
            var writeRow = 0
            for readRow in 0..<rows {
                guard let shard = cells[col][readRow] else { continue }
                if !shard.variant.isMovable {
                    // anchors block the column; reset writeRow above them
                    writeRow = readRow + 1
                    continue
                }
                if readRow != writeRow {
                    cells[col][writeRow] = shard
                    cells[col][readRow]  = nil
                    moves.append((from: (col, readRow), to: (col, writeRow)))
                }
                writeRow += 1
            }
        }
        return moves
    }

    mutating func shuffle() {
        var positions: [(Int, Int)] = []
        for col in 0..<cols {
            for row in 0..<rows {
                if let s = cells[col][row], s.variant.isMovable {
                    positions.append((col, row))
                }
            }
        }
        var values = positions.map { cells[$0.0][$0.1]! }
        values.shuffle()
        for (i, pos) in positions.enumerated() {
            cells[pos.0][pos.1] = values[i]
        }
    }

    func column(_ col: Int) -> [Shard?] { cells[col] }

    var isEmpty: Bool {
        cells.allSatisfy { $0.allSatisfy { $0 == nil } }
    }
}
