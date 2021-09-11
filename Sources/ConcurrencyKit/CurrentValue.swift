public actor CurrentValue<Value>: AsyncSequence {
    public typealias Element = Value
    public typealias AsyncIterator = AsyncStream<Value>.Iterator
    
    private var currentValue: Value
    private let storage: Storage
    
    public var value: Value {
        get { currentValue }
        set { yield(newValue) }
    }
    
    public init(_ initialValue: Value) {
        currentValue = initialValue
        storage = Storage()
    }
    
    public func yield(_ newValue: Value) {
        currentValue = newValue
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
