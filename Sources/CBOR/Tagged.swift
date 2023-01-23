import Foundation

public struct Tagged {
    public let tag: UInt64
    public let item: CBOR
    
    public init(tag: UInt64, item: CBOR) {
        self.tag = tag
        self.item = item
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

extension Tagged: CustomStringConvertible {
    public var description: String {
        "\(name)(\(item))"
    }
}
