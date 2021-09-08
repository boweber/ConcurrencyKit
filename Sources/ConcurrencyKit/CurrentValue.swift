
// TODO: - Replace class with actor

public final class CurrentValue<Value>: AsyncSequence {
    public typealias Element = Value
    public typealias AsyncIterator = AsyncStream<Value>.Iterator
    
    public var currentValue: Value
    private var stream: AsyncStream<Value>! = nil
    private var continuation: AsyncStream<Value>.Continuation! = nil
    
    public var value: Value {
        get { currentValue }
        set {
            currentValue = newValue
            continuation.yield(value)
        }
    }
    
    public init(_ initialValue: Value) {
        currentValue = initialValue
        stream = AsyncStream { (continuation: AsyncStream<Value>.Continuation) in
            self.continuation = continuation
        }
    }
    
    public func finish() {
        continuation.finish()
    }
    
    nonisolated public func makeAsyncIterator() -> AsyncStream<Value>.Iterator {
        stream.makeAsyncIterator()
    }
}
