import Foundation

extension Date: CBORTaggedCodable {
    public static let cborTags: [Tag] = [1]
    
    public var untaggedCBOR: CBOR {
        CBOR(timeIntervalSince1970)
    }
    
    public init(untaggedCBOR: CBOR) throws {
        self = try Date(timeIntervalSince1970: TimeInterval(cbor: untaggedCBOR))
    }
}
