import Foundation

public protocol TaggedCBORDecodable: CBORDecodable {
    static var cborTag: UInt64 { get }
    static func decodeUntaggedCBOR(_ cbor: CBOR) throws -> Self
}

public extension TaggedCBORDecodable {
    static func decodeTaggedCBOR(_ cbor: CBOR) throws -> Self {
        let tagged = try Tagged.decodeCBOR(cbor)
        guard tagged.tag == cborTag else {
            throw DecodeError.wrongTag(expected: cborTag, encountered: tagged.tag)
        }
        return try Self.decodeUntaggedCBOR(tagged.item)
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
