import Foundation
import WolfBase

/// Decode CBOR binary representation to symbolic representation.
///
/// Throws an error if the data is not well-formed deterministic CBOR.
public func decodeCBOR(_ data: Data) throws -> CBOR {
    let (cbor, len) = try decodeCBORInternal(ArraySlice(data))
    let remaining = data.count - len
    guard remaining == 0 else {
        throw DecodeError.UnusedData(remaining)
    }
    return cbor
}

/// An error encountered while decoding CBOR.
public enum DecodeError: LocalizedError, Equatable {
    /// Early end of data.
    case Underrun
    /// Unsupported value in CBOR header.
    case BadHeaderValue(UInt8)
    /// An integer was encoded in non-canonical form.
    case NonCanonicalInt
    /// An invalidly-encoded UTF-8 string was encountered.
    case InvalidString
    /// The decoded CBOR had extra data at the end.
    case UnusedData(Int)
    /// The decoded CBOR map has keys that are not in canonical order.
    case MisorderedMapKey
}

extension ArraySlice where Element == UInt8 {
    func at(_ index: Int) -> UInt8 {
        self[startIndex + index]
    }
    
    func from(_ index: Int) -> ArraySlice<UInt8> {
        self[(startIndex + index)...]
    }
    
    func range(_ range: Range<Int>) -> ArraySlice<UInt8> {
        self[(startIndex + range.lowerBound)..<(startIndex + range.upperBound)]
    }
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
        throw DecodeError.Underrun
    }
    
    let (majorType, headerValue) = parseHeader(data.at(0))
    let dataRemaining = data.count - 1
    let value: UInt64
    let varIntLen: Int
    switch headerValue {
    case 0...23:
        value = UInt64(headerValue)
        varIntLen = 1
    case 24:
        guard dataRemaining >= 1 else {
            throw DecodeError.Underrun
        }
        value = UInt64(data.at(1))
        guard value >= 24 else {
            throw DecodeError.NonCanonicalInt
        }
        varIntLen = 2
    case 25:
        guard dataRemaining >= 2 else {
            throw DecodeError.Underrun
        }
        value =
            UInt64(data.at(1)) << 8 |
            UInt64(data.at(2))
        guard value > UInt8.max else {
            throw DecodeError.NonCanonicalInt
        }
        varIntLen = 3
    case 26:
        guard dataRemaining >= 4 else {
            throw DecodeError.Underrun
        }
        value =
            UInt64(data.at(1)) << 24 |
            UInt64(data.at(2)) << 16 |
            UInt64(data.at(3)) << 8 |
            UInt64(data.at(4))
        guard value > UInt16.max else {
            throw DecodeError.NonCanonicalInt
        }
        varIntLen = 5
    case 27:
        guard dataRemaining >= 8 else {
            throw DecodeError.Underrun
        }
        let valHi =
            UInt64(data.at(1)) << 56 |
            UInt64(data.at(2)) << 48 |
            UInt64(data.at(3)) << 40 |
            UInt64(data.at(4)) << 32
        
        let valLo =
            UInt64(data.at(5)) << 24 |
            UInt64(data.at(6)) << 16 |
            UInt64(data.at(7)) << 8 |
            UInt64(data.at(8))
        
        value = valHi | valLo
        
        guard value > UInt32.max else {
            throw DecodeError.NonCanonicalInt
        }
        varIntLen = 9
    default:
        throw DecodeError.BadHeaderValue(headerValue)
    }
    return (majorType, value, varIntLen)
}

func parseBytes(_ data: ArraySlice<UInt8>, len: Int) throws -> ArraySlice<UInt8> {
    guard !data.isEmpty else {
        throw DecodeError.Underrun
    }
    return data.range(0..<len)
}

func decodeCBORInternal(_ data: ArraySlice<UInt8>) throws -> (cbor: CBOR, len: Int) {
    guard !data.isEmpty else {
        throw DecodeError.Underrun
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
        let buf = try parseBytes(data.from(headerVarIntLen), len: dataLen)
        let bytes = Bytes(buf)
        return (bytes.cbor, headerVarIntLen + dataLen)
    case .String:
        let dataLen = Int(value)
        let buf = try parseBytes(data.from(headerVarIntLen), len: dataLen)
        guard let string = String(bytes: buf, encoding: .utf8) else {
            throw DecodeError.InvalidString
        }
        return (string.cbor, headerVarIntLen + dataLen)
    case .Array:
        var pos = headerVarIntLen
        var items: [CBOR] = []
        for _ in 0..<value {
            let (item, itemLen) = try decodeCBORInternal(data.from(pos))
            items.append(item)
            pos += itemLen
        }
        return (items.cbor, pos)
    case .Map:
        var pos = headerVarIntLen
        var map = Map()
        for _ in 0..<value {
            let (key, keyLen) = try decodeCBORInternal(data.from(pos))
            pos += keyLen
            let (value, valueLen) = try decodeCBORInternal(data.from(pos))
            pos += valueLen
            guard map.insertNext(key, value) else {
                throw DecodeError.MisorderedMapKey
            }
        }
        return (map.cbor, pos)
    case .Tagged:
        let (item, itemLen) = try decodeCBORInternal(data.from(headerVarIntLen))
        let tagged = Tagged(tag: value, item: item)
        return (tagged.cbor, headerVarIntLen + itemLen)
    case .Value:
        return (Value(value).cbor, headerVarIntLen)
    }
}
