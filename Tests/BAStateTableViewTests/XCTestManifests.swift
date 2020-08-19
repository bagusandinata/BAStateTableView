import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BAStateTableViewTests.allTests),
    ]
}
#endif
