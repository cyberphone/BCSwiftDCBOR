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

private let cborFalseEncoded = CBOR.false.cborData
private let cborTrueEncoded = CBOR.true.cborData
private let cborNullEncoded = CBOR.null.cborData

extension Bool: CBORCodable {
    public var cbor: CBOR {
        self ? CBOR.true : CBOR.false
    }
    
    public var cborData: Data {
        self ? cborTrueEncoded : cborFalseEncoded
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case CBOR.true:
            self = true
        case CBOR.false:
            self = false
        default:
            throw CBORDecodingError.wrongType
        }
    }
}

extension Value: CBORCodable {
    public var cbor: CBOR {
        .simple(self)
    }
    
    public var cborData: Data {
        rawValue.encodeVarInt(.simple)
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case .simple(let value):
            self = value
        default:
            throw CBORDecodingError.wrongType
        }
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
