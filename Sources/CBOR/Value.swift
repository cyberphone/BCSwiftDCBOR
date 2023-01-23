import Foundation

public struct Value: Equatable {
    let n: UInt64
    
    public init(_ n: UInt64) {
        self.n = n
    }
}

extension Value: EncodeCBOR {
    public func encodeCBOR() -> Data {
        n.encodeVarInt(.Value)
    }
}

extension Value: IntoCBOR {
    public func intoCBOR() -> CBOR {
        .Value(self)
    }
}
