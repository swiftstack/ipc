import Testing
@testable import IPC

@Test("Broadcast")
func broadcast() async throws {
    let broadcast = Broadcast<Bool>()

    let handle1 = Task {
        #expect(await broadcast.wait() == true)
    }

    await Task.yield()
    await #expect(broadcast.continuations.count == 1)

    let handle2 = Task {
        await broadcast.dispatch(true)
        await #expect(broadcast.continuations.count == 0)
    }

    await handle1.value
    await handle2.value
}
