import Foundation
import OrderedCollections

/// A symbolic representation of CBOR data.
public indirect enum CBOR {
    /// Unsigned integer (major type 0).
    case UInt(UInt64)
    /// Negative integer (major type 1).
    case NInt(Int64)
    /// Byte string (major type 2).
    case Bytes(Data)
    /// UTF-8 string (major type 3).
    case String(String)
    /// Array (major type 4).
    case Array([CBOR])
    /// Map (major type 5).
    case Map(Map)
    /// Tagged value (major type 6).
    case Tagged(Tagged)
    /// Simple value (majory type 7).
    case Value(Value)
}

/// A value that can be encoded as CBOR.
///
/// ## Conforming Native Types
///
/// In addition to types defined in this package like ``Bytes``, ``Map``, ``Tagged``, ``Value``, the following
/// native types also conform to ``CBOREncodable``:
///
/// * `UInt8`
/// * `UInt16`
/// * `UInt32`
/// * `UInt64`
/// * `UInt`
/// * `Int8`
/// * `Int16`
/// * `Int32`
/// * `Int64`
/// * `Int`
/// * `Array where Element: CBOREncodable`
/// * `String`
/// * `Bool`
/// * `Data`
public protocol CBOREncodable {
    /// Returns the value in CBOR symbolic representation.
    var cbor: CBOR { get }
    /// Returns the value in CBOR binary representation.
    func encodeCBOR() -> Data
}

extension CBOR: CBOREncodable {
    public var cbor: CBOR {
        self
    }

    public func encodeCBOR() -> Data {
        switch self {
        case .UInt(let x):
            return x.encodeCBOR()
        case .NInt(let x):
            precondition(x < 0)
            return x.encodeCBOR()
        case .Bytes(let x):
            return x.encodeCBOR()
        case .String(let x):
            return x.encodeCBOR()
        case .Array(let x):
            return x.encodeCBOR()
        case .Map(let x):
            return x.encodeCBOR()
        case .Tagged(let x):
            return x.encodeCBOR()
        case .Value(let x):
            return x.encodeCBOR()
        }
    }
}

extension CBOR: Equatable {
    public static func ==(lhs: CBOR, rhs: CBOR) -> Bool {
        switch (lhs, rhs) {
        case (CBOR.UInt(let l), CBOR.UInt(let r)): return l == r
        case (CBOR.NInt(let l), CBOR.NInt(let r)): return l == r
        case (CBOR.Bytes(let l), CBOR.Bytes(let r)): return l == r
        case (CBOR.String(let l), CBOR.String(let r)): return l == r
        case (CBOR.Array(let l), CBOR.Array(let r)): return l == r
        case (CBOR.Map(let l), CBOR.Map(let r)): return l == r
        case (CBOR.Tagged(let l), CBOR.Tagged(let r)): return l == r
        case (CBOR.Value(let l), CBOR.Value(let r)): return l == r
        default: return false
        }
    }
}

extension CBOR: CustomStringConvertible {
    public var description: String {
        switch self {
        case .UInt(let x):
            return x.description
        case .NInt(let x):
            return x.description
        case .Bytes(let x):
            return x.hex.flanked("h'", "'")
        case .String(let x):
            return x.description.flanked("\"")
        case .Array(let x):
            return x.map({ $0.description }).joined(separator: ", ").flanked("[", "]")
        case .Map(let x):
            return x.description
        case .Tagged(let x):
            return x.description
        case .Value(let x):
            return x.description
        }
    }
}

extension CBOR: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .UInt(let x):
            return "UInt(\(x))"
        case .NInt(let x):
            return "NInt(\(x))"
        case .Bytes(let x):
            return "Bytes(\(x.hex))"
        case .String(let x):
            return "String(\(x.flanked("\"")))"
        case .Array(let x):
            return "Array(\(x))"
        case .Map(let x):
            return "Map(\(x.debugDescription))"
        case .Tagged(let x):
            return "Tagged(\(x.tag), \(x.item.debugDescription))"
        case .Value(let x):
            return "Value(\(x.debugDescription))"
        }
    }
}
