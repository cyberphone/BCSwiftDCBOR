import Foundation

public struct Value: Equatable {
    let n: UInt64
    
    public init(_ n: UInt64) {
        self.n = n
    }
}

let cborFalse = Value(20).intoCBOR()
let cborTrue = Value(21).intoCBOR()
let cborFalseEncoded = cborFalse.encode()
let cborTrueEncoded = cborTrue.encode()

extension Bool: EncodeCBOR {
    public func encodeCBOR() -> Data {
        switch self {
        case false:
            return cborFalseEncoded
        case true:
            return cborTrueEncoded
        }
    }
}

extension Bool: CBOREncodable {
    public func intoCBOR() -> CBOR {
        switch self {
        case false:
            return cborFalse
        case true:
            return cborTrue
        }
    }
}

extension Value: EncodeCBOR {
    public func encodeCBOR() -> Data {
        n.encodeVarInt(.Value)
    }
}

extension Value: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .Value(self)
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
