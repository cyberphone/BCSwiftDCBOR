import Foundation
import WolfBase

extension Date: CBORTaggedCodable {
    public static let cborTag: Tag = 1
    
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
    
    public init(untaggedCBOR: CBOR) throws {
        switch untaggedCBOR {
        case .unsigned(let n):
            self = Date(timeIntervalSince1970: TimeInterval(n))
        case .negative(let n):
            self = Date(timeIntervalSince1970: TimeInterval(n))
        default:
            throw CBORDecodingError.wrongType
        }
    }
}
