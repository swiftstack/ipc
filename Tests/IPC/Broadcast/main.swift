import Test
@testable import IPC

extension Broadcast {
    @actorIndependent(unsafe)
    var _continuations: [UnsafeContinuation<Result, Never>] { continuations }

    @inline(never)
    func nop() async { }
    func yield() async { for _ in 0..<333 { await nop() } }
}

test.case("Broadcast") {
    let broadcast = Broadcast<Bool>()

    let handle1 = asyncTask {
        expect(await broadcast.wait() == true)
    }

    await broadcast.yield()
    expect(broadcast._continuations.count == 1)

    let handle2 = asyncTask {
        await broadcast.dispatch(true)
        expect(broadcast._continuations.count == 0)
    }

    await handle1.get()
    await handle2.get()
}

test.run()
