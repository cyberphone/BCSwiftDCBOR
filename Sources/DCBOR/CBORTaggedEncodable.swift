import Foundation

/// A type that can be encoded to CBOR with a specific tag.
///
/// Typically types that conform to this protocol will only provide the
/// `cborTag` static attribute and the `untaggedCBOR` instance attribute.
public protocol CBORTaggedEncodable: CBOREncodable {
    static var cborTag: Tag { get }
    var untaggedCBOR: CBOR { get }
    var taggedCBOR: CBOR { get }
}

public extension CBORTaggedEncodable {
    var taggedCBOR: CBOR {
        CBOR.tagged(Self.cborTag, untaggedCBOR)
    }
    
    /// This override specifies that the default CBOR encoding will be tagged.
    var cbor: CBOR {
        taggedCBOR
    }
    
    /// This override specifies that the default CBOR encoding will be tagged.
    var cborData: Data {
        taggedCBOR.cborData
    }
}
