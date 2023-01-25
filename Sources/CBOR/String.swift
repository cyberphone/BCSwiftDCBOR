import Foundation

extension String: EncodeCBOR {
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.String) + self.utf8Data
    }
}

extension String: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .String(self)
    }
}
