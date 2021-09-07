public final class CurrentValue<Value>: AsyncSequence {
    public typealias Element = Value
    public typealias AsyncIterator = AsyncStream<Value>.Iterator
    
    public private(set) var currentValue: Value
    private var stream: AsyncStream<Value>! = nil
    private var continuation: AsyncStream<Value>.Continuation! = nil
    
    public init(_ initialValue: Value) {
        currentValue = initialValue
        stream = AsyncStream { (continuation: AsyncStream<Value>.Continuation) in
            self.continuation = continuation
        }
    }
    
    public func send(_ value: Value) {
        currentValue = value
        continuation.yield(value)
    }
    
    public func finish() {
        continuation.finish()
    }
    
    public func makeAsyncIterator() -> AsyncStream<Value>.Iterator {
        stream.makeAsyncIterator()
    }
}
