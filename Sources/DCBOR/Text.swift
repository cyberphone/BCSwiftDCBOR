import Foundation

extension String: CBORCodable {
    public var cbor: CBOR {
        .text(self)
    }
    
    public func encodeCBOR() -> Data {
        count.encodeVarInt(.text) + self.utf8Data
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> String {
        switch cbor {
        case .text(let string):
            return string
        default:
            throw DecodeError.wrongType
        }
    }
}
