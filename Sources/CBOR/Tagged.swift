import Foundation

public struct Tagged: Equatable {
    public let tag: UInt64
    public let item: CBOR
    
    public init<T>(tag: UInt64, item: T) where T: CBOREncodable {
        self.tag = tag
        self.item = item.cbor
    }
    
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
