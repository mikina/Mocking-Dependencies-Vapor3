import XCTest

extension AppTests {
    static let __allTests = [
        ("testNothing", testNothing),
    ]
}

extension AvailabilityTests {
    static let __allTests = [
        ("testCheckProductAvailabilityDontExists", testCheckProductAvailabilityDontExists),
        ("testCheckProductAvailabilityNotEnough", testCheckProductAvailabilityNotEnough),
        ("testCheckProductAvailabilityWithSuccess", testCheckProductAvailabilityWithSuccess),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppTests.__allTests),
        testCase(AvailabilityTests.__allTests),
    ]
}
#endif
