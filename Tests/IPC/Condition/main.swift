import Test
@testable import IPC

test.case("Condition") {
    let condition = Condition()

    let handle1 = asyncTask {
        expect(condition.isSatisfied == false)
        await condition.wait()
        expect(condition.isSatisfied == true)
    }

    let handle2 = asyncTask {
        expect(condition.isSatisfied == false)
        await condition.notify()
        expect(condition.isSatisfied == true)
    }

    try await handle1.get()
    try await handle2.get()
}

test.run()
