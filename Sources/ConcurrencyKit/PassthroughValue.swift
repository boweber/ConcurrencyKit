public actor PassthroughValue<Value>: AsyncSequence {
    public typealias Element = Value
    public typealias AsyncIterator = AsyncStream<Value>.Iterator
    
    private let storage: Storage
    
    public init(_ initialValue: Value) {
        storage = Storage()
    }
    
    public func yield(_ newValue: Value) {
        storage.continuation.yield(newValue)
    }
    
    public func finish() {
        storage.continuation.finish()
    }
    
    nonisolated public func makeAsyncIterator() -> AsyncStream<Value>.Iterator {
        storage.stream.makeAsyncIterator()
    }
    
    private struct Storage {
        var stream: AsyncStream<Value>! = nil
        var continuation: AsyncStream<Value>.Continuation! = nil
        
        init() {
            stream = AsyncStream { (continuation: AsyncStream<Value>.Continuation) in
                self.continuation = continuation
            }
        }
    }
}
