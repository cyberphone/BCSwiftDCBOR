import Foundation

public protocol CBORDecodable {
    static func decodeCBOR(_ cbor: CBOR) throws -> Self
    static func decodeCBOR(_ data: Data) throws -> Self
}

public extension CBORDecodable {
    static func decodeCBOR(_ data: Data) throws -> Self {
        try decodeCBOR(DCBOR.decodeCBOR(data))
    }
}
