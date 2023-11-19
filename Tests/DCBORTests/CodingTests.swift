import XCTest
import WolfBase
import DCBOR

final class CodingTests: XCTestCase {
    func runTest<T>(_ t: T, _ expectedDebugDescription: String, _ expectedDescription: String, _ expectedData: String) where T: CBORCodable & Equatable {
        let cbor = t.cbor
        XCTAssertEqual(cbor.debugDescription, expectedDebugDescription)
        XCTAssertEqual(cbor.description, expectedDescription)
        let data = cbor.cborData
        XCTAssertEqual(data.hex, expectedData.lowercased())
        let decodedCBOR = try! CBOR(data)
        XCTAssertEqual(cbor, decodedCBOR)
        let decodedT = try! T(cbor: cbor)
        XCTAssertEqual(t, decodedT)
    }

    func testUnsigned() throws {
        runTest(UInt8 (0), "unsigned(0)", "0", "00")
        runTest(UInt16(0), "unsigned(0)", "0", "00")
        runTest(UInt32(0), "unsigned(0)", "0", "00")
        runTest(UInt64(0), "unsigned(0)", "0", "00")
        runTest(UInt  (0), "unsigned(0)", "0", "00")

        runTest(UInt8 (1), "unsigned(1)", "1", "01")
        runTest(UInt16(1), "unsigned(1)", "1", "01")
        runTest(UInt32(1), "unsigned(1)", "1", "01")
        runTest(UInt64(1), "unsigned(1)", "1", "01")
        runTest(UInt  (1), "unsigned(1)", "1", "01")

        runTest(UInt8 (23), "unsigned(23)", "23", "17")
        runTest(UInt16(23), "unsigned(23)", "23", "17")
        runTest(UInt32(23), "unsigned(23)", "23", "17")
        runTest(UInt64(23), "unsigned(23)", "23", "17")
        runTest(UInt  (23), "unsigned(23)", "23", "17")

        runTest(UInt8 (24), "unsigned(24)", "24", "1818")
        runTest(UInt16(24), "unsigned(24)", "24", "1818")
        runTest(UInt32(24), "unsigned(24)", "24", "1818")
        runTest(UInt64(24), "unsigned(24)", "24", "1818")
        runTest(UInt  (24), "unsigned(24)", "24", "1818")

        runTest(UInt8       .max,  "unsigned(255)", "255", "18ff")
        runTest(UInt16(UInt8.max), "unsigned(255)", "255", "18ff")
        runTest(UInt32(UInt8.max), "unsigned(255)", "255", "18ff")
        runTest(UInt64(UInt8.max), "unsigned(255)", "255", "18ff")
        runTest(UInt  (UInt8.max), "unsigned(255)", "255", "18ff")

        runTest(UInt16       .max,  "unsigned(65535)", "65535", "19ffff")
        runTest(UInt32(UInt16.max), "unsigned(65535)", "65535", "19ffff")
        runTest(UInt64(UInt16.max), "unsigned(65535)", "65535", "19ffff")
        runTest(UInt  (UInt16.max), "unsigned(65535)", "65535", "19ffff")

        runTest(UInt32(65536), "unsigned(65536)", "65536", "1a00010000")
        runTest(UInt64(65536), "unsigned(65536)", "65536", "1a00010000")
        runTest(UInt  (65536), "unsigned(65536)", "65536", "1a00010000")

        runTest(UInt32       .max,  "unsigned(4294967295)", "4294967295", "1affffffff")
        runTest(UInt64(UInt32.max), "unsigned(4294967295)", "4294967295", "1affffffff")
        runTest(UInt  (UInt32.max), "unsigned(4294967295)", "4294967295", "1affffffff")

        runTest(4294967296, "unsigned(4294967296)", "4294967296", "1b0000000100000000")

        runTest(UInt64.max, "unsigned(18446744073709551615)", "18446744073709551615", "1bffffffffffffffff")
        runTest(UInt  .max, "unsigned(18446744073709551615)", "18446744073709551615", "1bffffffffffffffff")
    }

    func testSigned() {
        runTest(Int8 (-1), "negative(-1)", "-1", "20")
        runTest(Int16(-1), "negative(-1)", "-1", "20")
        runTest(Int32(-1), "negative(-1)", "-1", "20")
        runTest(Int64(-1), "negative(-1)", "-1", "20")

        runTest(Int8 (-2), "negative(-2)", "-2", "21")
        runTest(Int16(-2), "negative(-2)", "-2", "21")
        runTest(Int32(-2), "negative(-2)", "-2", "21")
        runTest(Int64(-2), "negative(-2)", "-2", "21")

        runTest(Int8 (-127), "negative(-127)", "-127", "387e")
        runTest(Int16(-127), "negative(-127)", "-127", "387e")
        runTest(Int32(-127), "negative(-127)", "-127", "387e")
        runTest(Int64(-127), "negative(-127)", "-127", "387e")

        runTest(Int8 (Int8.min), "negative(-128)", "-128", "387f")
        runTest(Int16(Int8.min), "negative(-128)", "-128", "387f")
        runTest(Int32(Int8.min), "negative(-128)", "-128", "387f")
        runTest(Int64(Int8.min), "negative(-128)", "-128", "387f")

        runTest(Int8 (Int8.max), "unsigned(127)", "127", "187f")
        runTest(Int16(Int8.max), "unsigned(127)", "127", "187f")
        runTest(Int32(Int8.max), "unsigned(127)", "127", "187f")
        runTest(Int64(Int8.max), "unsigned(127)", "127", "187f")

        runTest(Int16(Int16.min), "negative(-32768)", "-32768", "397fff")
        runTest(Int32(Int16.min), "negative(-32768)", "-32768", "397fff")
        runTest(Int64(Int16.min), "negative(-32768)", "-32768", "397fff")

        runTest(Int16(Int16.max), "unsigned(32767)", "32767", "197fff")
        runTest(Int32(Int16.max), "unsigned(32767)", "32767", "197fff")
        runTest(Int64(Int16.max), "unsigned(32767)", "32767", "197fff")

        runTest(Int32(Int32.min), "negative(-2147483648)", "-2147483648", "3a7fffffff")
        runTest(Int64(Int32.min), "negative(-2147483648)", "-2147483648", "3a7fffffff")

        runTest(Int32(Int32.max), "unsigned(2147483647)", "2147483647", "1a7fffffff")
        runTest(Int64(Int32.max), "unsigned(2147483647)", "2147483647", "1a7fffffff")

        runTest(Int64.min, "negative(-9223372036854775808)", "-9223372036854775808", "3b7fffffffffffffff")

        runTest(Int64.max, "unsigned(9223372036854775807)", "9223372036854775807", "1b7fffffffffffffff")
    }

    func testBytes() {
        runTest(‡"112233", "bytes(112233)", "h'112233'", "43112233")
        runTest(
            ‡"c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7",
            "bytes(c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7)",
            "h'c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7'",
            "5820c0a7da14e5847c526244f7e083d26fe33f86d2313ad2b77164233444423a50a7")
    }
    
    func testArray() {
        runTest([1, 2, 3], "array([unsigned(1), unsigned(2), unsigned(3)])", "[1, 2, 3]", "83010203")
        runTest([1, -2, 3], "array([unsigned(1), negative(-2), unsigned(3)])", "[1, -2, 3]", "83012103")
    }
    
    func testMap() throws {
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
             #"map({0x0a: (unsigned(10), unsigned(1)), 0x1864: (unsigned(100), unsigned(2)), 0x20: (negative(-1), unsigned(3)), 0x617a: (text("z"), unsigned(4)), 0x626161: (text("aa"), unsigned(5)), 0x811864: (array([unsigned(100)]), unsigned(6)), 0x8120: (array([negative(-1)]), unsigned(7)), 0xf4: (simple(false), unsigned(8))})"#,
             #"{10: 1, 100: 2, -1: 3, "z": 4, "aa": 5, [100]: 6, [-1]: 7, false: 8}"#,
             "a80a011864022003617a046261610581186406812007f408")
        XCTAssertNil(map[true] as Int?)
        XCTAssertEqual(map[-1], 3)
        XCTAssertEqual(map[[-1]], 7)
        XCTAssertEqual(map["z"], 4)
        XCTAssertNil(map["foo"] as Int?)
    }
    
    func testAndersMap() throws {
        let map: Map = [
            1: 45.7,
            2: "Hi there!"
        ]
        XCTAssertEqual(map.cborData, ‡"a201fb4046d9999999999a0269486920746865726521")
        XCTAssertEqual(map[1], 45.7)
    }

    func testMisorderedMap() {
        let mapWithOutOfOrderKeys = ‡"a8f4080a011864022003617a046261610581186406812007"
        XCTAssertThrowsError(try CBOR(mapWithOutOfOrderKeys)) {
            guard case CBORError.misorderedMapKey = $0 else {
                XCTFail()
                return
            }
        }
    }
    
    func testDuplicateKey() {
        let mapWithDuplicateKey = ‡"a90a011864022003617a046261610581186406812007f408f408"
        XCTAssertThrowsError(try CBOR(mapWithDuplicateKey)) {
            guard case CBORError.duplicateMapKey = $0 else {
                XCTFail()
                return
            }
        }
    }

    func testString() {
        runTest("Hello", #"text("Hello")"#, #""Hello""#, "6548656c6c6f")
    }
    
    func testTagged() {
        runTest(Tagged(1, "Hello"), #"tagged(1, text("Hello"))"#, #"1("Hello")"#, "c16548656c6c6f")
    }
    
    func testValue() {
        runTest(false, "simple(false)", "false", "f4")
        runTest(true, "simple(true)", "true", "f5")
//        runTest(Simple(100), "simple(100)", "simple(100)", "f864")
        
        XCTAssertEqual(CBOR.null.description, "null")
        XCTAssertEqual(CBOR.null.debugDescription, "simple(null)")
        XCTAssertEqual(CBOR.null.cborData, ‡"f6")
        XCTAssertEqual(try! CBOR(‡"f6"), CBOR.null)
    }
    
    func testUnusedData() {
        XCTAssertThrowsError(try CBOR(‡"0001")) {
            guard
                case CBORError.unusedData(let remaining) = $0,
                remaining == 1
            else {
                XCTFail()
                return
            }
        }
    }
    
    func testEnvelope() {
        let alice = CBOR.tagged(200, CBOR.tagged(24, "Alice"))
        let knows = CBOR.tagged(200, CBOR.tagged(24, "knows"))
        let bob = CBOR.tagged(200, CBOR.tagged(24, "Bob"))
        let knowsBob = CBOR.tagged(200, CBOR.tagged(221, [knows, bob]))
        let envelope = CBOR.tagged(200, [alice, knowsBob])
        XCTAssertEqual(envelope.description, #"200([200(24("Alice")), 200(221([200(24("knows")), 200(24("Bob"))]))])"#)
        let bytes = envelope.cborData
        XCTAssertEqual(bytes, ‡"d8c882d8c8d81865416c696365d8c8d8dd82d8c8d818656b6e6f7773d8c8d81863426f62")
        let decodedCBOR = try! CBOR(bytes)
        XCTAssertEqual(envelope, decodedCBOR)
    }
    
    func testFloat() throws {
        // Floating point numbers get serialized as their shortest accurate representation.
        runTest(1.5,                "simple(1.5)",          "1.5",          "f93e00")
        runTest(2345678.25,         "simple(2345678.25)",   "2345678.25",   "fa4a0f2b39")
        runTest(1.2,                "simple(1.2)",          "1.2",          "fb3ff3333333333333")

        // Floating point values that can be represented as integers get serialized as integers.
        runTest(Float(42.0),        "unsigned(42)",         "42",           "182a")
        runTest(2345678.0,          "unsigned(2345678)",    "2345678",      "1a0023cace")
        runTest(-2345678.0,         "negative(-2345678)",   "-2345678",     "3a0023cacd")
        
        // Negative zero gets serialized as integer zero.
        runTest(-0.0,               "unsigned(0)",          "0",            "00")
    }
    
    func testIntCoercedToFloat() throws {
        let n = 42
        let c = n.cbor
        let f = try Double(cbor: c)
        XCTAssertEqual(f, Double(n))
        let c2 = f.cbor
        XCTAssertEqual(c2, c)
        let i = try Int(cbor: c2)
        XCTAssertEqual(i, n)
    }
    
    func testFailFloatCoercedToInt() throws {
        // Floating point values cannot be coerced to integer types.
        let n = 42.5
        let c = n.cbor
        let f = try Double(cbor: c)
        XCTAssertEqual(f, n)
        XCTAssertThrowsError(try Int(cbor: c))
    }
    
    func testNonCanonicalFloat1() throws {
        // Non-canonical representation of 1.5 that could be represented at a smaller width.
        let f = ‡"fb3ff8000000000000"
        XCTAssertThrowsError(try CBOR(f))
    }
    
    func testNonCanonicalFloat2() throws {
        // Non-canonical representation of a floating point value that could be represented as an integer.
        do {
            let f = ‡"F94A00" // 12.0
            XCTAssertThrowsError(try CBOR(f))
        }
    }
    
    let canonicalNaNData = ‡"f97e00"
    let canonicalInfinityData = ‡"f97c00"
    let canonicalNegativeInfinityData = ‡"f9fc00"

    func testEncodeNaN() throws {
        let nonstandardDoubleNaN = Double(bitPattern: 0x7ff9100000000001)
        XCTAssert(nonstandardDoubleNaN.isNaN)
        XCTAssertEqual(nonstandardDoubleNaN.cborData, canonicalNaNData)
        
        let nonstandardFloatNaN = Float(bitPattern: 0xffc00001)
        XCTAssert(nonstandardFloatNaN.isNaN)
        XCTAssertEqual(nonstandardFloatNaN.cborData, canonicalNaNData)
        
        let nonstandardFloat16NaN = CBORFloat16(bitPattern: 0x7e01)
        XCTAssert(nonstandardFloat16NaN.isNaN)
        XCTAssertEqual(nonstandardFloat16NaN.cborData, canonicalNaNData)
    }
    
    func testDecodeNaN() throws {
        // Canonical NaN decodes
        XCTAssert(try Double(cbor: CBOR(canonicalNaNData)).isNaN)
        // Non-canonical NaNs of any size throw
        XCTAssertThrowsError(try CBOR(‡"f97e01"))
        XCTAssertThrowsError(try CBOR(‡"faffc00001"))
        XCTAssertThrowsError(try CBOR(‡"fb7ff9100000000001"))
    }
    
    func testEncodeInfinity() throws {
        XCTAssertEqual(Double.infinity.cborData, canonicalInfinityData)
        XCTAssertEqual(Float.infinity.cborData, canonicalInfinityData)
        XCTAssertEqual(CBORFloat16.infinity.cborData, canonicalInfinityData)
        XCTAssertEqual((-Double.infinity).cborData, canonicalNegativeInfinityData)
        XCTAssertEqual((-Float.infinity).cborData, canonicalNegativeInfinityData)
        XCTAssertEqual((-CBORFloat16.infinity).cborData, canonicalNegativeInfinityData)
    }
    
    func testDecodeInfinity() throws {
        // Canonical infinity decodes
        XCTAssert(try Double(cbor: CBOR(canonicalInfinityData)) == Double.infinity)
        XCTAssert(try Double(cbor: CBOR(canonicalNegativeInfinityData)) == -Double.infinity)

        // Non-canonical +infinities throw
        XCTAssertThrowsError(try CBOR(‡"fa7f800000"))
        XCTAssertThrowsError(try CBOR(‡"fb7ff0000000000000"))

        // Non-canonical -infinities throw
        XCTAssertThrowsError(try CBOR(‡"faff800000"))
        XCTAssertThrowsError(try CBOR(‡"fbfff0000000000000"))
    }
}
