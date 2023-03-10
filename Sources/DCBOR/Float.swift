import Foundation

let cborNaN = Data([0xf9, 0x7e, 0x00])

extension Double: CBORCodable {
    public var cbor: CBOR {
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cbor
        }
        if let i = UInt64(exactly: self) {
            return i.cbor
        }
        return .simple(.float(self))
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case .unsigned(let n):
            self = Double(n)
        case .negative(let n):
            self = Double(n)
        case .simple(let simple):
            guard case .float(let f) = simple else {
                throw CBORDecodingError.wrongType
            }
            self = f
        default:
            throw CBORDecodingError.wrongType
        }
    }
    
    public var cborData: Data {
        let f = Float(self)
        guard self != Double(f) else {
            return f.cborData
        }
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cborData
        }
        if let i = UInt64(exactly: self) {
            return i.cborData
        }
        guard !isNaN else {
            return cborNaN
        }
        return self.bitPattern.encodeVarInt(.simple)
    }
    
    func validateCanonical() throws {
        guard
            self != Double(Float(self)),
            Int64(exactly: self) == nil,
            !isNaN
        else {
            throw CBORDecodingError.nonCanonicalNumeric
        }
    }
}

extension Float: CBORCodable {
    public var cbor: CBOR {
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cbor
        }
        if let i = UInt64(exactly: self) {
            return i.cbor
        }
        return .simple(.float(Double(self)))
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case .unsigned(let n):
            self = Float(n)
        case .negative(let n):
            self = Float(n)
        case .simple(let simple):
            guard case .float(let f) = simple else {
                throw CBORDecodingError.wrongType
            }
            self = Float(f)
        default:
            throw CBORDecodingError.wrongType
        }
    }

    public var cborData: Data {
        let f = Float16(self)
        guard self != Float(f) else {
            return f.cborData
        }
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cborData
        }
        if let i = UInt64(exactly: self) {
            return i.cborData
        }
        guard !isNaN else {
            return cborNaN
        }
        return self.bitPattern.encodeVarInt(.simple)
    }
    
    func validateCanonical() throws {
        guard
            self != Float(Float16(self)),
            Int64(exactly: self) == nil,
            !isNaN
        else {
            throw CBORDecodingError.nonCanonicalNumeric
        }
    }
}

extension Float16: CBORCodable {
    public var cbor: CBOR {
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cbor
        }
        if let i = UInt64(exactly: self) {
            return i.cbor
        }
        return .simple(.float(Double(self)))
    }
    
    public init(cbor: CBOR) throws {
        switch cbor {
        case .unsigned(let n):
            self = Float16(n)
        case .negative(let n):
            self = Float16(n)
        case .simple(let simple):
            guard case .float(let f) = simple else {
                throw CBORDecodingError.wrongType
            }
            self = Float16(f)
        default:
            throw CBORDecodingError.wrongType
        }
    }

    public var cborData: Data {
        if
            self < 0,
            let i = Int64(exactly: self)
        {
            return i.cborData
        }
        if let i = UInt64(exactly: self) {
            return i.cborData
        }
        guard !isNaN else {
            return cborNaN
        }
        return self.bitPattern.encodeVarInt(.simple)
    }
    
    func validateCanonical() throws {
        guard
            Int64(exactly: self) == nil,
            !isNaN || self.bitPattern == 0x7e00
        else {
            throw CBORDecodingError.nonCanonicalNumeric
        }
    }
}
