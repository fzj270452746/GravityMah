import SpriteKit

// Custom modal dialog — replaces all system alerts
final class Parchment: SKNode {

    private let backdrop: SKShapeNode
    private let dimmer: SKSpriteNode
    var onDismiss: (() -> Void)?

    init(size: CGSize) {
        let w: CGFloat = min(size.width - 60, 320)
        let h: CGFloat = 380
        let rect = CGRect(x: -w/2, y: -h/2, width: w, height: h)
        backdrop = SKShapeNode(rect: rect, cornerRadius: 24)
        dimmer   = SKSpriteNode(color: UIColor(white: 0, alpha: 0.6), size: size)
        super.init()
        setup(cardSize: CGSize(width: w, height: h))
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Factory

    static func triumph(size: CGSize, tally: Int, stars: Int,
                        onNext: @escaping () -> Void,
                        onMenu: @escaping () -> Void) -> Parchment {
        let p = Parchment(size: size)
        p.addTitle("Level Clear!", color: UIColor(hex: "#C0392B"))
        p.addStars(stars)
        p.addScoreRow(tally: tally)
        p.addButton("Next Level", color: UIColor(hex: "#C0392B"), yOffset: -80, action: {
            p.vanish { onNext() }
        })
        p.addButton("Menu", color: UIColor(white: 0, alpha: 0.08), yOffset: -140, action: {
            p.vanish { onMenu() }
        })
        return p
    }

    static func defeat(size: CGSize, tally: Int,
                       onRetry: @escaping () -> Void,
                       onMenu: @escaping () -> Void) -> Parchment {
        let p = Parchment(size: size)
        p.addTitle("Out of Moves", color: UIColor(hex: "#FF4757"))
        p.addSubtitle("Score: \(tally)")
        p.addButton("Try Again", color: UIColor(hex: "#C0392B"), yOffset: -80, action: {
            p.vanish { onRetry() }
        })
        p.addButton("Menu", color: UIColor(white: 0, alpha: 0.08), yOffset: -140, action: {
            p.vanish { onMenu() }
        })
        return p
    }

    static func settings(size: CGSize, onClose: @escaping () -> Void) -> Parchment {
        let p = Parchment(size: size)
        p.addTitle("Settings", color: Palette.text)
        p.addToggleRow("Sound",   yOffset:  60,
                       getter: { Reliquary.shared.soundOn },
                       setter: { Reliquary.shared.soundOn = $0 })
        p.addToggleRow("Music",   yOffset:   0,
                       getter: { Reliquary.shared.musicOn },
                       setter: { Reliquary.shared.musicOn = $0 })
        p.addToggleRow("Haptics", yOffset: -60,
                       getter: { Reliquary.shared.hapticsOn },
                       setter: { Reliquary.shared.hapticsOn = $0 })
        p.addButton("Close", color: UIColor(hex: "#C0392B"), yOffset: -140, action: {
            p.vanish { onClose() }
        })
        return p
    }

    func appear() {
        alpha = 0
        setScale(0.85)
        run(.group([.fadeIn(withDuration: 0.22), .scale(to: 1, duration: 0.22)]))
    }

    func vanish(completion: @escaping () -> Void) {
        run(.group([.fadeOut(withDuration: 0.18), .scale(to: 0.85, duration: 0.18)])) {
            self.removeFromParent()
            completion()
        }
    }

    // MARK: - Private builders

    private func setup(cardSize: CGSize) {
        zPosition = 100
        dimmer.zPosition = -1
        addChild(dimmer)

        backdrop.fillColor   = UIColor(hex: "#FAF6EE")
        backdrop.strokeColor = UIColor(white: 0, alpha: 0.1)
        backdrop.lineWidth   = 1.5
        addChild(backdrop)
    }

    private func addTitle(_ text: String, color: UIColor) {
        let l = SKLabelNode(text: text)
        l.fontName  = "AvenirNext-Heavy"
        l.fontSize  = 26
        l.fontColor = color
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        l.position = CGPoint(x: 0, y: 130)
        backdrop.addChild(l)
    }

    private func addSubtitle(_ text: String) {
        let l = SKLabelNode(text: text)
        l.fontName  = "AvenirNext-Medium"
        l.fontSize  = 18
        l.fontColor = Palette.subtext
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        l.position = CGPoint(x: 0, y: 80)
        backdrop.addChild(l)
    }

    private func addStars(_ count: Int) {
        let spacing: CGFloat = 44
        for i in 0..<3 {
            let star = SKLabelNode(text: i < count ? "★" : "☆")
            star.fontName  = "AvenirNext-Bold"
            star.fontSize  = 36
            star.fontColor = i < count ? UIColor(hex: "#E6B800") : UIColor(white: 0, alpha: 0.2)
            star.horizontalAlignmentMode = .center
            star.verticalAlignmentMode   = .center
            star.position = CGPoint(x: CGFloat(i - 1) * spacing, y: 70)
            backdrop.addChild(star)
        }
    }

    private func addScoreRow(tally: Int) {
        let l = SKLabelNode(text: "Score  \(tally)")
        l.fontName  = "AvenirNext-Bold"
        l.fontSize  = 20
        l.fontColor = Palette.text
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        l.position = CGPoint(x: 0, y: 10)
        backdrop.addChild(l)
    }

    private func addButton(_ title: String, color: UIColor, yOffset: CGFloat, action: @escaping () -> Void) {
        let btn = ParchmentButton(title: title, color: color, width: 220, height: 48, action: action)
        btn.position = CGPoint(x: 0, y: yOffset)
        backdrop.addChild(btn)
    }

    private func addToggleRow(_ title: String, yOffset: CGFloat, getter: @escaping () -> Bool, setter: @escaping (Bool) -> Void) {
        let row = ToggleRow(title: title, getter: getter, setter: setter)
        row.position = CGPoint(x: 0, y: yOffset)
        backdrop.addChild(row)
    }
}

// MARK: - ParchmentButton

private final class ParchmentButton: SKNode {
    private let action: () -> Void

    init(title: String, color: UIColor, width: CGFloat, height: CGFloat, action: @escaping () -> Void) {
        self.action = action
        super.init()
        isUserInteractionEnabled = true

        let rect = CGRect(x: -width/2, y: -height/2, width: width, height: height)
        let bg = SKShapeNode(rect: rect, cornerRadius: height / 2)
        bg.fillColor   = color
        bg.strokeColor = .clear
        addChild(bg)

        let l = SKLabelNode(text: title)
        l.fontName  = "AvenirNext-Bold"
        l.fontSize  = 16
        l.fontColor = color == UIColor(hex: "#C0392B") ? .white : Palette.text
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        addChild(l)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 0.94, duration: 0.08))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 1.0, duration: 0.08)) { [weak self] in self?.action() }
        Harbinger.shared.vibrate(.light)
    }
}

// MARK: - ToggleRow

private final class ToggleRow: SKNode {
    private let getter: () -> Bool
    private let setter: (Bool) -> Void
    private let indicator: SKShapeNode

    init(title: String, getter: @escaping () -> Bool, setter: @escaping (Bool) -> Void) {
        self.getter    = getter
        self.setter    = setter
        indicator = SKShapeNode(circleOfRadius: 12)
        super.init()
        isUserInteractionEnabled = true
        setup(title: title)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup(title: String) {
        let l = SKLabelNode(text: title)
        l.fontName  = "AvenirNext-Medium"
        l.fontSize  = 16
        l.fontColor = Palette.text
        l.horizontalAlignmentMode = .left
        l.verticalAlignmentMode   = .center
        l.position = CGPoint(x: -90, y: 0)
        addChild(l)

        let track = SKShapeNode(rect: CGRect(x: -22, y: -12, width: 44, height: 24), cornerRadius: 12)
        track.fillColor   = UIColor(white: 0, alpha: 0.08)
        track.strokeColor = UIColor(white: 0, alpha: 0.15)
        track.position    = CGPoint(x: 80, y: 0)
        addChild(track)

        let on = getter()
        indicator.fillColor   = on ? UIColor(hex: "#C0392B") : UIColor(white: 0.7, alpha: 1)
        indicator.strokeColor = .clear
        indicator.position    = CGPoint(x: 80 + (on ? 10 : -10), y: 0)
        addChild(indicator)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let on = !getter()
        setter(on)
        indicator.run(.move(to: CGPoint(x: 80 + (on ? 10 : -10), y: 0), duration: 0.15))
        indicator.fillColor = on ? UIColor(hex: "#C0392B") : UIColor(white: 0.7, alpha: 1)
        Harbinger.shared.vibrate(.light)
    }
}
