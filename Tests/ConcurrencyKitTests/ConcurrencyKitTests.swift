import XCTest
@testable import ConcurrencyTesting
@testable import ConcurrencyKit

final class ConcurrencyKitTests: XCTestCase {
    
    let durations: [UInt64] = [2, 3, 4, 5].map { $0 * 1_000_000 }
    
    func testAssertElements() async throws {
        try await AssertElements([true, true, true, true], in: WaitingSequence(durations: durations), after: 1)
    }
    
    func testCancelledBeforeReceivingAllElements() async throws {
        let modifiedDurations = durations.map { $0 * 1_000 }
        let observations = try await WaitingSequence(durations: modifiedDurations).observedElements(after: 6)
        XCTAssertEqual(observations, [true, true])
    }
    
    func testCurrentValue() async throws {
        let currentValue = CurrentValue(1)
        let observedValues: Task<[Int], Error> = Task.detached(priority: .high) {
            try await currentValue.observedElements(after: 1)
        }
        let sendingValues = [2,3,4]
        sendingValues.forEach { currentValue.value = $0 }
        let values = try await observedValues.value
        XCTAssertEqual(sendingValues, values)
    }
}
