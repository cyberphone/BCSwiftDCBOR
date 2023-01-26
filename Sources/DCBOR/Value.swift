import Foundation

/// A CBOR simple value.
public struct Value: Equatable {
    /// The raw value.
    let rawValue: UInt64
    
    /// Creates a new CBOR “simple” value.
    public init(_ n: UInt64) {
        self.rawValue = n
    }
    
    /// Returns the known name of the value, if it has been assigned one.
    var name: String {
        debugDescription
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
        rawValue.encodeVarInt(.Value)
    }
}

extension Value: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch rawValue {
        case 20:
            return "false"
        case 21:
            return "true"
        default:
            return String(rawValue)
        }
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch rawValue {
        case 20:
            return "false"
        case 21:
            return "true"
        default:
            return "simple(\(rawValue))"
        }
    }
}
