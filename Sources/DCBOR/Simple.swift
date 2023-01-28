import Foundation

/// A CBOR simple value.
public struct Value: Equatable {
    /// The raw value.
    public let rawValue: UInt64
    
    /// Creates a new CBOR “simple” value.
    public init(_ rawValue: UInt64) {
        self.rawValue = rawValue
    }
    
    /// Returns the known name of the value, if it has been assigned one.
    var name: String {
        debugDescription
    }
}

private let cborFalseEncoded = CBOR.false.encodeCBOR()
private let cborTrueEncoded = CBOR.true.encodeCBOR()
private let cborNullEncoded = CBOR.null.encodeCBOR()

extension Bool: CBOREncodable {
    public var cbor: CBOR {
        self ? CBOR.true : CBOR.false
    }
    
    public func encodeCBOR() -> Data {
        self ? cborTrueEncoded : cborFalseEncoded
    }
}

extension Value: CBOREncodable {
    public var cbor: CBOR {
        .value(self)
    }
    
    public func encodeCBOR() -> Data {
        rawValue.encodeVarInt(.simple)
    }
}

extension Value: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch rawValue {
        case 20:
            return "false"
        case 21:
            return "true"
        case 22:
            return "null"
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
        case 22:
            return "null"
        default:
            return "simple(\(rawValue))"
        }
    }
}
