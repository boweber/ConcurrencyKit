import XCTest

extension XCTestCase {
    public func observedElements<S: AsyncSequence>(
        in sequence: S,
        after duration: UInt64
    ) async throws -> [S.Element] {
        
        let observationTask: Task<[S.Element], Error> = Task.detached(priority: .high) {
            var observations: [S.Element] = []
            do {
                for try await observation in sequence {
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
        try await Task.sleep(nanoseconds: duration * 1_000_000_000)
        observationTask.cancel()
        return try await observationTask.value
    }
    
    public func expectElements<S: AsyncSequence>(
        _ expectedElements: [S.Element],
        in sequence: S,
        after duration: UInt64,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws where S.Element: Equatable {
        let observations = try await observedElements(in: sequence, after: duration)
        XCTAssertEqual(observations, expectedElements, file: file, line: line)
    }
}
