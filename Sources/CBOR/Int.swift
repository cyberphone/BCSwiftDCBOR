import Foundation

extension UInt8: CBOREncodable {
    public var cbor: CBOR {
        .UInt(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt16: CBOREncodable {
    public var cbor: CBOR {
        .UInt(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt32: CBOREncodable {
    public var cbor: CBOR {
        .UInt(UInt64(self))
    }

    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt64: CBOREncodable {
    public var cbor: CBOR {
        .UInt(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension UInt: CBOREncodable {
    public var cbor: CBOR {
        .UInt(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.UInt)
    }
}

extension Int8: CBOREncodable {
    public var cbor: CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
    
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

extension Int16: CBOREncodable {
    public var cbor: CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
    
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

extension Int32: CBOREncodable {
    public var cbor: CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
    
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

extension Int64: CBOREncodable {
    public var cbor: CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }
    
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

extension Int: CBOREncodable {
    public var cbor: CBOR {
        if self < 0 {
            return .NInt(Int64(self))
        } else {
            return .UInt(UInt64(self))
        }
    }

    public func encodeCBOR() -> Data {
        Int64(self).encodeCBOR()
    }
}
