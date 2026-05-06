import Foundation

enum GameFlux {
    case idle
    case swapping
    case resolving
    case triumph
    case defeat
}

protocol ArbiterDelegate: AnyObject {
    func arbiterDidUpdate(_ arbiter: Arbiter)
    func arbiterDidResolve(_ arbiter: Arbiter, result: CascadeResult)
    func arbiterDidEnd(_ arbiter: Arbiter, triumph: Bool)
    func arbiterDidReshuffle(_ arbiter: Arbiter)
}

final class Arbiter {
    var crucible: Crucible
    var tally: Int = 0
    var stepsLeft: Int
    var flux: GameFlux = .idle
    var stratum: Codex.Stratum
    var accordsCleared: Int = 0
    var longestChain: Int = 0
    var bombsTriggered: Int = 0

    weak var delegate: ArbiterDelegate?

    init(stratum: Codex.Stratum) {
        self.stratum   = stratum
        self.stepsLeft = stratum.stepLimit
        self.crucible  = Codex.conjure(stratum: stratum)
    }

    @discardableResult
    func attempt(swap a: (Int, Int), and b: (Int, Int)) -> Bool {
        guard flux == .idle else { return false }
        guard crucible.inBounds(a.0, a.1), crucible.inBounds(b.0, b.1) else { return false }
        guard let sa = crucible[a.0, a.1], sa.variant.isMovable else { return false }
        guard let sb = crucible[b.0, b.1], sb.variant.isMovable else { return false }
        guard abs(a.0 - b.0) + abs(a.1 - b.1) == 1 else { return false }

        flux = .swapping
        crucible.swapShards(at: a, and: b)

        let result = Cascade.resolve(in: &crucible)
        guard !result.waves.isEmpty else {
            crucible.swapShards(at: a, and: b)
            flux = .idle
            return false
        }

        stepsLeft -= 1
        flux = .resolving
        accordsCleared += result.waves.flatMap { $0.accords }.count
        tally += result.tally
        bombsTriggered += result.bombsTriggered
        if result.depth > longestChain { longestChain = result.depth }

        delegate?.arbiterDidResolve(self, result: result)
        delegate?.arbiterDidUpdate(self)

        flux = .idle
        scrutinize()
        return true
    }

    func checkAndReshuffle() {
        guard flux == .idle else { return }
        guard !Confluence.hasMoves(in: crucible) else { return }
        var attempts = 0
        repeat {
            crucible.shuffle()
            attempts += 1
        } while !Confluence.hasMoves(in: crucible) && attempts < 30
        delegate?.arbiterDidReshuffle(self)
    }

    private func scrutinize() {
        if stratum.objective.isMet(by: self) {
            flux = .triumph
            delegate?.arbiterDidEnd(self, triumph: true)
        } else if stepsLeft <= 0 {
            flux = .defeat
            delegate?.arbiterDidEnd(self, triumph: false)
        }
    }
}
