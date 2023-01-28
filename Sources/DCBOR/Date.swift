import Foundation
import WolfBase

extension Date: CBOREncodable {
    public var cbor: CBOR {
        tagged.cbor
    }
    
    public func encodeCBOR() -> Data {
        cbor.encodeCBOR()
    }
}

extension Date {
    var tagged: Tagged {
        let timeInterval = timeIntervalSince1970
        let (integral, _) = modf(timeInterval)

        let seconds = Int64(integral)

        if seconds < 0 {
            return Tagged(1, Int(timeInterval))
        } else {
            return Tagged(1, UInt(seconds))
        }
    }
}
