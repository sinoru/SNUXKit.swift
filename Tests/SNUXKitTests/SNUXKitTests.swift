import XCTest
@testable import SNUXKit

final class SNUXKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SNUXKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
