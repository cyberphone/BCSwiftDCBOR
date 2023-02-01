import Foundation

/// An error encountered while decoding CBOR.
public enum CBORDecodingError: LocalizedError, Equatable {
    /// Early end of data.
    case underrun

    /// Unsupported value in CBOR header.
    ///
    /// The case includes the encountered header as associated data.
    case badHeaderValue(encountered: UInt8)

    /// An integer was encoded in non-canonical form.
    case nonCanonicalInt

    /// An invalidly-encoded UTF-8 string was encountered.
    case invalidString

    /// The decoded CBOR had extra data at the end.
    ///
    /// The case includes the number of unused bytes as associated data.
    case unusedData(Int)

    /// The decoded CBOR map has keys that are not in canonical order.
    case misorderedMapKey

    /// The decoded CBOR map has a duplicate key.
    case duplicateMapKey

    /// The decoded integer could not be represented in the specified integer type.
    case integerOutOfRange

    /// The decoded value was not the expected type.
    case wrongType

    /// The decoded value did not have the expected tag.
    ///
    /// The case includes the expected tag and encountered tag as associated data.
    case wrongTag(expected: Tag, encountered: Tag)
    
    case invalidFormat
}
