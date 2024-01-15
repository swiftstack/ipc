import Test
@testable import IPC

test("Condition") {
    let condition = Condition()

    let handle1 = Task {
        await expect(condition.isSatisfied == false)
        await condition.wait()
        await expect(condition.isSatisfied == true)
    }

    let handle2 = Task {
        await expect(condition.isSatisfied == false)
        await condition.notify()
        await expect(condition.isSatisfied == true)
    }

    await handle1.value
    await handle2.value
}

await run()
