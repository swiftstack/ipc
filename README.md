# ipc

## Example

```swift
let broadcast = Broadcast<Bool>()

_ = Task.runDetached {
    print(await broadcast.wait())
    // prints true
}

_ = Task.runDetached {
    print(await broadcast.wait())
    // prints true
}

await broadcast.dispatch(true)
```

```swift
let condition = Condition()

_ = Task.runDetached {
    await condition.wait()
}

_ = Task.runDetached {
    await condition.wait()
}

await condition.notify()
```
