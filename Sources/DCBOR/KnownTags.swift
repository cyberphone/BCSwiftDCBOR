import Foundation

/// A type that can map between tags and their names.
public protocol KnownTags {
    func assignedName(for tag: Tag) -> String?
    func name(for tag: Tag) -> String
    func tag(for name: String) -> Tag?
}

public func name(for tag: Tag, knownTags: KnownTags?) -> String {
    knownTags?.name(for: tag) ?? String(tag.value)
}

/// A dictionary of mappings between tags and their names.
public struct KnownTagsDict: KnownTags {
    var namesByTag: [Tag: String]
    var tagsByName: [String: Tag]
    
    public init<T>(_ tags: T) where T: Sequence, T.Element == Tag {
        namesByTag = [:]
        tagsByName = [:]
        for tag in tags {
            Self._insert(tag, namesByTag: &namesByTag, tagsByName: &tagsByName)
        }
    }
    
    public mutating func insert(_ tag: Tag) {
        Self._insert(tag, namesByTag: &namesByTag, tagsByName: &tagsByName)
    }
    
    public func assignedName(for tag: Tag) -> String? {
        namesByTag[tag]
    }
    
    public func name(for tag: Tag) -> String {
        assignedName(for: tag) ?? String(tag.value)
    }
    
    public func tag(for name: String) -> Tag? {
        tagsByName[name]
    }

    static func _insert(_ tag: Tag, namesByTag: inout [Tag: String], tagsByName: inout [String: Tag]) {
        let name = tag.name!
        precondition(!name.isEmpty)
        namesByTag[tag] = name
        tagsByName[name] = tag
    }
}

extension KnownTagsDict: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tag...) {
        self.init(elements)
    }
}
