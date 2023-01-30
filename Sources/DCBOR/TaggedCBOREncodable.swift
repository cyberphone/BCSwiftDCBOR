import Foundation

public protocol TaggedCBOREncodable: CBOREncodable {
    static var cborTag: UInt64 { get }
    var untaggedCBOR: CBOR { get }
    var taggedCBOR: CBOR { get }
}

public extension TaggedCBOREncodable {
    var taggedCBOR: CBOR {
        CBOR(Tagged(Self.cborTag, untaggedCBOR))
    }
    
    var cbor: CBOR {
        taggedCBOR
    }
    
    func encodeCBOR() -> Data {
        taggedCBOR.encodeCBOR()
    }
}
