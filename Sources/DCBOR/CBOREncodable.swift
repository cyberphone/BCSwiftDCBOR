import Foundation

/// A value that can be encoded as CBOR.
///
/// ## Conforming Native Types
///
/// In addition to types defined in this package like ``Map``, ``Tagged``, and ``Value``, the following
/// native types also conform to ``CBOREncodable``:
///
/// * `Array where Element: CBOREncodable`
/// * `Bool`
/// * `Data`
/// * `Date`
/// * `Int`
/// * `Int8`
/// * `Int16`
/// * `Int32`
/// * `Int64`
/// * `String`
/// * `UInt`
/// * `UInt8`
/// * `UInt16`
/// * `UInt32`
/// * `UInt64`
public protocol CBOREncodable {
    /// Returns the value in CBOR symbolic representation.
    var cbor: CBOR { get }

    /// Returns the value in CBOR binary representation.
    func encodeCBOR() -> Data
}

public extension CBOREncodable {
    func encodeCBOR() -> Data {
        cbor.encodeCBOR()
    }
}
