import Foundation

extension Array: CBOREncodable where Element: CBOREncodable {
    public var cbor: CBOR {
        .array(self.map { $0.cbor })
    }

    public func encodeCBOR() -> Data {
        var buf = self.count.encodeVarInt(.array)
        for element in self {
            buf += element.encodeCBOR()
        }
        return buf
    }
}
