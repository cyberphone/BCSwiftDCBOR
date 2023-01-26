import Foundation

extension Array: CBOREncodable where Element: CBOREncodable {
    public var cbor: CBOR {
        .Array(self.map { $0.cbor })
    }

    public func encodeCBOR() -> Data {
        var buf = self.count.encodeVarInt(.Array)
        for element in self {
            buf += element.encodeCBOR()
        }
        return buf
    }
}
