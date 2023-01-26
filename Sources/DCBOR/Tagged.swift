import Foundation

/// A CBOR tagged value.
public struct Tagged: Equatable {
    /// The tag integer value.
    public let tag: UInt64
    /// The CBOR item that was tagged.
    public let item: CBOR
    
    /// Creates a new tagged value.
    public init<T>(tag: UInt64, item: T) where T: CBOREncodable {
        self.tag = tag
        self.item = item.cbor
    }
    
    /// The known name of the tag, if it has been assigned one.
    public var name: String {
        String(tag)
    }
}

extension Tagged: CBOREncodable {
    public var cbor: CBOR {
        .Tagged(self)
    }
    
    public func encodeCBOR() -> Data {
        tag.encodeVarInt(.Tagged) + item.encodeCBOR()
    }
}

extension Tagged: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Tagged(tag: \(name), item: \(item.debugDescription))"
    }
}

extension Tagged: CustomStringConvertible {
    public var description: String {
        let a = "\(name)(\(item))"
        return a
    }
}
