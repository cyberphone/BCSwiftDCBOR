import Foundation

enum MajorType: Int {
    case UInt
    case NInt
    case Bytes
    case String
    case Array
    case Map
    case Tagged
    case Value
}

func typeBits(_ t: MajorType) -> UInt8 {
    UInt8(t.rawValue << 5)
}

protocol EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data
}

extension UInt8: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        if self <= 23 {
            return Data([self | typeBits(majorType)])
        } else {
            return Data([
                0x18 | typeBits(majorType),
                self
            ])
        }
    }
}

extension UInt16: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        if self <= UInt8.max {
            return UInt8(self).encodeVarInt(majorType)
        } else {
            return Data([
                0x19 | typeBits(majorType),
                UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self)
            ])
        }
    }
}

extension UInt32: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        if self <= UInt16.max {
            return UInt16(self).encodeVarInt(majorType)
        } else {
            return Data([
                0x1a | typeBits(majorType),
                UInt8(truncatingIfNeeded: self >> 24), UInt8(truncatingIfNeeded: self >> 16),
                UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self)
            ])
        }
    }
}

extension UInt64: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        if self <= UInt32.max {
            return UInt32(self).encodeVarInt(majorType)
        } else {
            return Data([
                0x1b | typeBits(majorType),
                UInt8(truncatingIfNeeded: self >> 56), UInt8(truncatingIfNeeded: self >> 48),
                UInt8(truncatingIfNeeded: self >> 40), UInt8(truncatingIfNeeded: self >> 32),
                UInt8(truncatingIfNeeded: self >> 24), UInt8(truncatingIfNeeded: self >> 16),
                UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self)
            ])
        }
    }
}

extension UInt: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        UInt64(self).encodeVarInt(majorType)
    }
}


extension Int: EncodeVarInt {
    func encodeVarInt(_ majorType: MajorType) -> Data {
        UInt64(self).encodeVarInt(majorType)
    }
}
