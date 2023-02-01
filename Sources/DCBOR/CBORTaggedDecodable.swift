import Foundation

public protocol CBORTaggedDecodable: CBORDecodable {
    static var cborTag: Tag { get }
    init(untaggedCBOR: CBOR) throws
}

public extension CBORTaggedDecodable {
    init(taggedCBOR: CBOR) throws {
        guard case CBOR.tagged(let tag, let item) = taggedCBOR else {
            throw CBORDecodingError.wrongType
        }
        guard tag == Self.cborTag else {
            throw CBORDecodingError.wrongTag(expected: Self.cborTag, encountered: tag)
        }
        self = try Self(untaggedCBOR: item)
    }
    
    init(taggedCBORData: Data) throws {
        self = try Self(taggedCBOR: CBOR(taggedCBORData))
    }
    
    init(untaggedCBORData: Data) throws {
        self = try Self(untaggedCBOR: CBOR(untaggedCBORData))
    }

    init(cbor: CBOR) throws {
        self = try Self(taggedCBOR: cbor)
    }
}
