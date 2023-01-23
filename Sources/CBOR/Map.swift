import Foundation
import OrderedCollections

struct CBORPair: Equatable {
    let key: CBOR
    let value: CBOR
}

public struct CBORMap: Equatable {
    var dict: OrderedDictionary<Data, CBORPair>
    
    public init() {
        self.dict = .init()
    }
    
    public mutating func insert(_ key: CBOR, _ value: CBOR) {
        dict[key.encodeCBOR()] = CBORPair(key: key, value: value)
    }
}

extension CBORMap: EncodeCBOR {
    public func encodeCBOR() -> Data {
        let pairs = self.dict.map { (key: Data, value: CBORPair) in
            (key, value.value.encodeCBOR())
        }
        var buf = pairs.count.encodeVarInt(.Map)
        for pair in pairs {
            buf += pair.0
            buf += pair.1
        }
        return buf
    }
}

extension CBORMap: IntoCBOR {
    public func intoCBOR() -> CBOR {
        .Map(self)
    }
}
