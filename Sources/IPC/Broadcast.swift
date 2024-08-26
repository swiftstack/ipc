public actor Broadcast<Result: Sendable> {
    var continuations: [UnsafeContinuation<Result, Never>]

    public init() {
        continuations = []
    }

    public func wait() async -> Result {
        await withUnsafeContinuation { continuation in
            continuations.append(continuation)
        }
    }

    public func dispatch(_ result: Result) {
        let continuations = self.continuations
        self.continuations.removeAll(keepingCapacity: true)
        continuations.forEach { $0.resume(returning: result) }
    }
}
