import Foundation

extension String: CBOREncodable {
    public var cbor: CBOR {
        .text(self)
    }
    
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.text) + self.utf8Data
    }
}
