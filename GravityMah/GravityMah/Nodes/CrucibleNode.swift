import SpriteKit

// Manages the visual grid and touch-based swap interactions
final class CrucibleNode: SKNode {

    let cols: Int
    let rows: Int
    let cellSize: CGFloat

    private var shardNodes: [[ShardNode?]] = []
    private var chosenPos: (Int, Int)?

    var onSwapAttempt: (((Int, Int), (Int, Int)) -> Void)?

    init(cols: Int, rows: Int, cellSize: CGFloat) {
        self.cols     = cols
        self.rows     = rows
        self.cellSize = cellSize
        super.init()
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) { fatalError() }

    func populate(with crucible: Crucible) {
        removeAllChildren()
        shardNodes = Array(repeating: Array(repeating: nil, count: rows), count: cols)
        for col in 0..<cols {
            for row in 0..<rows {
                guard let shard = crucible[col, row] else { continue }
                let node = ShardNode(shard: shard, size: cellSize * 0.88)
                node.position = position(for: col, row: row)
                addChild(node)
                shardNodes[col][row] = node
            }
        }
    }

    func position(for col: Int, row: Int) -> CGPoint {
        CGPoint(
            x: CGFloat(col) * cellSize - CGFloat(cols - 1) * cellSize / 2,
            y: CGFloat(row) * cellSize - CGFloat(rows - 1) * cellSize / 2
        )
    }

    // Animate a swap between two positions
    func animateSwap(a: (Int, Int), b: (Int, Int), completion: @escaping () -> Void) {
        guard let na = shardNodes[a.0][a.1], let nb = shardNodes[b.0][b.1] else {
            completion(); return
        }
        let posA = position(for: a.0, row: a.1)
        let posB = position(for: b.0, row: b.1)
        var done = 0
        let finish = {
            done += 1
            if done == 2 { completion() }
        }
        shardNodes[a.0][a.1] = nb
        shardNodes[b.0][b.1] = na
        let move = SKAction.move(to: posB, duration: 0.18)
        move.timingMode = .easeInEaseOut
        let moveBack = SKAction.move(to: posA, duration: 0.18)
        moveBack.timingMode = .easeInEaseOut
        na.run(.sequence([move, .run(finish)]))
        nb.run(.sequence([moveBack, .run(finish)]))
    }

    // Animate tiles falling after gravity
    func animatePlummet(moves: [(from: (Int, Int), to: (Int, Int))], completion: @escaping () -> Void) {
        guard !moves.isEmpty else { completion(); return }
        var pending = moves.count
        for move in moves {
            guard let node = shardNodes[move.from.0][move.from.1] else {
                pending -= 1
                if pending == 0 { completion() }
                continue
            }
            shardNodes[move.from.0][move.from.1] = nil
            shardNodes[move.to.0][move.to.1]     = node
            let dest = position(for: move.to.0, row: move.to.1)
            node.plummet(to: dest, duration: 0.2) {
                pending -= 1
                if pending == 0 { completion() }
            }
        }
    }

    // Animate matched tiles dispersing
    func animateDisperse(positions: [(Int, Int)], completion: @escaping () -> Void) {
        guard !positions.isEmpty else { completion(); return }
        var pending = positions.count
        for pos in positions {
            guard let node = shardNodes[pos.0][pos.1] else {
                pending -= 1
                if pending == 0 { completion() }
                continue
            }
            shardNodes[pos.0][pos.1] = nil
            node.disperse {
                pending -= 1
                if pending == 0 { completion() }
            }
        }
    }

    func addShard(_ shard: Shard, at col: Int, row: Int) {
        let node = ShardNode(shard: shard, size: cellSize * 0.88)
        node.position = position(for: col, row: rows)   // start above board
        node.alpha = 0
        addChild(node)
        shardNodes[col][row] = node
        let dest = position(for: col, row: row)
        node.run(.sequence([
            .fadeIn(withDuration: 0.1),
            .move(to: dest, duration: 0.25)
        ]))
    }

    func flashDeadlock(completion: @escaping () -> Void) {
        let allNodes = shardNodes.flatMap { $0 }.compactMap { $0 }
        guard !allNodes.isEmpty else { completion(); return }
        for node in allNodes { node.flashWarning() }
        // 6 steps × 0.10 s = 0.60 s; add small buffer
        run(.sequence([.wait(forDuration: 0.65), .run(completion)]))
    }

    func clearChosen() {
        if let p = chosenPos { shardNodes[p.0][p.1]?.isChosen = false }
        chosenPos = nil
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        guard let pos = gridPos(from: loc) else { return }
        guard shardNodes[pos.0][pos.1] != nil else { return }

        if let chosen = chosenPos {
            if chosen == pos {
                clearChosen(); return
            }
            let adjacent = abs(chosen.0 - pos.0) + abs(chosen.1 - pos.1) == 1
            if adjacent {
                clearChosen()
                onSwapAttempt?(chosen, pos)
            } else {
                clearChosen()
                chosenPos = pos
                shardNodes[pos.0][pos.1]?.isChosen = true
            }
        } else {
            chosenPos = pos
            shardNodes[pos.0][pos.1]?.isChosen = true
            Harbinger.shared.vibrate(.light)
        }
    }

    private func gridPos(from point: CGPoint) -> (Int, Int)? {
        let halfW = CGFloat(cols - 1) * cellSize / 2
        let halfH = CGFloat(rows - 1) * cellSize / 2
        let col = Int(round((point.x + halfW) / cellSize))
        let row = Int(round((point.y + halfH) / cellSize))
        guard col >= 0, col < cols, row >= 0, row < rows else { return nil }
        return (col, row)
    }
}
