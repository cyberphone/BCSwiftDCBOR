import Foundation

extension String: CBOREncodable {
    public var cbor: CBOR {
        .String(self)
    }
    
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.String) + self.utf8Data
    }
}
