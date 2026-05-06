import UIKit
import WebKit
import AdjustSdk

private var Knxudye = [String]()
//internal var HuntOrderKrajs = [String()]

//rechargeClick,amount,recharge,jsBridge,withdrawOrderSuccess,params,firstrecharge,firstCharge,charge,currency,addToCart,openWindow,deposit

let Brie = Knxudye[0]              //jsBridge
let amt = Knxudye[1]     //amount
let ren = Knxudye[2]      //currency
let OpWin = Knxudye[3]      //openWindow

//let diaChon = husnOjauehs[0]      //rechargeClick
//let amt = husnOjauehs[1]     //amount
//let chozh = husnOjauehs[2]      //recharge
//let Brie = husnOjauehs[3]              //jsBridge
//let hdrawo = husnOjauehs[4]   //withdrawOrderSuccess
//let rams = husnOjauehs[5]      //params
//let diyicicho = husnOjauehs[6]      //firstrecharge
//let diyichCha = husnOjauehs[7]    //firstCharge
//let geicho = husnOjauehs[8]         //charge
//let ren = husnOjauehs[9]      //currency
//let aTc = husnOjauehs[10]  //addToCart
//let OpWin = husnOjauehs[11]      //openWindow
//let deop = husnOjauehs[12]       //deposit

extension FiutctDsioViewControler: AdjustDelegate {
    public func adjustEventTrackingSucceeded(_ eventSuccessResponse: ADJEventSuccess?) {
        print(eventSuccessResponse as Any)
    }

    public func adjustEventTrackingFailed(_ eventFailureResponse: ADJEventFailure?) {
        print(eventFailureResponse as Any)
    }
}

internal class FiutctDsioViewControler: UIViewController,WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    var iuehs: Loamzese?
    var locone: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if iuehs!.cnoauej != nil {
            view.backgroundColor = UIColor.init(hexString: iuehs!.cnoauej!)
        }
        
        let aaq = ADJConfig(appToken: iuehs!.ckoiem!, environment: ADJEnvironmentProduction)
        aaq?.delegate = self
        Adjust.initSdk(aaq)
        
        Knxudye = iuehs!.kdoins!.components(separatedBy: ",")
//        HuntOrderKrajs = [aTc,diaChon, diyicicho, hdrawo, geicho, chozh, diyichCha, deop]
        let usrScp = WKUserScript(source: iuehs!.dgsyes!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: Brie)
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        locone = WKWebView(frame: .zero, configuration: cofg)
        locone!.allowsBackForwardNavigationGestures = true
        locone?.uiDelegate = self
        locone?.navigationDelegate = self
        view.addSubview(locone!)
        locone?.load(URLRequest(url:URL(string: iuehs!.ndikco!)!))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = ws.statusBarManager {
            
            let statusBarHeight = iuehs!.mcouen!.contains("V") ? statusBarManager.statusBarFrame.height : 0
            let bottomHeight = iuehs!.mcouen!.contains("I") ? view.safeAreaInsets.bottom : 0
            locone?.frame = CGRectMake(0, statusBarHeight, view.bounds.width, view.bounds.height - statusBarHeight - bottomHeight)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
            UIApplication.shared.open(ul!)
//            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == Brie {
            let dic = message.body as! [String : String]
  
            CansjYusus(dic, iuehs!.hcunse!)
        }
    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}


//internal class EachCompareNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isNavigationBarHidden = true
//    }
//    
//    override var shouldAutorotate: Bool {
//        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
//    }
//}
