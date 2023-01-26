import Foundation
import WolfBase

extension Data: CBOREncodable {
    public var cbor: CBOR {
        .Bytes(self)
    }
    
    public func encodeCBOR() -> Data {
        data.count.encodeVarInt(.Bytes) + self
    }
}
