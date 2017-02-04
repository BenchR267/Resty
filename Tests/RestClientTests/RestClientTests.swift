import XCTest
@testable import RestClient

class RestClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(RestClient().text, "Hello, World!")
    }


    static var allTests : [(String, (RestClientTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
