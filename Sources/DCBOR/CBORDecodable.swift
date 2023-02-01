import Foundation

public protocol CBORDecodable {
    init(cbor: CBOR) throws
    init(cborData: Data) throws
}

public extension CBORDecodable {
    init(cborData: Data) throws {
        self = try Self.init(cbor: CBOR(cborData))
    }
}
