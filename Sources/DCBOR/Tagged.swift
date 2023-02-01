import Foundation

/// A CBOR tagged value.
public struct Tagged: Equatable {
    /// The tag.
    public let tag: Tag
    /// The CBOR item that was tagged.
    public let item: CBOR

    /// Creates a new tagged value.
    public init<T>(_ tag: Tag, _ item: T) where T: CBOREncodable {
        self.tag = tag
        self.item = item.cbor
    }
}

extension Tagged: CBORCodable {
    public var cbor: CBOR {
        .tagged(tag, item)
    }

    public func encodeCBOR() -> Data {
        tag.value.encodeVarInt(.tagged) + item.encodeCBOR()
    }

    public static func decodeCBOR(_ cbor: CBOR) throws -> Tagged {
        switch cbor {
        case .tagged(let tag, let item):
            return Tagged(tag, item)
        default:
            throw CBORDecodingError.wrongType
        }
    }
}

extension Tagged: CustomDebugStringConvertible {
    public var debugDescription: String {
        "tagged(tag: \(tag), item: \(item.debugDescription))"
    }
}

extension Tagged: CustomStringConvertible {
    public var description: String {
        let a = "\(tag)(\(item))"
        return a
    }
}
