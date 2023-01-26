import Foundation
import WolfBase

/// A CBOR byte string.
public struct Bytes: Equatable {
    /// The wrapped data.
    public let data: Data
    
    /// Creates a new CBOR byte string from the provided data.
    public init(_ data: Data) {
        self.data = data
    }
    
    /// Creates a new CBOR byte string from the provided data.
    public init(_ data: ArraySlice<UInt8>) {
        self.init(Data(data))
    }
    
    /// Creates a new CBOR byte string from the provided hexadecimal string.
    public init?(hex: String) {
        guard let data = Data(hex: hex) else {
            return nil
        }
        self.data = data
    }
}

extension Bytes: CBOREncodable {
    public var cbor: CBOR {
        .Bytes(self)
    }
    
    public func encodeCBOR() -> Data {
        data.count.encodeVarInt(.Bytes) + data
    }
}

extension Bytes: CustomStringConvertible {
    public var description: String {
        data.hex.flanked("h'", "'")
    }
}

extension Bytes: CustomDebugStringConvertible {
    public var debugDescription: String {
        data.hex
    }
}
