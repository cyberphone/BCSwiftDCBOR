import Foundation

public struct KnownTags {
    var dict: [Tag: String]
    
    public init<T>(_ tags: T) where T: Sequence, T.Element == Tag {
        dict = [:]
        for tag in tags {
            Self._insert(tag, dict: &dict)
        }
    }
    
    public mutating func insert(_ tag: Tag) {
        Self._insert(tag, dict: &dict)
    }
    
    public func assignedName(for tag: Tag) -> String? {
        dict[tag]
    }
    
    public func name(for tag: Tag) -> String {
        assignedName(for: tag) ?? String(tag.value)
    }

    static func _insert(_ tag: Tag, dict: inout [Tag: String]) {
        precondition(!(tag.name!.isEmpty))
        dict[tag] = tag.name!
    }
    
    public static func name(for tag: Tag, knownTags: KnownTags?) -> String {
        knownTags?.name(for: tag) ?? String(tag.value)
    }
}

extension KnownTags: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tag...) {
        self.init(elements)
    }
}
