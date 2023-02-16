import Foundation

func toHex(byte: UInt8) -> String {
    String(format: "%02x", byte)
}

func toHex(data: Data) -> String {
    data.reduce(into: "") {
        $0 += toHex(byte: $1)
    }
}

func toUTF8(data: Data) -> String? {
    String(data: data, encoding: .utf8)
}

extension Data {
    var hex: String {
        toHex(data: self)
    }

    var utf8: String? {
        toUTF8(data: self)
    }
}

extension Data {
    init<A>(of a: A) {
        let d = Swift.withUnsafeBytes(of: a) {
            Data($0)
        }
        self = d
    }
}

extension StringProtocol {
    func flanked(_ leading: String, _ trailing: String) -> String {
        leading + self + trailing
    }

    func flanked(_ around: String) -> String {
        around + self + around
    }
}

func toData(utf8: String) -> Data {
    utf8.data(using: .utf8)!
}

extension String {
    var utf8Data: Data {
        toData(utf8: self)
    }
}
