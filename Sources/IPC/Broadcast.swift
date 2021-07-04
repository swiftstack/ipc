public actor Broadcast<Result> {
    var continuations: [UnsafeContinuation<Result, Never>]

    public init() {
        continuations = []
    }

    public func wait() async -> Result {
        await withUnsafeContinuation { continutaion in
            continuations.append(continutaion)
        }
    }

    public func dispatch(_ result: Result) {
        let continuations = self.continuations
        self.continuations.removeAll(keepingCapacity: true)
        continuations.forEach { $0.resume(returning: result) }
    }
}
