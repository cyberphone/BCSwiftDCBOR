import Foundation

extension String: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .String(self)
    }
    
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.String) + self.utf8Data
    }
}
