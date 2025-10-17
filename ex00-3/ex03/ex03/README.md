# Data flows and triggers re-rendering

## @State

Use state as the single source of truth for a given value type that you store in a view hierarchy. This view owns this piece of state.

- Creates a piece of local state stored by SwiftUI, not inside the struct itself.
- When it changes → the view re-renders.

```swift
struct PlayButton: View {
    @State private var isPlaying: Bool = false // Create the state.


    var body: some View {
        Button(isPlaying ? "Pause" : "Play") { // Read the state.
            isPlaying.toggle() // Write the state.
        }
    }
}
```
If you pass a state property to a subview, SwiftUI updates the subview any time the value changes in the container view, but the subview can’t modify the value. To enable the subview to modify the state’s stored value, pass a Binding instead.



## @Binding and $value

This view does't own the data, it just get a refference to an external state.
It is like a bridge of extension of the view's data.

- Acts as a two-way connection to another state value.
- Allows child views to read and modify parent state.
- Does not store anything itself — it just forwards changes.

```swift
    struct CounterButton: View {
    @Binding var count: Int
    
    var body: some View {
        Button("Count: \(count)") {
            count += 1 // mutates parent’s @State
        }
    }
}

struct Parent: View {
    @State private var count = 0
    
    var body: some View {
        CounterButton(count: $count) // pass binding
    }
}
```


## @StateObject 

This view owns an observable refference type.
SwiftUI manages the lifecycle of this object (it persists through re-renders).

```swift
class CounterModel: ObservableObject {
    @Published var count = 0
}

struct CounterView: View {
    @StateObject var model = CounterModel()
    
    var body: some View {
        Button("Count: \(model.count)") {
            model.count += 1
        }
    }
}
```

