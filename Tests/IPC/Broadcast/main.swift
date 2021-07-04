import Test
@testable import IPC

test.case("Broadcast") {
    let broadcast = Broadcast<Bool>()

    let handle1 = asyncTask {
        expect(await broadcast.wait() == true)
    }

    await Task.yield()
    await expect(broadcast.continuations.count == 1)

    let handle2 = asyncTask {
        await broadcast.dispatch(true)
        await expect(broadcast.continuations.count == 0)
    }

    try await handle1.get()
    try await handle2.get()
}

test.run()
