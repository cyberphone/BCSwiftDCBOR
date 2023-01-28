import Foundation

/// A CBOR tagged value.
public struct Tagged: Equatable {
    /// The tag integer value.
    public let tag: UInt64
    /// The CBOR item that was tagged.
    public let item: CBOR
    
    /// Creates a new tagged value.
    public init<T>(_ tag: UInt64, _ item: T) where T: CBOREncodable {
        self.tag = tag
        self.item = item.cbor
    }
}

extension Tagged: CBOREncodable {
    public var cbor: CBOR {
        .tagged(self)
    }
    
    public func encodeCBOR() -> Data {
        tag.encodeVarInt(.tagged) + item.encodeCBOR()
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
