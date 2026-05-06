import SpriteKit

extension SKScene {
    /// Top safe-area inset passed from GatewayController via userData.
    var safeTop: CGFloat {
        (userData?["safeTop"] as? CGFloat) ?? 0
    }
    var safeBottom: CGFloat {
        (userData?["safeBottom"] as? CGFloat) ?? 0
    }

    /// Copy safe-area userData to another scene before presenting it.
    func relay(safeArea to: SKScene) {
        let d = NSMutableDictionary()
        d["safeTop"]    = safeTop
        d["safeBottom"] = safeBottom
        to.userData = d
    }
}
