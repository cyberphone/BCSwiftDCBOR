import Foundation

public protocol CBORTaggedEncodable: CBOREncodable {
    static var cborTag: Tag { get }
    var untaggedCBOR: CBOR { get }
    var taggedCBOR: CBOR { get }
}

public extension CBORTaggedEncodable {
    var taggedCBOR: CBOR {
        CBOR.tagged(Self.cborTag, untaggedCBOR)
    }
    
    var cbor: CBOR {
        taggedCBOR
    }
    
    var cborData: Data {
        taggedCBOR.cborData
    }
}
