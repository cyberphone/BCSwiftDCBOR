import Foundation

/// A CBOR tag.
public struct Tag {
    /// The tag's value.
    public let value: UInt64
    /// The tag's known name, if any.
    public let name: String?
    
    /// Creates a tag with the given value, and optionally a known name.
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
