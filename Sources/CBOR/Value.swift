import Foundation

public struct Value: Equatable {
    let n: UInt64
    
    public init(_ n: UInt64) {
        self.n = n
    }
}

let cborFalse = Value(20).cbor
let cborTrue = Value(21).cbor
let cborFalseEncoded = cborFalse.encodeCBOR()
let cborTrueEncoded = cborTrue.encodeCBOR()

extension Bool: CBOREncodable {
    public var cbor: CBOR {
        switch self {
        case false:
            return cborFalse
        case true:
            return cborTrue
        }
    }
    
    public func encodeCBOR() -> Data {
        switch self {
        case false:
            return cborFalseEncoded
        case true:
            return cborTrueEncoded
        }
    }
}

extension Value: CBOREncodable {
    public var cbor: CBOR {
        .Value(self)
    }
    
    public func encodeCBOR() -> Data {
        n.encodeVarInt(.Value)
    }
}

extension Value: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch n {
        case 20:
            return "false"
        case 21:
            return "true"
        default:
            return String(n)
        }
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch n {
        case 20:
            return "false"
        case 21:
            return "true"
        default:
            return "simple(\(n))"
        }
    }
}
