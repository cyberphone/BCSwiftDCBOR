import Foundation

extension String: CBORCodable {
    public var cbor: CBOR {
        .text(self)
    }
    
    public func encodeCBOR() -> Data {
        let data = self.utf8Data
        return data.count.encodeVarInt(.text) + data
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> String {
        switch cbor {
        case .text(let string):
            return string
        default:
            throw CBORDecodingError.wrongType
        }
    }
}
