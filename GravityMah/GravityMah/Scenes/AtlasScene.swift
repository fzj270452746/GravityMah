import SpriteKit

final class AtlasScene: SKScene {

    private let unlocked = Reliquary.shared.unlockedCount
    private let total    = Codex.strata.count
    private var scrollNode: SKNode!

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Palette.bg
        buildBackground()
        buildHeader()
        buildGrid()
    }

    // MARK: - Build

    private func buildBackground() {
        let bg = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        bg.fillColor   = Palette.bg
        bg.strokeColor = .clear
        bg.position    = CGPoint(x: -size.width/2, y: -size.height/2)
        bg.zPosition   = -10
        addChild(bg)
    }

    private func buildHeader() {
        let topInset = safeTop + 16
        let backBtn = BackButton { [weak self] in self?.goBack() }
        backBtn.position = CGPoint(x: -size.width/2 + 44, y: size.height/2 - topInset - 22)
        addChild(backBtn)

        let title = SKLabelNode(text: "SELECT LEVEL")
        title.fontName  = "AvenirNext-Heavy"
        title.fontSize  = 22
        title.fontColor = Palette.text
        title.horizontalAlignmentMode = .center
        title.position  = CGPoint(x: 0, y: size.height/2 - topInset - 22)
        addChild(title)

        let prog = SKLabelNode(text: "\(unlocked)/\(total) Unlocked")
        prog.fontName  = "AvenirNext-Medium"
        prog.fontSize  = 13
        prog.fontColor = Palette.subtext
        prog.horizontalAlignmentMode = .center
        prog.position  = CGPoint(x: 0, y: size.height/2 - topInset - 50)
        addChild(prog)

        let chapterHint = SKLabelNode(text: "Novice: Basics · Anchors · Bombs · Wilds")
        chapterHint.fontName  = "AvenirNext-Medium"
        chapterHint.fontSize  = 12
        chapterHint.fontColor = Palette.subtext.withAlphaComponent(0.9)
        chapterHint.horizontalAlignmentMode = .center
        chapterHint.position  = CGPoint(x: 0, y: size.height/2 - topInset - 70)
        addChild(chapterHint)
    }

    private func buildGrid() {
        scrollNode = SKNode()
        addChild(scrollNode)

        let topInset = safeTop + 16
        let cols: Int    = 3
        let cellW: CGFloat = (size.width - 48) / CGFloat(cols)
        let cellH: CGFloat = cellW * 1.1
        let startX = -size.width/2 + 24 + cellW/2
        let startY = size.height/2 - topInset - 96 - cellH/2

        for (i, stratum) in Codex.strata.enumerated() {
            let col = i % cols
            let row = i / cols
            let x   = startX + CGFloat(col) * cellW
            let y   = startY - CGFloat(row) * cellH
            let card = LevelCard(stratum: stratum, locked: i >= unlocked, size: CGSize(width: cellW - 12, height: cellH - 12))
            card.position = CGPoint(x: x, y: y)
            card.onTap = { [weak self] in self?.launch(stratum: stratum) }
            scrollNode.addChild(card)
        }
    }

    // MARK: - Actions

    private func launch(stratum: Codex.Stratum) {
        Harbinger.shared.vibrate(.medium)
        let arena = ArenaScene(size: size, stratum: stratum)
        arena.scaleMode = scaleMode
        relay(safeArea: arena)
        view?.presentScene(arena, transition: .push(with: .left, duration: 0.35))
    }

    private func goBack() {
        Harbinger.shared.vibrate(.light)
        let vault = VaultScene(size: size)
        vault.scaleMode = scaleMode
        relay(safeArea: vault)
        view?.presentScene(vault, transition: .push(with: .right, duration: 0.3))
    }

    // MARK: - Scroll

    private var lastTouchY: CGFloat = 0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchY = touches.first?.location(in: self).y ?? 0
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let dy = touch.location(in: self).y - lastTouchY
        lastTouchY = touch.location(in: self).y
        let newY = scrollNode.position.y + dy
        let minY: CGFloat = 0
        let rows = (total + 2) / 3
        let maxY = max(0, CGFloat(rows) * ((size.width - 48) / 3 * 1.1) - size.height + 160)
        scrollNode.position.y = max(-maxY, min(minY, newY))
    }
}

// MARK: - LevelCard

private final class LevelCard: SKNode {
    var onTap: (() -> Void)?
    private let locked: Bool

    init(stratum: Codex.Stratum, locked: Bool, size: CGSize) {
        self.locked = locked
        super.init()
        isUserInteractionEnabled = !locked
        build(stratum: stratum, size: size)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func build(stratum: Codex.Stratum, size: CGSize) {
        let rect = CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height)
        let bg = SKShapeNode(rect: rect, cornerRadius: 14)
        let stars = Reliquary.shared.stars(for: stratum.index)

        if locked {
            bg.fillColor   = UIColor(white: 0, alpha: 0.05)
            bg.strokeColor = UIColor(white: 0, alpha: 0.1)
        } else {
            let tint = Palette.tint(for: (stratum.index % 9) + 1)
            bg.fillColor   = tint.withAlphaComponent(0.12)
            bg.strokeColor = tint.withAlphaComponent(0.5)
        }
        bg.lineWidth = 1.5
        addChild(bg)

        if locked {
            let lock = SKLabelNode(text: "LOCKED")
            lock.fontName  = "AvenirNext-Bold"
            lock.fontSize  = 13
            lock.fontColor = Palette.subtext
            lock.horizontalAlignmentMode = .center
            lock.verticalAlignmentMode   = .center
            addChild(lock)
            return
        }

        let num = SKLabelNode(text: "\(stratum.index + 1)")
        num.fontName  = "AvenirNext-Heavy"
        num.fontSize  = 28
        num.fontColor = Palette.text
        num.horizontalAlignmentMode = .center
        num.verticalAlignmentMode   = .center
        num.position  = CGPoint(x: 0, y: 10)
        addChild(num)

        let name = SKLabelNode(text: stratum.title)
        name.fontName  = "AvenirNext-Medium"
        name.fontSize  = 10
        name.fontColor = Palette.subtext
        name.horizontalAlignmentMode = .center
        name.verticalAlignmentMode   = .center
        name.position  = CGPoint(x: 0, y: -14)
        addChild(name)

        let rule = SKLabelNode(text: ruleTag(for: stratum))
        rule.fontName  = "AvenirNext-DemiBold"
        rule.fontSize  = 8
        rule.fontColor = Palette.accent.withAlphaComponent(0.92)
        rule.horizontalAlignmentMode = .center
        rule.verticalAlignmentMode   = .center
        rule.position = CGPoint(x: 0, y: -29)
        addChild(rule)

        for i in 0..<3 {
            let s = SKLabelNode(text: i < stars ? "★" : "☆")
            s.fontName  = "AvenirNext-Bold"
            s.fontSize  = 12
            s.fontColor = i < stars ? UIColor(hex: "#E6B800") : UIColor(white: 0, alpha: 0.2)
            s.horizontalAlignmentMode = .center
            s.verticalAlignmentMode   = .center
            s.position = CGPoint(x: CGFloat(i - 1) * 16, y: -size.height/2 + 16)
            addChild(s)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 0.93, duration: 0.07))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 1.0, duration: 0.07)) { [weak self] in
            Harbinger.shared.vibrate(.light)
            self?.onTap?()
        }
    }

    private func ruleTag(for stratum: Codex.Stratum) -> String {
        switch stratum.index {
        case 0...3: return "FOUNDATIONS"
        case 4...7: return "ANCHORS"
        case 8...9: return "BOMBS"
        case 10...11: return "WILDS"
        default:
            switch stratum.objective {
            case .clearAccords: return "GROUPS"
            case .reachScore:   return "SCORE"
            case .chainDepth:   return "CHAIN"
            case .triggerBombs: return "BOMBS"
            }
        }
    }
}

// MARK: - BackButton

final class BackButton: SKNode {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init()
        isUserInteractionEnabled = true

        let bg = SKShapeNode(circleOfRadius: 18)
        bg.fillColor   = UIColor(white: 0, alpha: 0.08)
        bg.strokeColor = UIColor(white: 0, alpha: 0.15)
        bg.lineWidth   = 1
        addChild(bg)

        let arrow = SKLabelNode(text: "‹")
        arrow.fontName  = "AvenirNext-Bold"
        arrow.fontSize  = 26
        arrow.fontColor = Palette.text
        arrow.horizontalAlignmentMode = .center
        arrow.verticalAlignmentMode   = .center
        arrow.position  = CGPoint(x: -1, y: -1)
        addChild(arrow)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 0.88, duration: 0.07))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 1.0, duration: 0.07)) { [weak self] in self?.action() }
    }
}
