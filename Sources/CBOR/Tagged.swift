import Foundation

public struct Tagged: Equatable {
    public let tag: UInt64
    public let item: CBOR
    
    public init<T>(tag: UInt64, item: T) where T: IntoCBOR {
        self.tag = tag
        self.item = item.intoCBOR()
    }
    
    public var name: String {
        String(tag)
    }
}

extension Tagged: EncodeCBOR {
    public func encodeCBOR() -> Data {
        tag.encodeVarInt(.Tagged) + item.encodeCBOR()
    }
}

extension Tagged: IntoCBOR {
    public func intoCBOR() -> CBOR {
        .Tagged(self)
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
