public actor Condition {
    let broadcast: Broadcast<Void>
    var isSatisfied: Bool

    public init() {
        broadcast = .init()
        isSatisfied = false
    }

    public func wait() async {
        guard !isSatisfied else { return }
        await broadcast.wait()
    }

    public func notify() async {
        guard !isSatisfied else { return }
        isSatisfied = true
        await broadcast.dispatch(())
    }
}
