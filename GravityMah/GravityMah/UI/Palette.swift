import UIKit
import SpriteKit

enum Palette {
    // Light theme base colors
    static let bg       = UIColor(hex: "#F2EDE4")   // warm parchment
    static let surface  = UIColor(hex: "#EAE3D8")   // slightly darker parchment
    static let accent   = UIColor(hex: "#C0392B")   // mahjong red
    static let accent2  = UIColor(hex: "#1A5276")   // mahjong blue
    static let shimmer  = UIColor(hex: "#E74C3C")
    static let text     = UIColor(hex: "#2C2C2C")
    static let subtext  = UIColor(hex: "#7F8C8D")

    // Board felt
    static let felt     = UIColor(hex: "#2E7D4F")
    static let feltEdge = UIColor(hex: "#1B5E35")

    // Suit colors
    static let wan      = UIColor(hex: "#C0392B")   // 万 red
    static let tong     = UIColor(hex: "#1A5276")   // 筒 blue
    static let tiao     = UIColor(hex: "#1E8449")   // 条 green

    static let bombTint   = UIColor(hex: "#922B21")
    static let wildTint   = UIColor(hex: "#7D3C98")
    static let anchorTint = UIColor(hex: "#5D6D7E")

    // per-cipher tile tints (unused in new design, kept for compatibility)
    static let cipherTints: [UIColor] = [
        .clear,
        UIColor(hex: "#C0392B"), UIColor(hex: "#E67E22"), UIColor(hex: "#D4AC0D"),
        UIColor(hex: "#1E8449"), UIColor(hex: "#1A5276"), UIColor(hex: "#7D3C98"),
        UIColor(hex: "#C0392B"), UIColor(hex: "#1A5276"), UIColor(hex: "#1E8449"),
    ]

    static func tint(for cipher: Int) -> UIColor {
        guard cipher >= 1, cipher <= 9 else { return .gray }
        return cipherTints[cipher]
    }

    static func rounded(_ size: CGFloat, weight: UIFont.Weight = .bold) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        guard let desc = base.fontDescriptor.withDesign(.rounded) else { return base }
        return UIFont(descriptor: desc, size: 0)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        self.init(
            red:   CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8)  & 0xFF) / 255,
            blue:  CGFloat( rgb        & 0xFF) / 255,
            alpha: 1
        )
    }

    func lighter(by amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: min(b + amount, 1), alpha: a)
    }
}

extension UIFont {
    var rounded: UIFont {
        guard let desc = fontDescriptor.withDesign(.rounded) else { return self }
        return UIFont(descriptor: desc, size: 0)
    }
}
