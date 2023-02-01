import Foundation
import WolfBase

extension Data: CBORCodable {
    public var cbor: CBOR {
        .bytes(self)
    }
    
    public func encodeCBOR() -> Data {
        data.count.encodeVarInt(.bytes) + self
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Data {
        switch cbor {
        case .bytes(let data):
            return data
        default:
            throw CBORDecodingError.wrongType
        }
    }
}
