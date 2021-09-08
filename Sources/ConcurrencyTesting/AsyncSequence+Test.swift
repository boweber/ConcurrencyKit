import XCTest

extension AsyncSequence {
    public func observedElements(after seconds: UInt64) async throws -> [Element] {
        let observationTask: Task<[Element], Error> = Task.detached(priority: Task.currentPriority) {
            var observations: [Element] = []
            do {
                for try await observation in self {
                    observations.append(observation)
                }
            } catch {
                if error is CancellationError {
                    return observations
                } else {
                    throw error
                }
            }
            return observations
        }
        try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
        observationTask.cancel()
        return try await observationTask.value
    }
}

public func AssertElements<S: AsyncSequence>(
    _ expectedElements: [S.Element],
    in sequence: S,
    after seconds: UInt64,
    file: StaticString = #file,
    line: UInt = #line
) async throws where S.Element: Equatable {
    let observations = try await sequence.observedElements(after: seconds)
    XCTAssertEqual(observations, expectedElements, file: file, line: line)
}
