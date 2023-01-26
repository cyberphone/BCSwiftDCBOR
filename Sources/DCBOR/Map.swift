import Foundation
import SortedCollections

/// A CBOR map.
///
/// Keys are kept sorted by encoded CBOR form in ascending lexicographic order.
public struct Map: Equatable {
    var dict: SortedDictionary<Key, Value>
    
    /// Creates a new empty CBOR map.
    public init() {
        self.dict = .init()
    }
    
    /// Inserts a key-value pair into the map.
    public mutating func insert<K, V>(_ key: K, _ value: V) where K: CBOREncodable, V: CBOREncodable {
        dict[Key(key.encodeCBOR())] = Value(key: key.cbor, value: value.cbor)
    }
    
    mutating func insertNext<K, V>(_ key: K, _ value: V) -> Bool where K: CBOREncodable, V: CBOREncodable {
        guard let lastEntry = dict.last else {
            self.insert(key, value)
            return true
        }
        let newKey = Key(key.encodeCBOR())
        let entryKey = lastEntry.key
        guard entryKey < newKey else {
            return false
        }
        self.dict[newKey] = Value(key: key.cbor, value: value.cbor)
        return true
    }

    struct Value: Equatable {
        let key: CBOR
        let value: CBOR
    }

    struct Key: Comparable {
        let keyData: Data
        
        init(_ keyData: Data) {
            self.keyData = keyData
        }
        
        static func < (lhs: Key, rhs: Key) -> Bool {
            lhs.keyData.lexicographicallyPrecedes(rhs.keyData)
        }
    }
}

extension Map.Key: CustomDebugStringConvertible {
    var debugDescription: String {
        "0x" + keyData.hex
    }
}

extension Map: CBOREncodable {
    public var cbor: CBOR {
        .Map(self)
    }
    
    public func encodeCBOR() -> Data {
        let pairs = self.dict.map { (key: Key, value: Value) in
            (key, value.value.encodeCBOR())
        }
        var buf = pairs.count.encodeVarInt(.Map)
        for pair in pairs {
            buf += pair.0.keyData
            buf += pair.1
        }
        return buf
    }
}

extension Map: CustomDebugStringConvertible {
    public var debugDescription: String {
        dict.map { (k, v) in
            "\(k.debugDescription): (\(v.key.debugDescription), \(v.value.debugDescription))"
        }.joined(separator: ", ")
            .flanked("{", "}")
    }
}

extension Map: CustomStringConvertible {
    public var description: String {
        dict.map { (k, v) in
            "\(v.key): \(v.value)"
        }.joined(separator: ", ")
            .flanked("{", "}")
    }
}
