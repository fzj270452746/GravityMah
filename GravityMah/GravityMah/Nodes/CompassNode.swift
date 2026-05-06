import SpriteKit

// HUD overlay: score, steps, objective, chain combo
final class CompassNode: SKNode {

    private let tallyLabel:   SKLabelNode
    private let stepsLabel:   SKLabelNode
    private let objectiveLabel: SKLabelNode
    private let comboLabel:   SKLabelNode
    private var comboHideAction: SKAction?

    override init() {
        tallyLabel     = SKLabelNode()
        stepsLabel     = SKLabelNode()
        objectiveLabel = SKLabelNode()
        comboLabel     = SKLabelNode()
        super.init()
    }

    required init?(coder: NSCoder) { fatalError() }

    func refresh(tally: Int, steps: Int, objective: String) {
        tallyLabel.text     = "\(tally)"
        stepsLabel.text     = "\(steps)"
        objectiveLabel.text = objective
    }

    func flashCombo(depth: Int) {
        guard depth >= 2 else { return }
        comboLabel.text  = "CHAIN ×\(depth)!"
        comboLabel.alpha = 1
        comboLabel.setScale(1.4)
        comboLabel.run(.sequence([
            .scale(to: 1.0, duration: 0.15),
            .wait(forDuration: 1.0),
            .fadeOut(withDuration: 0.3)
        ]))
    }

    func pulseTally() {
        tallyLabel.run(.sequence([
            .scale(to: 1.3, duration: 0.08),
            .scale(to: 1.0, duration: 0.1)
        ]))
    }

    // MARK: - Layout

    func layout(in size: CGSize, topInset: CGFloat = 0) {
        let topY = size.height / 2 - topInset - 38

        // Score panel — offset right to clear the back button (radius 18, at x = -w/2+24)
        let scorePanel = panel(width: 120, height: 56)
        scorePanel.position = CGPoint(x: -size.width / 2 + 110, y: topY)
        addChild(scorePanel)

        let scoreCap = caption("SCORE")
        scoreCap.position = CGPoint(x: 0, y: 14)
        scorePanel.addChild(scoreCap)

        tallyLabel.fontName  = "AvenirNext-Bold"
        tallyLabel.fontSize  = 22
        tallyLabel.fontColor = Palette.text
        tallyLabel.horizontalAlignmentMode = .center
        tallyLabel.verticalAlignmentMode   = .center
        tallyLabel.position  = CGPoint(x: 0, y: -8)
        scorePanel.addChild(tallyLabel)

        // Steps panel
        let stepsPanel = panel(width: 100, height: 56)
        stepsPanel.position = CGPoint(x: size.width / 2 - 65, y: topY)
        addChild(stepsPanel)

        let stepsCap = caption("MOVES")
        stepsCap.position = CGPoint(x: 0, y: 14)
        stepsPanel.addChild(stepsCap)

        stepsLabel.fontName  = "AvenirNext-Bold"
        stepsLabel.fontSize  = 22
        stepsLabel.fontColor = Palette.text
        stepsLabel.horizontalAlignmentMode = .center
        stepsLabel.verticalAlignmentMode   = .center
        stepsLabel.position  = CGPoint(x: 0, y: -8)
        stepsPanel.addChild(stepsLabel)

        // Objective — below title row
        objectiveLabel.fontName  = "AvenirNext-Medium"
        objectiveLabel.fontSize  = 13
        objectiveLabel.fontColor = Palette.subtext
        objectiveLabel.horizontalAlignmentMode = .center
        objectiveLabel.position = CGPoint(x: 0, y: topY - 56)
        addChild(objectiveLabel)

        // Combo
        comboLabel.fontName  = "AvenirNext-Heavy"
        comboLabel.fontSize  = 28
        comboLabel.fontColor = UIColor(hex: "#E6B800")
        comboLabel.horizontalAlignmentMode = .center
        comboLabel.verticalAlignmentMode   = .center
        comboLabel.alpha     = 0
        comboLabel.position  = CGPoint(x: 0, y: 0)
        addChild(comboLabel)
    }

    private func panel(width: CGFloat, height: CGFloat) -> SKShapeNode {
        let r = CGRect(x: -width/2, y: -height/2, width: width, height: height)
        let n = SKShapeNode(rect: r, cornerRadius: 12)
        n.fillColor   = UIColor(white: 0, alpha: 0.06)
        n.strokeColor = UIColor(white: 0, alpha: 0.12)
        n.lineWidth   = 1
        return n
    }

    private func caption(_ text: String) -> SKLabelNode {
        let l = SKLabelNode(text: text)
        l.fontName  = "AvenirNext-Medium"
        l.fontSize  = 10
        l.fontColor = Palette.subtext
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode   = .center
        return l
    }
}
