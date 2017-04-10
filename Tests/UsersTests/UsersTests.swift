import XCTest
@testable import Users

class UsersTests: XCTestCase {
    func testUsers() {
        XCTAssertNil(User().name)
    }


    static var allTests = [
        ("testUsers", testUsers),
    ]
}
