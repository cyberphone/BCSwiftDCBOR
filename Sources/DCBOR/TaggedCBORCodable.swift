import Foundation

public protocol TaggedCBORCodable: CBORCodable & TaggedCBOREncodable & TaggedCBORDecodable { }
