import Foundation

extension Array: EncodeCBOR where Element: EncodeCBOR {
    public func encodeCBOR() -> Data {
        var buf = self.count.encodeVarInt(.Array)
        for element in self {
            buf += element.encodeCBOR()
        }
        return buf
    }
}

extension Array: CBOREncodable where Element: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .Array(self.map { $0.intoCBOR() })
    }
}
