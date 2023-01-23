import Foundation
import WolfBase

public struct Bytes: Equatable {
    public let data: Data
    
    public init(_ data: Data) {
        self.data = data
    }
    
    public init(_ data: ArraySlice<UInt8>) {
        self.init(Data(data))
    }
    
    public init?(hex: String) {
        guard let data = Data(hex: hex) else {
            return nil
        }
        self.data = data
    }
}

extension Bytes: EncodeCBOR {
    public func encodeCBOR() -> Data {
        data.count.encodeVarInt(.Bytes) + data
    }
}

extension Bytes: IntoCBOR {
    public func intoCBOR() -> CBOR {
        .Bytes(self)
    }
}

extension Bytes: CustomStringConvertible {
    public var description: String {
        data.hex.flanked("h'", "'")
    }
}
