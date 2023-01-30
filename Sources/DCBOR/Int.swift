import Foundation
import WolfBase

func decodeFixedWidthInteger<T: FixedWidthInteger>(_ cbor: CBOR) throws -> T {
    let result: T
    switch cbor {
    case .unsigned(let n):
        guard let n = T(exactly: n) else {
            throw DecodeError.integerOutOfRange
        }
        result = n
    case .negative(let n):
        guard let n = T(exactly: n) else {
            throw DecodeError.integerOutOfRange
        }
        result = n
    default:
        throw DecodeError.wrongType
    }
    return result
}

extension UInt8: CBORCodable {
    public var cbor: CBOR {
        .unsigned(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.unsigned)
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> UInt8 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension UInt16: CBORCodable {
    public var cbor: CBOR {
        .unsigned(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.unsigned)
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> UInt16 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension UInt32: CBORCodable {
    public var cbor: CBOR {
        .unsigned(UInt64(self))
    }

    public func encodeCBOR() -> Data {
        self.encodeVarInt(.unsigned)
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> UInt32 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension UInt64: CBORCodable {
    public var cbor: CBOR {
        .unsigned(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.unsigned)
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> UInt64 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension UInt: CBORCodable {
    public var cbor: CBOR {
        .unsigned(UInt64(self))
    }
    
    public func encodeCBOR() -> Data {
        self.encodeVarInt(.unsigned)
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> UInt {
        try decodeFixedWidthInteger(cbor)
    }
}

extension Int8: CBORCodable {
    public var cbor: CBOR {
        if self < 0 {
            return .negative(Int64(self))
        } else {
            return .unsigned(UInt64(self))
        }
    }
    
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int16(self)
            let a = UInt8(-b - 1)
            return a.encodeVarInt(.negative)
        } else {
            let a = UInt8(self)
            return a.encodeVarInt(.unsigned)
        }
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Int8 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension Int16: CBORCodable {
    public var cbor: CBOR {
        if self < 0 {
            return .negative(Int64(self))
        } else {
            return .unsigned(UInt64(self))
        }
    }
    
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int32(self)
            let a = UInt16(-b - 1)
            return a.encodeVarInt(.negative)
        } else {
            let a = UInt16(self)
            return a.encodeVarInt(.unsigned)
        }
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Int16 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension Int32: CBORCodable {
    public var cbor: CBOR {
        if self < 0 {
            return .negative(Int64(self))
        } else {
            return .unsigned(UInt64(self))
        }
    }
    
    public func encodeCBOR() -> Data {
        if self < 0 {
            let b = Int64(self)
            let a = UInt32(-b - 1)
            return a.encodeVarInt(.negative)
        } else {
            let a = UInt32(self)
            return a.encodeVarInt(.unsigned)
        }
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Int32 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension Int64: CBORCodable {
    public var cbor: CBOR {
        if self < 0 {
            return .negative(Int64(self))
        } else {
            return .unsigned(UInt64(self))
        }
    }
    
    public func encodeCBOR() -> Data {
        if self < 0 {
            if self == Int64.min {
                return UInt64(Int64.max).encodeVarInt(.negative)
            } else {
                let a = UInt64(-self - 1)
                return a.encodeVarInt(.negative)
            }
        } else {
            let a = UInt32(self)
            return a.encodeVarInt(.unsigned)
        }
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Int64 {
        try decodeFixedWidthInteger(cbor)
    }
}

extension Int: CBORCodable {
    public var cbor: CBOR {
        if self < 0 {
            return .negative(Int64(self))
        } else {
            return .unsigned(UInt64(self))
        }
    }

    public func encodeCBOR() -> Data {
        Int64(self).encodeCBOR()
    }
    
    public static func decodeCBOR(_ cbor: CBOR) throws -> Int {
        try decodeFixedWidthInteger(cbor)
    }
}
