import Test
@testable import IPC

test.case("Condition") {
    let condition = Condition()

    let handle1 = asyncTask {
        await expect(condition.isSatisfied == false)
        await condition.wait()
        await expect(condition.isSatisfied == true)
    }

    let handle2 = asyncTask {
        await expect(condition.isSatisfied == false)
        await condition.notify()
        await expect(condition.isSatisfied == true)
    }

    try await handle1.value
    try await handle2.value
}

test.run()
