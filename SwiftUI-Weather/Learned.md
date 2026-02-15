# SwiftUI Basics Notes

---

## 1. Main View

Every SwiftUI screen is a `View` and must contain a `body` that returns another `View`.

```swift
struct ContentView: View {
    var body: some View {
        // UI Elements
    }
}
```

---

## 2. Creating Custom Views

You can split UI into reusable components:

```swift
struct WeatherDayView: View {
    var body: some View {
        // some fancy icons
        // text label
        // button
    }
}
```

Use it inside `ContentView`:

```swift
struct ContentView: View {
    var body: some View {
        WeatherDayView()
    }
}
```

---

## 3. Layout Containers (Stacks)

SwiftUI provides layout containers:

* `VStack` → Vertical layout
* `HStack` → Horizontal layout
* `ZStack` → Overlay layout
* `Spacer()` → Flexible spacing

---

## 4. Modifiers

SwiftUI uses a modifier chain syntax:

```
Element
    .modifier
    .modifier
    .modifier
```

Example:

```swift
Text("Hello, World!")
    .padding()
    .font(.system(size: 18, weight: .medium))
    .foregroundStyle(.purple)
```

---

## 5. Buttons

```swift
Button {
    // action
    print("Hello world")
} label: {
    Text("Click me!")
        .frame(width: 200, height: 80)
        .clipShape(.capsule)
}
```

---

# State vs Binding

---

## @State

Creates a local reactive variable.
Whenever its value changes → UI automatically updates.

```swift
@State private var isNight: Bool = false
```

### Example

```swift
struct ContentView: View {
    @State private var isNight: Bool = false

    var body: some View {
        Button {
            isNight.toggle()
        } label: {
            Text("Click me!")
                .frame(width: 200, height: 80)
                .clipShape(isNight ? .capsule : .circle)
        }
    }
}
```

**Result:**
When `isNight` changes → button shape updates instantly.

---

## @Binding

Used when a **child view needs to read AND modify a parent's state**.

Parent owns the state → Child edits it.

---

### Example

#### Parent View

```swift
struct ContentView: View {
    @State private var isNight: Bool = false

    var body: some View {
        MyButton(day: $isNight) // pass binding using $
    }
}
```

#### Child View

```swift
struct MyButton: View {
    @Binding var day: Bool

    var body: some View {
        Button {
            day.toggle()
        } label: {
            Text("Click me!")
                .frame(width: 200, height: 80)
                .clipShape(day ? .capsule : .circle)
        }
    }
}
```

---

## Mental Model

| Property   | Meaning                                 |
| ---------- | --------------------------------------- |
| `@State`   | The view **owns** the data              |
| `@Binding` | The view **borrows and edits** the data |

> Parent stores data → Child modifies it
