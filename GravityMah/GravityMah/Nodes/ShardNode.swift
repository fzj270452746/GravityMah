import SpriteKit

final class ShardNode: SKNode {

    let shard: Shard
    private let backdrop: SKShapeNode
    private let label: SKLabelNode
    private let nimbus: SKShapeNode

    var isChosen: Bool = false {
        didSet { refreshChosen() }
    }

    init(shard: Shard, size: CGFloat) {
        self.shard = shard
        let tileW  = size * 0.76
        let tileH  = size * 0.90
        let rect   = CGRect(x: -tileW/2, y: -tileH/2, width: tileW, height: tileH)
        backdrop   = SKShapeNode(rect: rect, cornerRadius: 5)
        label      = SKLabelNode(fontNamed: "PingFangSC-Semibold")
        nimbus     = SKShapeNode(rect: rect.insetBy(dx: -4, dy: -4), cornerRadius: 9)
        super.init()
        setup(size: size, tileW: tileW, tileH: tileH)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Animations

    func kindle() {
        run(.sequence([
            .scale(to: 1.12, duration: 0.08),
            .scale(to: 1.0,  duration: 0.08)
        ]))
    }

    func disperse(completion: @escaping () -> Void) {
        run(.sequence([
            .group([
                .scale(to: 1.25, duration: 0.12),
                .fadeAlpha(to: 0, duration: 0.18)
            ]),
            .removeFromParent(),
            .run(completion)
        ]))
    }

    func plummet(to dest: CGPoint, duration: TimeInterval = 0.22, completion: (() -> Void)? = nil) {
        let drop = SKAction.move(to: dest, duration: duration)
        drop.timingMode = .easeIn
        if let cb = completion {
            run(.sequence([drop, .run(cb)]))
        } else {
            run(drop)
        }
    }

    func flashWarning() {
        backdrop.run(.sequence([
            .colorize(with: UIColor(hex: "#FF4757"), colorBlendFactor: 0.65, duration: 0.10),
            .colorize(withColorBlendFactor: 0, duration: 0.10),
            .colorize(with: UIColor(hex: "#FF4757"), colorBlendFactor: 0.65, duration: 0.10),
            .colorize(withColorBlendFactor: 0, duration: 0.10),
            .colorize(with: UIColor(hex: "#FF4757"), colorBlendFactor: 0.65, duration: 0.10),
            .colorize(withColorBlendFactor: 0, duration: 0.10),
        ]))
    }

    func shimmer() {
        backdrop.run(.sequence([
            .colorize(with: .white, colorBlendFactor: 0.4, duration: 0.06),
            .colorize(withColorBlendFactor: 0, duration: 0.12)
        ]))
    }

    // MARK: - Private

    private func setup(size: CGFloat, tileW: CGFloat, tileH: CGFloat) {
        // Drop shadow
        let shadowRect = CGRect(x: -tileW/2 + 2, y: -tileH/2 - 3, width: tileW, height: tileH)
        let shadow = SKShapeNode(rect: shadowRect, cornerRadius: 5)
        shadow.fillColor   = UIColor(white: 0, alpha: 0.32)
        shadow.strokeColor = .clear
        shadow.zPosition   = -2
        addChild(shadow)

        // Tile body
        backdrop.fillColor   = bodyColor()
        backdrop.strokeColor = borderColor()
        backdrop.lineWidth   = 1.2
        backdrop.zPosition   = 0
        addChild(backdrop)

        // Top highlight (3D raised effect)
        let hlRect = CGRect(x: -tileW/2 + 2, y: tileH/2 - 5, width: tileW - 4, height: 3)
        let hl = SKShapeNode(rect: hlRect, cornerRadius: 1)
        hl.fillColor   = UIColor(white: 1, alpha: 0.55)
        hl.strokeColor = .clear
        hl.zPosition   = 1
        addChild(hl)

        // Suit label (small, above main character)
        let suit = suitChar()
        if !suit.isEmpty {
            let suitLbl = SKLabelNode(text: suit)
            suitLbl.fontName  = "PingFangSC-Regular"
            suitLbl.fontSize  = size * 0.17
            suitLbl.fontColor = symbolColor().withAlphaComponent(0.7)
            suitLbl.horizontalAlignmentMode = .center
            suitLbl.verticalAlignmentMode   = .center
            suitLbl.position  = CGPoint(x: 0, y: tileH * 0.24)
            suitLbl.zPosition = 2
            addChild(suitLbl)
        }

        // Main character
        label.fontSize   = size * 0.40
        label.fontColor  = symbolColor()
        label.verticalAlignmentMode   = .center
        label.horizontalAlignmentMode = .center
        label.position   = CGPoint(x: 0, y: -tileH * 0.05)
        label.zPosition  = 2
        label.text       = mainText()
        addChild(label)

        // Selection glow ring
        nimbus.fillColor   = .clear
        nimbus.strokeColor = UIColor(hex: "#FFD700")
        nimbus.lineWidth   = 2.5
        nimbus.alpha       = 0
        nimbus.zPosition   = -1
        addChild(nimbus)
    }

    private func bodyColor() -> UIColor {
        switch shard.variant {
        case .numeral, .anchor: return UIColor(hex: "#F5F0E6")
        case .bomb:             return UIColor(hex: "#2C2C54")
        case .wild:             return UIColor(hex: "#3D2B6B")
        }
    }

    private func borderColor() -> UIColor {
        switch shard.variant {
        case .numeral, .anchor: return UIColor(white: 0.72, alpha: 1)
        case .bomb:             return UIColor(hex: "#FF4757").withAlphaComponent(0.6)
        case .wild:             return UIColor(hex: "#FFD700").withAlphaComponent(0.5)
        }
    }

    private func symbolColor() -> UIColor {
        switch shard.variant {
        case .numeral(let n), .anchor(let n): return suitColor(for: n)
        case .bomb:  return UIColor(hex: "#FF4757")
        case .wild:  return UIColor(hex: "#FFD700")
        }
    }

    private func suitColor(for n: Int) -> UIColor {
        switch n {
        case 1...3: return UIColor(hex: "#C0392B")
        case 4...6: return UIColor(hex: "#1A5276")
        default:    return UIColor(hex: "#1E8449")
        }
    }

    private func suitChar() -> String {
        guard let n = shard.variant.cipher else { return "" }
        switch n {
        case 1...3: return "万"
        case 4...6: return "筒"
        default:    return "条"
        }
    }

    private func mainText() -> String {
        switch shard.variant {
        case .numeral(let n), .anchor(let n):
            return ["一","二","三","四","五","六","七","八","九"][max(0, min(n-1, 8))]
        case .bomb: return "炸"
        case .wild: return "百"
        }
    }

    private func refreshChosen() {
        nimbus.run(.fadeAlpha(to: isChosen ? 1 : 0, duration: 0.15))
        run(.scale(to: isChosen ? 1.06 : 1.0, duration: 0.12))
    }
}
