import Foundation

extension UInt8: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt8: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .UInt(UInt64(self))
    }
}

extension UInt16: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt16: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .UInt(UInt64(self))
    }
}

extension UInt32: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt32: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .UInt(UInt64(self))
    }
}

extension UInt64: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt64: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .UInt(UInt64(self))
    }
}

extension UInt: EncodeCBOR {
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt: CBOREncodable {
    public func intoCBOR() -> CBOR {
        .UInt(UInt64(self))
    }
}

extension Int8: EncodeCBOR {
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int16(self)
            let a = UInt8(-b - 1)
            return a.encodeVarInt(.NInt)
        } else {
            let a = UInt8(self)
            return a.encodeVarInt(.UInt)
        }
    }
}

extension Int8: CBOREncodable {
    public func intoCBOR() -> CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
}

extension Int16: EncodeCBOR {
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int32(self)
            let a = UInt16(-b - 1)
            return a.encodeVarInt(.NInt)
        } else {
            let a = UInt16(self)
            return a.encodeVarInt(.UInt)
        }
    }
}

extension Int16: CBOREncodable {
    public func intoCBOR() -> CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
}

extension Int32: EncodeCBOR {
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int64(self)
            let a = UInt32(-b - 1)
            return a.encodeVarInt(.NInt)
        } else {
            let a = UInt32(self)
            return a.encodeVarInt(.UInt)
        }
    }
}

extension Int32: CBOREncodable {
    public func intoCBOR() -> CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
}

extension Int64: EncodeCBOR {
    public func encodeCBOR() -> Data {
        if self < 0 {
            if self == Int64.min {
                return UInt64(Int64.max).encodeVarInt(.NInt)
            } else {
                let a = UInt64(-self - 1)
                return a.encodeVarInt(.NInt)
            }
        } else {
            let a = UInt32(self)
            return a.encodeVarInt(.UInt)
        }
    }
}

extension Int64: CBOREncodable {
    public func intoCBOR() -> CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
}

extension Int: CBOREncodable {
    public func intoCBOR() -> CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
}

extension Int: EncodeCBOR {
    public func encodeCBOR() -> Data {
        Int64(self).encodeCBOR()
    }
}
