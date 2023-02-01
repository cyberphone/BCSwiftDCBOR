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

extension Array: CBORDecodable where Element: CBORDecodable {
    public static func decodeCBOR(_ cbor: CBOR) throws -> Self {
        switch cbor {
        case .array(let array):
            return try array.map { try Element.decodeCBOR($0) }
        default:
            throw CBORDecodingError.wrongType
        }
    }
}

extension Array: CBORCodable where Element: CBORCodable { }

public extension Array where Element == any CBOREncodable {
    var cbor: CBOR {
        .array(self.map { $0.cbor })
    }
    
    func encodeCBOR() -> Data {
        var buf = self.count.encodeVarInt(.array)
        for element in self {
            buf += element.encodeCBOR()
        }
        return buf
    }
}
