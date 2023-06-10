import Foundation

/// A type that can map between tags and their names.
public protocol TagsStoreProtocol {
    func assignedName(for tag: Tag) -> String?
    func name(for tag: Tag) -> String
    func tag(for value: UInt64) -> Tag?
    func tag(for name: String) -> Tag?
}

public func name(for tag: Tag, knownTags: TagsStoreProtocol?) -> String {
    knownTags?.name(for: tag) ?? String(tag.value)
}

/// A dictionary of mappings between tags and their names.
public struct TagsStore: TagsStoreProtocol {
    var tagsByValue: [UInt64: Tag]
    var tagsByName: [String: Tag]
    
    public init<T>(_ tags: T) where T: Sequence, T.Element == Tag {
        tagsByValue = [:]
        tagsByName = [:]
        for tag in tags {
            Self._insert(tag, tagsByValue: &tagsByValue, tagsByName: &tagsByName)
        }
    }
    
    public mutating func insert(_ tag: Tag) {
        Self._insert(tag, tagsByValue: &tagsByValue, tagsByName: &tagsByName)
    }
    
    public func assignedName(for tag: Tag) -> String? {
        self.tag(for: tag.value)?.name
    }
    
    public func name(for tag: Tag) -> String {
        assignedName(for: tag) ?? String(tag.value)
    }
    
    public func tag(for name: String) -> Tag? {
        tagsByName[name]
    }
    
    public func tag(for value: UInt64) -> Tag? {
        tagsByValue[value]
    }

    static func _insert(_ tag: Tag, tagsByValue: inout [UInt64: Tag], tagsByName: inout [String: Tag]) {
        let name = tag.name!
        precondition(!name.isEmpty)
        tagsByValue[tag.value] = tag
        tagsByName[name] = tag
    }
}

extension TagsStore: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tag...) {
        self.init(elements)
    }
}
