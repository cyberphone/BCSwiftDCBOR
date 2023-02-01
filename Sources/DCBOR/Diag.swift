import Foundation
import WolfBase

public extension CBOR {
    /// Returns the CBOR value in CBOR diagnostic notation.
    ///
    /// - Parameters:
    ///   - annotate: If `true`, add additional notes and context.
    ///   - knownTags: If `annotate` is `true`, uses the name of these tags rather than their number.
    func diagnostic(annotate: Bool = false, knownTags: KnownTags? = nil) -> String {
        diagItem(annotate: annotate, knownTags: knownTags).format(annotate: annotate)
    }
}

extension Array where Element == String {
    func joined(itemSeparator: String = "", pairSeparator: String? = nil) -> String {
        let pairSeparator = pairSeparator ?? itemSeparator
        var result = ""
        for (index, item) in self.enumerated() {
            result += item
            if index != count - 1 {
                if index & 1 != 0 {
                    result += itemSeparator
                } else {
                    result += pairSeparator
                }
            }
        }
        return result
    }
}

enum DiagItem {
    case item(String)
    case group(begin: String, end: String, items: [DiagItem], isPairs: Bool, comment: String?)
    
    func format(level: Int = 0, separator: String = "", annotate: Bool = false) -> String {
        switch self {
        case .item(let string):
            return formatLine(level: level, string: string, separator: separator)
        case .group:
            if containsGroup || totalStringsLength > 20 || greatestStringsLength > 20 {
                return multilineComposition(level: level, separator: separator, annotate: annotate)
            } else {
                return singleLineComposition(level: level, separator: separator, annotate: annotate)
            }
        }
    }
    
    private func formatLine(level: Int, string: String, separator: String = "") -> String {
        String(repeating: " ", count: level * 3) + string + separator
    }
    
    func singleLineComposition(level: Int, separator: String, annotate: Bool) -> String {
        let string: String
        switch self {
        case .item(let s):
            string = s
        case .group(let begin, let end, let items, let isPairs, let comment):
            let components = items.map { item -> String in
                switch item {
                case .item(let string):
                    return string
                case .group:
                    return "<group>"
                }
            }
            let pairSeparator = isPairs ? ": " : ", "
            let s = components.joined(itemSeparator: ", ", pairSeparator: pairSeparator).flanked(begin, end)
            if annotate, let comment = comment {
                string = "\(s)   ; \(comment)"
            } else {
                string = s
            }
        }
        return formatLine(level: level, string: string, separator: separator)
    }
    
    func multilineComposition(level: Int, separator: String, annotate: Bool) -> String {
        switch self {
        case .item(let string):
            return string
        case .group(let begin, let end, let items, let isPairs, let comment):
            var lines: [String] = []
            var b: String
            if annotate, let comment = comment {
                b = "\(begin)   ; \(comment)"
            } else {
                b = begin
            }
            lines.append(formatLine(level: level, string: b))
            for (index, item) in items.enumerated() {
                let separator = index == items.count - 1 ? "" : (isPairs && index & 1 == 0 ? ":" : ",")
                lines.append(item.format(level: level + 1, separator: separator, annotate: annotate))
            }
            lines.append(formatLine(level: level, string: end, separator: separator))
            return lines.joined(separator: "\n")
        }
    }
    
    var totalStringsLength: Int {
        switch self {
        case .item(let string):
            return string.count
        case .group(_, _, let items, _, _):
            return items.reduce(into: 0) { result, item in
                result += item.totalStringsLength
            }
        }
    }
    
    var greatestStringsLength: Int {
        switch self {
        case .item(let string):
            return string.count
        case .group(_, _, let items, _, _):
            return items.reduce(into: 0) { result, item in
                result = max(result, item.totalStringsLength)
            }
        }
    }
    
    var isGroup: Bool {
        if case .group = self {
            return true
        } else {
            return false
        }
    }
    
    var containsGroup: Bool {
        switch self {
        case .item:
            return false
        case .group(_, _, let items, _, _):
            return items.first { $0.isGroup } != nil
        }
    }
}

extension CBOR {
    func diagItem(annotate: Bool = false, knownTags: KnownTags?) -> DiagItem {
        switch self {
        case .unsigned, .negative, .bytes, .text, .value:
            return .item(description)
        case .tagged(let tag, let item):
            let diagItem: DiagItem
            if annotate && tag == 1 {
                switch item {
                case .unsigned(let n):
                    diagItem = .item(ISO8601DateFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(n))))
                case .negative(let n):
                    diagItem = .item(ISO8601DateFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(n))))
                default:
                    diagItem = item.diagItem(annotate: annotate, knownTags: knownTags)
                }
            } else {
                diagItem = item.diagItem(annotate: annotate, knownTags: knownTags)
            }
            return .group(
                begin: String(tag.value) + "(",
                end: ")",
                items: [diagItem],
                isPairs: false,
                comment: knownTags?.assignedName(for: tag)
            )
        case .array(let a):
            return .group(
                begin: "[",
                end: "]",
                items: a.map { $0.diagItem(annotate: annotate, knownTags: knownTags) },
                isPairs: false,
                comment: nil
            )
        case .map(let m):
            return .group(
                begin: "{",
                end: "}",
                items: m.map { (key, value) in
                    [key.diagItem(annotate: annotate, knownTags: knownTags), value.diagItem(annotate: annotate, knownTags: knownTags)]
                }.flatMap { $0 },
                isPairs: true,
                comment: nil
            )
        }
    }
}
