import XCTest
import WolfBase
import DCBOR

final class DCBORTests: XCTestCase {
    func runTest<T>(_ t: T, _ expectedDebugDescription: String, _ expectedDescription: String, _ expectedData: String) where T: CBOREncodable {
        let cbor = t.cbor
        XCTAssertEqual(cbor.debugDescription, expectedDebugDescription)
        XCTAssertEqual(cbor.description, expectedDescription)
        let data = cbor.encodeCBOR()
        XCTAssertEqual(data, expectedData.hexData!)
        let decodedCBOR = try! decodeCBOR(data)
        XCTAssertEqual(cbor, decodedCBOR)
    }

    func testUnsigned() throws {
        runTest(UInt8 (0), "UInt(0)", "0", "00")
        runTest(UInt16(0), "UInt(0)", "0", "00")
        runTest(UInt32(0), "UInt(0)", "0", "00")
        runTest(UInt64(0), "UInt(0)", "0", "00")
        runTest(UInt  (0), "UInt(0)", "0", "00")

        runTest(UInt8 (1), "UInt(1)", "1", "01")
        runTest(UInt16(1), "UInt(1)", "1", "01")
        runTest(UInt32(1), "UInt(1)", "1", "01")
        runTest(UInt64(1), "UInt(1)", "1", "01")
        runTest(UInt  (1), "UInt(1)", "1", "01")

        runTest(UInt8 (23), "UInt(23)", "23", "17")
        runTest(UInt16(23), "UInt(23)", "23", "17")
        runTest(UInt32(23), "UInt(23)", "23", "17")
        runTest(UInt64(23), "UInt(23)", "23", "17")
        runTest(UInt  (23), "UInt(23)", "23", "17")

        runTest(UInt8 (24), "UInt(24)", "24", "1818")
        runTest(UInt16(24), "UInt(24)", "24", "1818")
        runTest(UInt32(24), "UInt(24)", "24", "1818")
        runTest(UInt64(24), "UInt(24)", "24", "1818")
        runTest(UInt  (24), "UInt(24)", "24", "1818")

        runTest(UInt8       .max,  "UInt(255)", "255", "18ff")
        runTest(UInt16(UInt8.max), "UInt(255)", "255", "18ff")
        runTest(UInt32(UInt8.max), "UInt(255)", "255", "18ff")
        runTest(UInt64(UInt8.max), "UInt(255)", "255", "18ff")
        runTest(UInt  (UInt8.max), "UInt(255)", "255", "18ff")

        runTest(UInt16       .max,  "UInt(65535)", "65535", "19ffff")
        runTest(UInt32(UInt16.max), "UInt(65535)", "65535", "19ffff")
        runTest(UInt64(UInt16.max), "UInt(65535)", "65535", "19ffff")
        runTest(UInt  (UInt16.max), "UInt(65535)", "65535", "19ffff")

        runTest(UInt32(65536), "UInt(65536)", "65536", "1a00010000")
        runTest(UInt64(65536), "UInt(65536)", "65536", "1a00010000")
        runTest(UInt  (65536), "UInt(65536)", "65536", "1a00010000")

        runTest(UInt32       .max,  "UInt(4294967295)", "4294967295", "1affffffff")
        runTest(UInt64(UInt32.max), "UInt(4294967295)", "4294967295", "1affffffff")
        runTest(UInt  (UInt32.max), "UInt(4294967295)", "4294967295", "1affffffff")

        runTest(4294967296, "UInt(4294967296)", "4294967296", "1b0000000100000000")

        runTest(UInt64.max, "UInt(18446744073709551615)", "18446744073709551615", "1bffffffffffffffff")
        runTest(UInt  .max, "UInt(18446744073709551615)", "18446744073709551615", "1bffffffffffffffff")
    }

    func testSigned() {
        runTest(Int8 (-1), "NInt(-1)", "-1", "20")
        runTest(Int16(-1), "NInt(-1)", "-1", "20")
        runTest(Int32(-1), "NInt(-1)", "-1", "20")
        runTest(Int64(-1), "NInt(-1)", "-1", "20")

        runTest(Int8 (-2), "NInt(-2)", "-2", "21")
        runTest(Int16(-2), "NInt(-2)", "-2", "21")
        runTest(Int32(-2), "NInt(-2)", "-2", "21")
        runTest(Int64(-2), "NInt(-2)", "-2", "21")

        runTest(Int8 (-127), "NInt(-127)", "-127", "387e")
        runTest(Int16(-127), "NInt(-127)", "-127", "387e")
        runTest(Int32(-127), "NInt(-127)", "-127", "387e")
        runTest(Int64(-127), "NInt(-127)", "-127", "387e")

        runTest(Int8 (Int8.min), "NInt(-128)", "-128", "387f")
        runTest(Int16(Int8.min), "NInt(-128)", "-128", "387f")
        runTest(Int32(Int8.min), "NInt(-128)", "-128", "387f")
        runTest(Int64(Int8.min), "NInt(-128)", "-128", "387f")

        runTest(Int8 (Int8.max), "UInt(127)", "127", "187f")
        runTest(Int16(Int8.max), "UInt(127)", "127", "187f")
        runTest(Int32(Int8.max), "UInt(127)", "127", "187f")
        runTest(Int64(Int8.max), "UInt(127)", "127", "187f")

        runTest(Int16(Int16.min), "NInt(-32768)", "-32768", "397fff")
        runTest(Int32(Int16.min), "NInt(-32768)", "-32768", "397fff")
        runTest(Int64(Int16.min), "NInt(-32768)", "-32768", "397fff")

        runTest(Int16(Int16.max), "UInt(32767)", "32767", "197fff")
        runTest(Int32(Int16.max), "UInt(32767)", "32767", "197fff")
        runTest(Int64(Int16.max), "UInt(32767)", "32767", "197fff")

        runTest(Int32(Int32.min), "NInt(-2147483648)", "-2147483648", "3a7fffffff")
        runTest(Int64(Int32.min), "NInt(-2147483648)", "-2147483648", "3a7fffffff")

        runTest(Int32(Int32.max), "UInt(2147483647)", "2147483647", "1a7fffffff")
        runTest(Int64(Int32.max), "UInt(2147483647)", "2147483647", "1a7fffffff")

        runTest(Int64.min, "NInt(-9223372036854775808)", "-9223372036854775808", "3b7fffffffffffffff")

        runTest(Int64.max, "UInt(9223372036854775807)", "9223372036854775807", "1b7fffffffffffffff")
    }

    func testBytes() {
        runTest(Bytes(‡"112233"), "Bytes(112233)", "h'112233'", "43112233")
        runTest(
            Bytes(‡"c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7"),
            "Bytes(c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7)",
            "h'c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7'",
            "5820c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7")
    }
    
    func testArray() {
        runTest([1, 2, 3], "Array([UInt(1), UInt(2), UInt(3)])", "[1, 2, 3]", "83010203")
        runTest([1, -2, 3], "Array([UInt(1), NInt(-2), UInt(3)])", "[1, -2, 3]", "83012103")
    }
    
    func testMap() {
        var map = Map()
        map.insert(-1, 3)
        map.insert([-1], 7)
        map.insert("z", 4)
        map.insert(10, 1)
        map.insert(false, 8)
        map.insert(100, 2)
        map.insert("aa", 5)
        map.insert([100], 6)
        runTest(map,
             #"Map({0x0a: (UInt(10), UInt(1)), 0x1864: (UInt(100), UInt(2)), 0x20: (NInt(-1), UInt(3)), 0x617a: (String("z"), UInt(4)), 0x626161: (String("aa"), UInt(5)), 0x811864: (Array([UInt(100)]), UInt(6)), 0x8120: (Array([NInt(-1)]), UInt(7)), 0xf4: (Value(false), UInt(8))})"#,
             #"{10: 1, 100: 2, -1: 3, "z": 4, "aa": 5, [100]: 6, [-1]: 7, false: 8}"#,
             "a80a011864022003617a046261610581186406812007f408")
    }
    
    func testMisorderedMap() {
        XCTAssertThrowsError(try decodeCBOR(‡"a2026141016142")) {
            guard case DecodeError.MisorderedMapKey = $0 else {
                XCTFail()
                return
            }
        }
    }
    
    func testString() {
        runTest("Hello", #"String("Hello")"#, #""Hello""#, "6548656c6c6f")
    }
    
    func testTagged() {
        runTest(Tagged(tag: 1, item: "Hello"), #"Tagged(1, String("Hello"))"#, #"1("Hello")"#, "c16548656c6c6f")
    }
    
    func testValue() {
        runTest(false, "Value(false)", "false", "f4")
        runTest(true, "Value(true)", "true", "f5")
        runTest(Value(100), "Value(100)", "simple(100)", "f864")
    }
    
    func testUnusedData() {
        XCTAssertThrowsError(try decodeCBOR(‡"0001")) {
            guard
                case DecodeError.UnusedData(let remaining) = $0,
                remaining == 1
            else {
                XCTFail()
                return
            }
        }
    }
    
    func testEnvelope() {
        let alice = Tagged(tag: 200, item: Tagged(tag: 24, item: "Alice"))
        let knows = Tagged(tag: 200, item: Tagged(tag: 24, item: "knows"))
        let bob = Tagged(tag: 200, item: Tagged(tag: 24, item: "Bob"))
        let knowsBob = Tagged(tag: 200, item: Tagged(tag: 221, item: [knows, bob]))
        let envelope = Tagged(tag: 200, item: [alice, knowsBob])
        let cbor = envelope.cbor
        XCTAssertEqual(cbor.description, #"200([200(24("Alice")), 200(221([200(24("knows")), 200(24("Bob"))]))])"#)
        let bytes = cbor.encodeCBOR()
        XCTAssertEqual(bytes, ‡"d8c882d8c8d81865416c696365d8c8d8dd82d8c8d818656b6e6f7773d8c8d81863426f62")
        let decodedCBOR = try! decodeCBOR(bytes)
        XCTAssertEqual(cbor, decodedCBOR)
    }
}
