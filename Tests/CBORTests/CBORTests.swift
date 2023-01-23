import XCTest
import WolfBase
import CBOR

final class CBORTests: XCTestCase {
    func _run<T>(_ t: T, _ expectedCBOR: String, _ expectedData: String) where T: IntoCBOR {
        let cbor = t.intoCBOR()
        XCTAssertEqual(cbor†, expectedCBOR)
        let data = cbor.encode()
        XCTAssertEqual(data, expectedData.hexData!)
        let decodedCBOR = try! decodeCBOR(data)
        XCTAssertEqual(cbor, decodedCBOR)
    }
    
    func testUnsigned() throws {
        _run(UInt8(0),  "UInt(0)", "00")
        _run(UInt16(0), "UInt(0)", "00")
        _run(UInt32(0), "UInt(0)", "00")
        _run(UInt64(0), "UInt(0)", "00")
        _run(UInt(0),   "UInt(0)", "00")

        _run(UInt8(1),  "UInt(1)", "01")
        _run(UInt16(1), "UInt(1)", "01")
        _run(UInt32(1), "UInt(1)", "01")
        _run(UInt64(1), "UInt(1)", "01")
        _run(UInt(1),   "UInt(1)", "01")

        _run(UInt8(23),  "UInt(23)", "17")
        _run(UInt16(23), "UInt(23)", "17")
        _run(UInt32(23), "UInt(23)", "17")
        _run(UInt64(23), "UInt(23)", "17")
        _run(UInt(23),   "UInt(23)", "17")

        _run(UInt8(24),  "UInt(24)", "1818")
        _run(UInt16(24), "UInt(24)", "1818")
        _run(UInt32(24), "UInt(24)", "1818")
        _run(UInt64(24), "UInt(24)", "1818")
        _run(UInt(24),   "UInt(24)", "1818")

        _run(UInt8.max,         "UInt(255)", "18ff")
        _run(UInt16(UInt8.max), "UInt(255)", "18ff")
        _run(UInt32(UInt8.max), "UInt(255)", "18ff")
        _run(UInt64(UInt8.max), "UInt(255)", "18ff")
        _run(UInt(UInt8.max),   "UInt(255)", "18ff")

        _run(UInt16.max,         "UInt(65535)", "19ffff")
        _run(UInt32(UInt16.max), "UInt(65535)", "19ffff")
        _run(UInt64(UInt16.max), "UInt(65535)", "19ffff")
        _run(UInt(UInt16.max),   "UInt(65535)", "19ffff")

        _run(UInt32(65536), "UInt(65536)", "1a00010000")
        _run(UInt64(65536), "UInt(65536)", "1a00010000")
        _run(UInt(65536),   "UInt(65536)", "1a00010000")

        _run(UInt32.max,         "UInt(4294967295)", "1affffffff")
        _run(UInt64(UInt32.max), "UInt(4294967295)", "1affffffff")
        _run(UInt(UInt32.max),   "UInt(4294967295)", "1affffffff")

        _run(4294967296, "UInt(4294967296)", "1b0000000100000000")
        
        _run(UInt64.max, "UInt(18446744073709551615)", "1bffffffffffffffff")
        _run(UInt.max,   "UInt(18446744073709551615)", "1bffffffffffffffff")
    }
    
    func testSigned() {
        _run(Int8 (-1), "NInt(-1)", "20")
        _run(Int16(-1), "NInt(-1)", "20")
        _run(Int32(-1), "NInt(-1)", "20")
        _run(Int64(-1), "NInt(-1)", "20")

        _run(Int8 (-2), "NInt(-2)", "21")
        _run(Int16(-2), "NInt(-2)", "21")
        _run(Int32(-2), "NInt(-2)", "21")
        _run(Int64(-2), "NInt(-2)", "21")

        _run(Int8 (-127), "NInt(-127)", "387e")
        _run(Int16(-127), "NInt(-127)", "387e")
        _run(Int32(-127), "NInt(-127)", "387e")
        _run(Int64(-127), "NInt(-127)", "387e")

        _run(Int8 (Int8.min), "NInt(-128)", "387f")
        _run(Int16(Int8.min), "NInt(-128)", "387f")
        _run(Int32(Int8.min), "NInt(-128)", "387f")
        _run(Int64(Int8.min), "NInt(-128)", "387f")

        _run(Int8 (Int8.max), "UInt(127)", "187f")
        _run(Int16(Int8.max), "UInt(127)", "187f")
        _run(Int32(Int8.max), "UInt(127)", "187f")
        _run(Int64(Int8.max), "UInt(127)", "187f")

        _run(Int16(Int16.min), "NInt(-32768)", "397fff")
        _run(Int32(Int16.min), "NInt(-32768)", "397fff")
        _run(Int64(Int16.min), "NInt(-32768)", "397fff")

        _run(Int16(Int16.max), "UInt(32767)", "197fff")
        _run(Int32(Int16.max), "UInt(32767)", "197fff")
        _run(Int64(Int16.max), "UInt(32767)", "197fff")

        _run(Int32(Int32.min), "NInt(-2147483648)", "3a7fffffff")
        _run(Int64(Int32.min), "NInt(-2147483648)", "3a7fffffff")

        _run(Int32(Int32.max), "UInt(2147483647)", "1a7fffffff")
        _run(Int64(Int32.max), "UInt(2147483647)", "1a7fffffff")

        _run(Int64.min, "NInt(-9223372036854775808)", "3b7fffffffffffffff")

        _run(Int64.max, "UInt(9223372036854775807)", "1b7fffffffffffffff")
    }
}
