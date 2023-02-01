import Foundation

public protocol CBORTaggedDecodable: CBORDecodable {
    static var cborTag: Tag { get }
    static func decodeUntaggedCBOR(_ cbor: CBOR) throws -> Self
}

public extension CBORTaggedDecodable {
    static func decodeTaggedCBOR(_ cbor: CBOR) throws -> Self {
        guard case CBOR.tagged(let tag, let item) = cbor else {
            throw CBORDecodingError.wrongType
        }
        guard tag == cborTag else {
            throw CBORDecodingError.wrongTag(expected: cborTag, encountered: tag)
        }
        return try Self.decodeUntaggedCBOR(item)
    }
    
    static func decodeTaggedCBOR(_ data: Data) throws -> Self {
        try decodeTaggedCBOR(DCBOR.decodeCBOR(data))
    }
    
    static func decodeUntaggedCBOR(_ data: Data) throws -> Self {
        try decodeUntaggedCBOR(DCBOR.decodeCBOR(data))
    }

    static func decodeCBOR(_ cbor: CBOR) throws -> Self {
        try decodeTaggedCBOR(cbor)
    }
}
