import Foundation

public struct Tag {
    public let value: UInt64
    public let name: String?
    
    public init(_ value: UInt64, _ name: String? = nil) {
        self.value = value
        self.name = name
    }
}

extension Tag: Hashable {
    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        lhs.value == rhs.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Tag: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(UInt64(value), nil)
    }
}

extension Tag: CustomStringConvertible {
    public var description: String {
        name ?? String(value)
    }
}
