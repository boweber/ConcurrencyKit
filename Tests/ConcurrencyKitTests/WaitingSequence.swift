struct WaitingSequence: AsyncSequence {
    typealias Element = Bool
    let durations: [UInt64]
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(durations: durations)
    }
    struct AsyncIterator: AsyncIteratorProtocol {
        var durations: [UInt64]
        
        mutating func next() async throws -> Bool? {
            guard !durations.isEmpty else {
                return nil
            }
            try await Task.sleep(nanoseconds: durations.removeFirst())
            return true
        }
    }
}
