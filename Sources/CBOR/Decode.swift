import Foundation
import WolfBase

public enum CBORError: LocalizedError {
    case Underrun
    case BadHeaderValue(UInt8)
    case NonCanonicalInt
    case InvalidString
}

func parseHeader(_ header: UInt8) -> (MajorType, UInt8) {
    let majorType: MajorType
    switch header >> 5 {
    case 0:
        majorType = .UInt
    case 1:
        majorType = .NInt
    case 2:
        majorType = .Bytes
    case 3:
        majorType = .String
    case 4:
        majorType = .Array
    case 5:
        majorType = .Map
    case 6:
        majorType = .Tagged
   case 7:
        majorType = .Value
    default:
        preconditionFailure()
    }
    let headerValue = header & 31
    return (majorType, headerValue)
}

func parseHeaderVarint(_ data: ArraySlice<UInt8>) throws -> (majorType: MajorType, value: UInt64, varIntLen: Int) {
    guard !data.isEmpty else {
        throw CBORError.Underrun
    }
    
    let (majorType, headerValue) = parseHeader(data[0])
    let dataRemaining = data.count - 1
    let value: UInt64
    let varIntLen: Int
    switch headerValue {
    case 0...23:
        value = UInt64(headerValue)
        varIntLen = 1
    case 24:
        guard dataRemaining >= 1 else {
            throw CBORError.Underrun
        }
        value = UInt64(data[1])
        guard value >= 24 else {
            throw CBORError.NonCanonicalInt
        }
        varIntLen = 2
    case 25:
        guard dataRemaining >= 2 else {
            throw CBORError.Underrun
        }
        value =
            UInt64(data[1]) << 8 |
            UInt64(data[2])
        guard value > UInt8.max else {
            throw CBORError.NonCanonicalInt
        }
        varIntLen = 3
    case 26:
        guard dataRemaining >= 4 else {
            throw CBORError.Underrun
        }
        value =
            UInt64(data[1]) << 24 |
            UInt64(data[2]) << 16 |
            UInt64(data[3]) << 8 |
            UInt64(data[4])
        guard value > UInt16.max else {
            throw CBORError.NonCanonicalInt
        }
        varIntLen = 5
    case 27:
        guard dataRemaining >= 8 else {
            throw CBORError.Underrun
        }
        let valHi =
            UInt64(data[1]) << 56 |
            UInt64(data[2]) << 48 |
            UInt64(data[3]) << 40 |
            UInt64(data[4]) << 32
        
        let valLo =
            UInt64(data[5]) << 24 |
            UInt64(data[6]) << 16 |
            UInt64(data[7]) << 8 |
            UInt64(data[8])
        
        value = valHi | valLo
        
        guard value > UInt32.max else {
            throw CBORError.NonCanonicalInt
        }
        varIntLen = 9
    default:
        throw CBORError.BadHeaderValue(headerValue)
    }
    return (majorType, value, varIntLen)
}

func parseBytes(_ data: ArraySlice<UInt8>, len: Int) throws -> ArraySlice<UInt8> {
    guard !data.isEmpty else {
        throw CBORError.Underrun
    }
    return data[..<len]
}

func decodeCBORInternal(_ data: ArraySlice<UInt8>) throws -> (cbor: CBOR, len: Int) {
    guard !data.isEmpty else {
        throw CBORError.Underrun
    }
    let (majorType, value, headerVarIntLen) = try parseHeaderVarint(data)
    switch majorType {
    case .UInt:
        return (.UInt(value), headerVarIntLen)
    case .NInt:
        if value == UInt64.max {
            return (.NInt(Int64.min), headerVarIntLen)
        } else {
            return (.NInt(-Int64(value) - 1), headerVarIntLen)
        }
    case .Bytes:
        let dataLen = Int(value)
        let buf = try parseBytes(data[headerVarIntLen...], len: dataLen)
        let bytes = Bytes(buf)
        return (bytes.intoCBOR(), headerVarIntLen + dataLen)
    case .String:
        let dataLen = Int(value)
        let buf = try parseBytes(data[headerVarIntLen...], len: dataLen)
        guard let string = String(bytes: buf, encoding: .utf8) else {
            throw CBORError.InvalidString
        }
        return (string.intoCBOR(), headerVarIntLen + dataLen)
    case .Array:
        var pos = headerVarIntLen
        var items: [CBOR] = []
        for _ in 0..<value {
            let (item, itemLen) = try decodeCBORInternal(data[pos...])
            items.append(item)
            pos += itemLen
        }
        return (items.intoCBOR(), pos)
    case .Map:
        var pos = headerVarIntLen
        var map = CBORMap()
        for _ in 0..<value {
            let (key, keyLen) = try decodeCBORInternal(data[pos...])
            pos += keyLen
            let (value, valueLen) = try decodeCBORInternal(data[pos...])
            pos += valueLen
            map.insert(key, value)
        }
        return (map.intoCBOR(), pos)
    case .Tagged:
        let (item, itemLen) = try decodeCBORInternal(data[headerVarIntLen...])
        let tagged = Tagged(tag: value, item: item)
        return (tagged.intoCBOR(), headerVarIntLen + itemLen)
    case .Value:
        return (Value(value).intoCBOR(), headerVarIntLen)
    }
}

public func decodeCBOR(_ data: Data) throws -> CBOR {
    try {
        if let cbor = try data.withContiguousStorageIfAvailable ({ ptr in
            try decodeCBORInternal(ArraySlice(ptr))
        }) {
            return cbor
        } else {
            return try decodeCBORInternal(ArraySlice(data))
        }
    }().cbor
}
