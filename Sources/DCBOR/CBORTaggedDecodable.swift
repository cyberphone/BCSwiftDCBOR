import Foundation

/// A type that can be decoded from CBOR with a specific tag.
///
/// Typically types that conform to this protocol will provide the `cborTag`
/// static attribute and the `init(untaggedCBOR:)` constructor.
public protocol CBORTaggedDecodable: CBORDecodable {
    static var cborTag: Tag { get }
    init(untaggedCBOR: CBOR) throws
    
    // Overridable from CBORDecodable
    init(cbor: CBOR) throws
}

public extension CBORTaggedDecodable {
    /// Creates an instance of this type by decoding it from tagged CBOR.
    init(taggedCBOR: CBOR) throws {
        guard case CBOR.tagged(let tag, let item) = taggedCBOR else {
            throw CBORError.wrongType
        }
        guard tag == Self.cborTag else {
            throw CBORError.wrongTag(expected: Self.cborTag, encountered: tag)
        }
        self = try Self(untaggedCBOR: item)
    }
    
    /// Creates an instance of this type by decoding it from binary encoded tagged CBOR.
    init(taggedCBORData: Data) throws {
        self = try Self(taggedCBOR: CBOR(taggedCBORData))
    }
    
    /// Creates an instance of this type by decoding it from binary encoded untagged CBOR.
    init(untaggedCBORData: Data) throws {
        self = try Self(untaggedCBOR: CBOR(untaggedCBORData))
    }

    /// This override specifies that default CBOR encoding will be tagged.
    init(cbor: CBOR) throws {
        self = try Self(taggedCBOR: cbor)
    }
}
