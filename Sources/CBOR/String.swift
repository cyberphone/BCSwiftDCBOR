import Foundation

extension String: EncodeCBOR {
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.String) + self.utf8Data
    }
}

extension String: IntoCBOR {
    public func intoCBOR() -> CBOR {
        .String(self)
    }
}
