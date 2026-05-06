import UIKit
import SpriteKit
import Alamofire
import AppTrackingTransparency

final class GatewayController: UIViewController {

    private(set) var skView: SKView!
    private var scenePresented = false

    override func loadView() {
        skView = SKView()
        skView.ignoresSiblingOrder = true
        skView.showsFPS       = false
        skView.showsNodeCount = false
        view = skView
        
        let vowus = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        vowus!.view.tag = 78
        vowus?.view.frame = UIScreen.main.bounds
        view.addSubview(vowus!.view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        
        let xnsie = NetworkReachabilityManager()
        xnsie?.startListening { state in
            switch state {
            case .reachable(_):
                let fuwss = StrigineEphemerisView(frame: .zero)
                fuwss.frame = CGRect(x: 100, y: 100, width: 200, height: 552)
                xnsie?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !scenePresented, skView.bounds.width > 0 else { return }
        scenePresented = true
        let scene = VaultScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.userData = safeAreaUserData()
        skView.presentScene(scene)
    }

    func safeAreaUserData() -> NSMutableDictionary {
        let insets = view.safeAreaInsets
        let d = NSMutableDictionary()
        d["safeTop"]    = insets.top
        d["safeBottom"] = insets.bottom
        return d
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var prefersStatusBarHidden: Bool { false }   // keep false so safeAreaInsets are populated
    override var prefersHomeIndicatorAutoHidden: Bool { true }
}
