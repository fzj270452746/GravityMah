import SpriteKit

final class VaultScene: SKScene {

    private var floatingShards: [SKNode] = []

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Palette.bg
        buildBackground()
        buildTitle()
        buildButtons()
        Harbinger.shared.igniteMusic()
    }

    // MARK: - Build

    private func buildBackground() {
        let grad = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        grad.fillColor   = Palette.bg
        grad.strokeColor = .clear
        grad.position    = CGPoint(x: -size.width/2, y: -size.height/2)
        grad.zPosition   = -10
        addChild(grad)

        for _ in 0..<12 {
            spawnAmbientShard()
        }
    }

    private func spawnAmbientShard() {
        let numerals  = ["一","二","三","四","五","六","七","八","九"]
        let suits     = ["万","筒","条"]
        let suitColors: [UIColor] = [Palette.wan, Palette.tong, Palette.tiao]
        let idx     = Int.random(in: 0..<9)
        let suitIdx = idx / 3

        let tileW: CGFloat = 28
        let tileH: CGFloat = 36
        let node = SKShapeNode(rect: CGRect(x: -tileW/2, y: -tileH/2, width: tileW, height: tileH), cornerRadius: 4)
        node.fillColor   = UIColor(hex: "#F5F0E6").withAlphaComponent(0.7)
        node.strokeColor = UIColor(white: 0, alpha: 0.12)
        node.lineWidth   = 1

        let numLbl = SKLabelNode(text: numerals[idx])
        numLbl.fontName  = "PingFangSC-Semibold"
        numLbl.fontSize  = 14
        numLbl.fontColor = suitColors[suitIdx].withAlphaComponent(0.7)
        numLbl.horizontalAlignmentMode = .center
        numLbl.verticalAlignmentMode   = .center
        numLbl.position = CGPoint(x: 0, y: -2)
        node.addChild(numLbl)

        let suitLbl = SKLabelNode(text: suits[suitIdx])
        suitLbl.fontName  = "PingFangSC-Regular"
        suitLbl.fontSize  = 8
        suitLbl.fontColor = suitColors[suitIdx].withAlphaComponent(0.5)
        suitLbl.horizontalAlignmentMode = .center
        suitLbl.verticalAlignmentMode   = .center
        suitLbl.position = CGPoint(x: 0, y: tileH/2 - 7)
        node.addChild(suitLbl)

        let x = CGFloat.random(in: -size.width/2 ... size.width/2)
        node.position = CGPoint(x: x, y: -size.height/2 - 40)
        node.zPosition = -5
        addChild(node)
        floatingShards.append(node)

        let duration = Double.random(in: 8...16)
        let destY    = size.height/2 + 60
        node.run(.sequence([
            .group([
                .moveTo(y: destY, duration: duration),
                .sequence([
                    .fadeAlpha(to: 0.5, duration: duration * 0.3),
                    .fadeAlpha(to: 0,   duration: duration * 0.7)
                ])
            ]),
            .removeFromParent(),
            .run { [weak self] in self?.spawnAmbientShard() }
        ]))
    }

    private func buildTitle() {
        let compactHeight = size.height < 760
        let titleY = compactHeight ? size.height * 0.27 : size.height * 0.22
        let titleSize: CGFloat = compactHeight ? 44 : 52
        let subSize: CGFloat = compactHeight ? 24 : 28
        let tagSize: CGFloat = compactHeight ? 12 : 14
        let supportSize: CGFloat = compactHeight ? 11 : 13
        let subOffset: CGFloat = compactHeight ? 40 : 46
        let tagOffset: CGFloat = compactHeight ? 68 : 82
        let supportOffset: CGFloat = compactHeight ? 88 : 104

        let glow = SKLabelNode(text: "GRAVITY")
        glow.fontName  = "AvenirNext-Heavy"
        glow.fontSize  = titleSize
        glow.fontColor = Palette.accent.withAlphaComponent(0.15)
        glow.horizontalAlignmentMode = .center
        glow.position  = CGPoint(x: 2, y: titleY + 2)
        glow.zPosition = 1
        addChild(glow)

        let title = SKLabelNode(text: "GRAVITY")
        title.fontName  = "AvenirNext-Heavy"
        title.fontSize  = titleSize
        title.fontColor = Palette.text
        title.horizontalAlignmentMode = .center
        title.position  = CGPoint(x: 0, y: titleY)
        title.zPosition = 2
        addChild(title)

        let sub = SKLabelNode(text: "MAHJONG")
        sub.fontName  = "AvenirNext-Bold"
        sub.fontSize  = subSize
        sub.fontColor = Palette.accent
        sub.horizontalAlignmentMode = .center
        sub.position  = CGPoint(x: 0, y: titleY - subOffset)
        sub.zPosition = 2
        addChild(sub)

        sub.run(.repeatForever(.sequence([
            .scale(to: 1.04, duration: 1.2),
            .scale(to: 1.0,  duration: 1.2)
        ])))

        let tag = SKLabelNode(text: "Gravity Puzzle · Chain Strategy")
        tag.fontName  = "AvenirNext-Medium"
        tag.fontSize  = tagSize
        tag.fontColor = Palette.subtext
        tag.horizontalAlignmentMode = .center
        tag.position  = CGPoint(x: 0, y: titleY - tagOffset)
        addChild(tag)

        let support = SKLabelNode(text: "Build matches through falling tiles")
        support.fontName  = "AvenirNext-Regular"
        support.fontSize  = supportSize
        support.fontColor = Palette.subtext.withAlphaComponent(0.82)
        support.horizontalAlignmentMode = .center
        support.position  = CGPoint(x: 0, y: titleY - supportOffset)
        addChild(support)
    }

    private func buildButtons() {
        let compactHeight = size.height < 760
        let centerY: CGFloat = compactHeight ? -size.height * 0.16 : -size.height * 0.08
        let spacing: CGFloat = compactHeight ? 54 : 62

        addMenuButton("PLAY",          color: Palette.accent,                  y: centerY + spacing * 1.5) { [weak self] in self?.navigateToAtlas() }
        addMenuButton("HOW TO PLAY",   color: UIColor(white: 0, alpha: 0.08),  y: centerY + spacing * 0.5) { [weak self] in self?.showTutorial() }
        addMenuButton("ACHIEVEMENTS",  color: UIColor(white: 0, alpha: 0.08),  y: centerY - spacing * 0.5) { [weak self] in self?.showAchievements() }
        addMenuButton("SETTINGS",      color: UIColor(white: 0, alpha: 0.08),  y: centerY - spacing * 1.5) { [weak self] in self?.showSettings() }

        let best = Reliquary.shared.bestTally(for: 0)
        if best > 0 {
            let l = SKLabelNode(text: "Best  \(best)")
            l.fontName  = "AvenirNext-Medium"
            l.fontSize  = compactHeight ? 12 : 14
            l.fontColor = Palette.subtext
            l.horizontalAlignmentMode = .center
            l.position  = CGPoint(x: 0, y: centerY - spacing * 2.55)
            addChild(l)
        }

        let ver = SKLabelNode(text: "v1.0")
        ver.fontName  = "AvenirNext-Regular"
        ver.fontSize  = 11
        ver.fontColor = Palette.subtext.withAlphaComponent(0.5)
        ver.horizontalAlignmentMode = .center
        ver.position  = CGPoint(x: 0, y: -size.height/2 + 28)
        addChild(ver)
    }

    private func addMenuButton(_ title: String, color: UIColor, y: CGFloat, action: @escaping () -> Void) {
        let compactHeight = size.height < 760
        let btn = VaultButton(title: title, color: color, width: compactHeight ? 208 : 220, height: compactHeight ? 48 : 54, action: action)
        btn.position = CGPoint(x: 0, y: y)
        addChild(btn)
    }

    // MARK: - Navigation

    private func navigateToAtlas() {
        Harbinger.shared.vibrate(.medium)
        Harbinger.shared.toll("tap")
        guard let vc = view?.window?.rootViewController as? GatewayController else { return }
        let atlas = AtlasViewController()
        atlas.safeAreaData = vc.safeAreaUserData()
        atlas.modalPresentationStyle = .fullScreen
        atlas.modalTransitionStyle   = .coverVertical
        vc.present(atlas, animated: true)
    }

    private func showSettings() {
        Harbinger.shared.vibrate(.light)
        let p = Parchment.settings(size: size) {}
        addChild(p)
        p.appear()
    }

    private func showTutorial() {
        Harbinger.shared.vibrate(.light)
        Harbinger.shared.toll("tap")
        guard let vc = view?.window?.rootViewController as? GatewayController else { return }
        let tutorial = TutorialViewController()
        tutorial.modalPresentationStyle = .fullScreen
        tutorial.modalTransitionStyle   = .coverVertical
        vc.present(tutorial, animated: true)
    }

    private func showAchievements() {
        Harbinger.shared.vibrate(.light)
        Harbinger.shared.toll("tap")
        guard let vc = view?.window?.rootViewController as? GatewayController else { return }
        let achievements = AchievementViewController()
        achievements.modalPresentationStyle = .fullScreen
        achievements.modalTransitionStyle   = .coverVertical
        vc.present(achievements, animated: true)
    }
}

// MARK: - VaultButton

private final class VaultButton: SKNode {
    private let action: () -> Void

    init(title: String, color: UIColor, width: CGFloat, height: CGFloat, action: @escaping () -> Void) {
        self.action = action
        super.init()
        isUserInteractionEnabled = true

        let rect = CGRect(x: -width/2, y: -height/2, width: width, height: height)
        let bg = SKShapeNode(rect: rect, cornerRadius: height / 2)
        bg.fillColor   = color
        bg.strokeColor = color.withAlphaComponent(0.3)
        bg.lineWidth   = 1
        addChild(bg)

        let l = SKLabelNode(text: title)
        l.fontName  = "AvenirNext-Bold"
        l.fontSize  = 17
        l.fontColor = color == Palette.accent ? .white : Palette.text
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        addChild(l)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 0.95, duration: 0.07))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(.scale(to: 1.0, duration: 0.07)) { [weak self] in self?.action() }
    }
}
