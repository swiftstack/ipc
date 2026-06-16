# IPC

## Example

```swift
let broadcast = Broadcast<Bool>()

_ = Task.detached {
    print(await broadcast.wait())
    // prints true
}

_ = Task.detached {
    print(await broadcast.wait())
    // prints true
}

await broadcast.dispatch(true)
```

```swift
let condition = Condition()

_ = Task.detached {
    await condition.wait()
}

_ = Task.detached {
    await condition.wait()
}

await condition.notify()
```
