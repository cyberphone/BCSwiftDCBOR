import Foundation

extension String: CBORCodable {
    public var cbor: CBOR {
        .text(self)
    }
    
    public var cborData: Data {
        let data = self.utf8Data
        return data.count.encodeVarInt(.text) + data
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case .text(let string):
            self = string
        default:
            throw CBORError.wrongType
        }
    }
}
