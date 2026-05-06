import SpriteKit

final class ArenaScene: SKScene {

    private let stratum: Codex.Stratum
    private var arbiter: Arbiter!
    private var board: CrucibleNode!
    private var compass: CompassNode!
    private var busy = false
    private var longestChain = 0
    private var reshuffleHappened = false
    private var achievementQueue: [Achievement] = []
    private var bannerShowing = false

    init(size: CGSize, stratum: Codex.Stratum) {
        self.stratum = stratum
        super.init(size: size)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Palette.bg
        arbiter = Arbiter(stratum: stratum)
        arbiter.delegate = self
        buildBackground()
        buildHUD()
        buildBoard()
        refreshHUD()
        arbiter.checkAndReshuffle()
    }

    // MARK: - Build

    private func buildBackground() {
        let bg = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        bg.fillColor   = Palette.bg
        bg.strokeColor = .clear
        bg.position    = CGPoint(x: -size.width/2, y: -size.height/2)
        bg.zPosition   = -10
        addChild(bg)

        let bw = CGFloat(stratum.cols) * computeCellSize() + 24
        let bh = CGFloat(stratum.rows) * computeCellSize() + 24
        let felt = SKShapeNode(rect: CGRect(x: -bw/2, y: -bh/2, width: bw, height: bh), cornerRadius: 18)
        felt.fillColor   = Palette.felt
        felt.strokeColor = Palette.feltEdge
        felt.lineWidth   = 2
        felt.position    = boardCenter()
        felt.zPosition   = -8
        addChild(felt)
    }

    private func buildHUD() {
        let topInset = safeTop + 12
        compass = CompassNode()
        compass.zPosition = 10
        addChild(compass)
        compass.layout(in: size, topInset: topInset)

        // Back button — vertically centered with panels
        let back = BackButton { [weak self] in self?.confirmExit() }
        back.position = CGPoint(x: -size.width/2 + 24, y: size.height/2 - topInset - 38)
        back.zPosition = 10
        addChild(back)

        // Level title — row below the panels, above objective
        let title = SKLabelNode(text: "Level \(stratum.index + 1)  \(stratum.title)")
        title.fontName  = "AvenirNext-Medium"
        title.fontSize  = 13
        title.fontColor = Palette.subtext
        title.horizontalAlignmentMode = .center
        title.position  = CGPoint(x: 0, y: size.height/2 - topInset - 76)
        title.zPosition = 10
        addChild(title)
    }

    private func buildBoard() {
        let cellSize = computeCellSize()
        board = CrucibleNode(cols: stratum.cols, rows: stratum.rows, cellSize: cellSize)
        board.position  = boardCenter()
        board.zPosition = 5
        addChild(board)
        board.populate(with: arbiter.crucible)
        board.onSwapAttempt = { [weak self] a, b in self?.handleSwap(a, b) }
    }

    private func computeCellSize() -> CGFloat {
        let usableW = size.width  - 32
        let usableH = size.height - 220
        let byW = usableW / CGFloat(stratum.cols)
        let byH = usableH / CGFloat(stratum.rows)
        return min(byW, byH, 72)
    }

    private func boardCenter() -> CGPoint {
        CGPoint(x: 0, y: -size.height * 0.04)
    }

    private func refreshHUD() {
        compass.refresh(
            tally:     arbiter.tally,
            steps:     arbiter.stepsLeft,
            objective: stratum.objective.description
        )
    }

    // MARK: - Swap handling

    private func handleSwap(_ a: (Int, Int), _ b: (Int, Int)) {
        guard !busy else { return }
        busy = true
        board.isUserInteractionEnabled = false

        Harbinger.shared.toll("swap")
        board.animateSwap(a: a, b: b) { [weak self] in
            guard let self else { return }
            let accepted = self.arbiter.attempt(swap: a, and: b)
            guard !accepted else { return }

            Harbinger.shared.vibrate(.rigid)
            self.board.animateSwap(a: a, b: b) { [weak self] in
                self?.busy = false
                self?.board.isUserInteractionEnabled = true
                self?.arbiter.checkAndReshuffle()
            }
        }
    }

    // MARK: - Animations driven by Arbiter delegate

    func runCascadeAnimation(result: CascadeResult, then: @escaping () -> Void) {
        guard !result.waves.isEmpty else { then(); return }
        runWave(result.waves, index: 0, then: then)
    }

    private func runWave(_ waves: [WaveResult], index: Int, then: @escaping () -> Void) {
        guard index < waves.count else { then(); return }
        let wave      = waves[index]
        let positions = wave.accords.flatMap { $0.positions }

        if index >= 1 {
            compass.flashCombo(depth: index + 1)
            Harbinger.shared.toll("chain")
            Harbinger.shared.vibrate(.medium)
        } else {
            Harbinger.shared.toll("match")
            Harbinger.shared.vibrate(.light)
        }

        spawnMatchParticles(at: positions)

        board.animateDisperse(positions: positions) { [weak self] in
            guard let self else { return }
            self.board.animatePlummet(moves: wave.fallMoves) {
                self.runWave(waves, index: index + 1, then: then)
            }
        }
    }

    private func spawnMatchParticles(at positions: [(Int, Int)]) {
        for pos in positions {
            let worldPos = board.convert(board.position(for: pos.0, row: pos.1), to: self)
            let burst = SKShapeNode(circleOfRadius: 4)
            burst.fillColor   = UIColor(hex: "#FFD700")
            burst.strokeColor = .clear
            burst.position    = worldPos
            burst.zPosition   = 20
            addChild(burst)
            burst.run(.sequence([
                .group([
                    .scale(to: 3.0, duration: 0.3),
                    .fadeOut(withDuration: 0.3)
                ]),
                .removeFromParent()
            ]))
        }
    }

    // MARK: - Navigation

    private func confirmExit() {
        guard arbiter.flux == .idle || arbiter.flux == .triumph || arbiter.flux == .defeat else { return }
        goToMenu()
    }

    private func goToMenu() {
        let vault = VaultScene(size: size)
        vault.scaleMode = scaleMode
        relay(safeArea: vault)
        view?.presentScene(vault, transition: .push(with: .right, duration: 0.3))
    }

    private func showTriumph() {
        let stars = computeStars()
        Reliquary.shared.enshrine(stars: stars, for: stratum.index)
        Reliquary.shared.enshrine(tally: arbiter.tally, for: stratum.index)
        Harbinger.shared.notify(.success)

        let ctx = Reliquary.GameContext(
            levelIndex:    stratum.index,
            triumph:       true,
            score:         arbiter.tally,
            stepsLeft:     arbiter.stepsLeft,
            stepLimit:     stratum.stepLimit,
            chainDepth:    arbiter.longestChain,
            groupsCleared: arbiter.accordsCleared,
            bombsTriggered: arbiter.bombsTriggered,
            reshuffled:    reshuffleHappened
        )
        let unlocked = Reliquary.shared.evaluateAchievements(ctx)
        enqueueAchievements(unlocked)

        let nextIndex = stratum.index + 1
        let p = Parchment.triumph(
            size: size,
            tally: arbiter.tally,
            stars: stars,
            onNext: { [weak self] in
                guard let self else { return }
                if nextIndex < Codex.strata.count {
                    let next = ArenaScene(size: self.size, stratum: Codex.strata[nextIndex])
                    next.scaleMode = self.scaleMode
                    self.relay(safeArea: next)
                    self.view?.presentScene(next, transition: .push(with: .left, duration: 0.35))
                } else {
                    self.goToMenu()
                }
            },
            onMenu: { [weak self] in self?.goToMenu() }
        )
        addChild(p)
        p.appear()
    }

    private func showDefeat() {
        Harbinger.shared.notify(.error)
        let ctx = Reliquary.GameContext(
            levelIndex:    stratum.index,
            triumph:       false,
            score:         arbiter.tally,
            stepsLeft:     arbiter.stepsLeft,
            stepLimit:     stratum.stepLimit,
            chainDepth:    arbiter.longestChain,
            groupsCleared: arbiter.accordsCleared,
            bombsTriggered: arbiter.bombsTriggered,
            reshuffled:    reshuffleHappened
        )
        let unlocked = Reliquary.shared.evaluateAchievements(ctx)
        enqueueAchievements(unlocked)
        let p = Parchment.defeat(
            size: size,
            tally: arbiter.tally,
            onRetry: { [weak self] in
                guard let self else { return }
                let retry = ArenaScene(size: self.size, stratum: self.stratum)
                retry.scaleMode = self.scaleMode
                self.relay(safeArea: retry)
                self.view?.presentScene(retry, transition: .fade(withDuration: 0.3))
            },
            onMenu: { [weak self] in self?.goToMenu() }
        )
        addChild(p)
        p.appear()
    }

    private func showReshuffleHint() {
        let lbl = SKLabelNode(text: "Shuffle!")
        lbl.fontName  = "AvenirNext-Heavy"
        lbl.fontSize  = 34
        lbl.fontColor = UIColor(hex: "#C0392B")
        lbl.horizontalAlignmentMode = .center
        lbl.verticalAlignmentMode   = .center
        lbl.position  = CGPoint(x: 0, y: 0)
        lbl.zPosition = 50
        lbl.alpha     = 0
        addChild(lbl)
        lbl.run(.sequence([
            .fadeIn(withDuration: 0.18),
            .wait(forDuration: 0.55),
            .fadeOut(withDuration: 0.18),
            .removeFromParent()
        ]))
    }

    private func computeStars() -> Int {
        let ratio = Double(arbiter.stepsLeft) / Double(stratum.stepLimit)
        if ratio > 0.6 { return 3 }
        if ratio > 0.3 { return 2 }
        return 1
    }

    // MARK: - Achievement banners

    private func enqueueAchievements(_ achievements: [Achievement]) {
        achievementQueue.append(contentsOf: achievements)
        if !bannerShowing { showNextBanner() }
    }

    private func showNextBanner() {
        guard !achievementQueue.isEmpty else { bannerShowing = false; return }
        bannerShowing = true
        showAchievementBanner(achievementQueue.removeFirst())
    }

    private func showAchievementBanner(_ ach: Achievement) {
        let w: CGFloat = min(size.width - 40, 300)
        let h: CGFloat = 54
        let card = SKShapeNode(rect: CGRect(x: -w/2, y: -h/2, width: w, height: h), cornerRadius: 14)
        card.fillColor   = UIColor(hex: "#2C2C2C").withAlphaComponent(0.92)
        card.strokeColor = .clear
        card.zPosition   = 200

        let topY  = size.height/2 + h
        let restY = size.height/2 - safeTop - h/2 - 10
        card.position = CGPoint(x: 0, y: topY)
        addChild(card)

        let cfg  = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        if let img = UIImage(systemName: ach.icon, withConfiguration: cfg)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let tex  = SKTexture(image: img)
            let icon = SKSpriteNode(texture: tex)
            icon.size     = CGSize(width: 22, height: 22)
            icon.position = CGPoint(x: -w/2 + 28, y: 0)
            card.addChild(icon)
        }

        let top = SKLabelNode(text: "Achievement Unlocked")
        top.fontName  = "AvenirNext-Medium"
        top.fontSize  = 10
        top.fontColor = UIColor(white: 1, alpha: 0.6)
        top.horizontalAlignmentMode = .left
        top.verticalAlignmentMode   = .center
        top.position = CGPoint(x: -w/2 + 50, y: 10)
        card.addChild(top)

        let bot = SKLabelNode(text: ach.title)
        bot.fontName  = "AvenirNext-Bold"
        bot.fontSize  = 14
        bot.fontColor = .white
        bot.horizontalAlignmentMode = .left
        bot.verticalAlignmentMode   = .center
        bot.position = CGPoint(x: -w/2 + 50, y: -10)
        card.addChild(bot)

        card.run(.sequence([
            .moveTo(y: restY, duration: 0.3),
            .wait(forDuration: 2.0),
            .moveTo(y: topY,  duration: 0.25),
            .removeFromParent(),
            .run { [weak self] in self?.showNextBanner() }
        ]))
    }
}

// MARK: - ArbiterDelegate

extension ArenaScene: ArbiterDelegate {

    func arbiterDidUpdate(_ arbiter: Arbiter) {
        refreshHUD()
        compass.pulseTally()
    }

    func arbiterDidResolve(_ arbiter: Arbiter, result: CascadeResult) {
        if result.depth > longestChain { longestChain = result.depth }
        runCascadeAnimation(result: result) { [weak self] in
            guard let self else { return }
            self.board.isUserInteractionEnabled = true
            self.busy = false
            self.arbiter.checkAndReshuffle()
        }
    }

    func arbiterDidEnd(_ arbiter: Arbiter, triumph: Bool) {
        board.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            triumph ? self?.showTriumph() : self?.showDefeat()
        }
    }

    func arbiterDidReshuffle(_ arbiter: Arbiter) {
        reshuffleHappened = true
        busy = true
        board.isUserInteractionEnabled = false
        board.flashDeadlock { [weak self] in
            guard let self else { return }
            self.showReshuffleHint()
            self.board.run(.sequence([
                .wait(forDuration: 0.25),
                .fadeOut(withDuration: 0.2),
                .run { [weak self] in self?.board.populate(with: arbiter.crucible) },
                .fadeIn(withDuration: 0.2),
                .run { [weak self] in
                    self?.busy = false
                    self?.board.isUserInteractionEnabled = true
                }
            ]))
        }
    }
}
