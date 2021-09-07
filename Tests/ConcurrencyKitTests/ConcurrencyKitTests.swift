import XCTest
@testable import ConcurrencyTesting
@testable import ConcurrencyKit

final class ConcurrencyKitTests: XCTestCase {
    
    let durations: [UInt64] = [2, 3, 4, 5].map { $0 * 1_000_000 }
    
    func testAssertElements() async throws {
        try await expectElements([true, true, true, true], in: WaitingSequence(durations: durations), after: 1)
    }
    
    func testCancelledBeforeReceivingAllElements() async throws {
        let modifiedDurations = durations.map { $0 * 1_000 }
        let observations = try await observedElements(in: WaitingSequence(durations: modifiedDurations), after: 6)
        XCTAssertEqual(observations, [true, true])
    }
    
    func testCurrentValue() async throws {
        let currentValue = CurrentValue(1)
        let observedValues: Task<[Int], Error> = Task.detached(priority: .high) {
            try await self.observedElements(in: currentValue, after: 1)
        }
        currentValue.send(2)
        currentValue.send(3)
        currentValue.send(4)
        let values = try await observedValues.value
        XCTAssertEqual([2,3,4], values)
    }
}
