import Foundation
import WolfBase

extension Data: CBOREncodable {
    public var cbor: CBOR {
        .bytes(self)
    }
    
    public func encodeCBOR() -> Data {
        data.count.encodeVarInt(.bytes) + self
    }
}
