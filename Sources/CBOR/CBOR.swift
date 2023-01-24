import Foundation
import OrderedCollections

public indirect enum CBOR {
    case UInt(UInt64)
    case NInt(Int64)
    case Bytes(Bytes)
    case String(String)
    case Array([CBOR])
    case Map(CBORMap)
    case Tagged(Tagged)
    case Value(Value)
}

public protocol IntoCBOR {
    func intoCBOR() -> CBOR
}

public protocol EncodeCBOR {
    func encodeCBOR() -> Data
}

extension CBOR: IntoCBOR {
    public func intoCBOR() -> CBOR {
        self
    }
}

public extension CBOR {
    func encode() -> Data {
        switch self {
        case .UInt(let x):
            return x.encodeCBOR()
        case .NInt(let x):
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

extension CBOR: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encode()
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
            return x.description
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
            return "Bytes(\(x.debugDescription))"
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
