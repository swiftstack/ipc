import Test
@testable import IPC

extension Condition {
    @actorIndependent(unsafe)
    var _isSatisfied: Bool { isSatisfied }
}

test.case("Condition") {
    let condition = Condition()

    let handle1 = asyncTask {
        expect(condition._isSatisfied == false)
        await condition.notify()
        expect(condition._isSatisfied == true)
    }

    let handle2 = asyncTask {
        expect(condition._isSatisfied == false)
        await condition.wait()
        expect(condition._isSatisfied == true)
    }

    try await handle1.get()
    try await handle2.get()
}

test.run()
