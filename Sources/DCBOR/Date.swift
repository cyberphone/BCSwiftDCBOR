import Foundation

extension Date: CBORTaggedCodable {
    // See: https://www.iana.org/assignments/cbor-tags/cbor-tags.xhtml
    public static let cborTags: [Tag] = [1, 100]
    
    public var untaggedCBOR: CBOR {
        // AR: Ugly fix
        if Int64(exactly: timeIntervalSince1970) != nil {
            return CBOR(Int64(timeIntervalSince1970))
        }
        return CBOR(timeIntervalSince1970)
    }
    
    public init(untaggedCBOR: CBOR) throws {
        self = try Date(timeIntervalSince1970: TimeInterval(cbor: untaggedCBOR))
    }
}
