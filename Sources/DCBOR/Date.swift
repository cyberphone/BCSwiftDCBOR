import Foundation
import WolfBase

extension Date: TaggedCBORCodable {
    public static let cborTag: UInt64 = 1
    
    public var untaggedCBOR: CBOR {
        let timeInterval = timeIntervalSince1970
        let (integral, _) = modf(timeInterval)

        let seconds = Int64(integral)

        if seconds < 0 {
            return CBOR(Int(timeInterval))
        } else {
            return CBOR(UInt(seconds))
        }
    }
    
    public static func decodeUntaggedCBOR(_ cbor: CBOR) throws -> Date {
        switch cbor {
        case .unsigned(let n):
            return Date(timeIntervalSince1970: TimeInterval(n))
        case .negative(let n):
            return Date(timeIntervalSince1970: TimeInterval(n))
        default:
            throw DecodeError.wrongType
        }
    }
}
