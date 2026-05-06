import Foundation

enum ShardVariant: Equatable {
    case numeral(Int)
    case bomb
    case wild
    case anchor(Int)   // immovable tile

    var cipher: Int? {
        switch self {
        case .numeral(let n), .anchor(let n): return n
        default: return nil
        }
    }

    var isMovable: Bool {
        if case .anchor = self { return false }
        return true
    }

    // nil = cannot participate in matches; -1 = wild (matches any)
    var matchValue: Int? {
        switch self {
        case .numeral(let n): return n
        case .wild:           return -1
        default:              return nil
        }
    }
}

struct Shard: Identifiable {
    let id: UUID
    var variant: ShardVariant

    init(_ variant: ShardVariant) {
        self.id      = UUID()
        self.variant = variant
    }

    static func numeral(_ n: Int) -> Shard { Shard(.numeral(n)) }
    static func bomb()            -> Shard { Shard(.bomb) }
    static func wild()            -> Shard { Shard(.wild) }
    static func anchor(_ n: Int)  -> Shard { Shard(.anchor(n)) }
}
