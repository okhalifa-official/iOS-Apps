# SwiftUI Navigation & Grid View Notes

---

## 1. Grid View

Grids are created in LazyVGrid and by passing a list of the columns as GridItem objects.

```swift
let columns: [GridItem] = [ GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())]
LazyVGrid(columns: columns){
    // items to show in grid view
    ForEach(MockData.frameworks){ framework in
        // add button
        FrameworkButton(framework: framework, selectedFramework: $frameworkModel.selectedFramework)
    }
}
```

Grids can be wrapped in `ScrollView` to make the grid scrollable

```swift
...
ScrollView {
    LazyVGrid(columns: columns){
        ...
    }
}
```

---

## 2. Navigation

Navigation can be done in different ways, using `NavigationLink` or `NavigationView`

```swift
NavigationView{
    ZStack{
        ..
    }
    .navigationTitle("Title")
}
// show as modal view
.sheet(isPresented: $frameworkModel.isShowDetailView){
    // view content
    DetailView(isShowDetailView: $frameworkModel.isShowDetailView, selectedFramework: frameworkModel.selectedFramework!)
}
```

---

## 3. Web View

to add a web view (searching Safari) you can do it using UIKit (`SFSafariViewController` from `SafariServices`) or using SwiftUI.
Here is an example:

```swift
Link(destination: url) {
    // the content to be linked
    Text("Click me!")
}
```

---

## 4. Modern Navigation (iOS 16+)

`NavigationView` is deprecated → use `NavigationStack`

```swift
NavigationStack {
    List(MockData.frameworks) { framework in
        NavigationLink(value: framework) {
            Text(framework.name)
        }
    }
    .navigationTitle("Frameworks")
    .navigationDestination(for: Framework.self) { framework in
        DetailView(framework: framework)
    }
}
```

### Passing Data with NavigationLink

```swift
NavigationLink(destination: DetailView(framework: framework)) {
    FrameworkCell(framework: framework)
}
```

---

## 5. GridItem Types

You are not limited to `.flexible()`

```swift
GridItem(.fixed(120))      // exact size
GridItem(.flexible())      // fills remaining space
GridItem(.adaptive(minimum: 120)) // auto columns depending on screen size
```

Example adaptive grid (recommended for responsive UI):

```swift
let columns = [GridItem(.adaptive(minimum: 120))]

LazyVGrid(columns: columns) {
    ForEach(MockData.frameworks) { framework in
        FrameworkCell(framework: framework)
    }
}
```

---

## 6. Presenting Views (Modals)

### Sheet (half modal)

```swift
.sheet(isPresented: $showDetail) {
    DetailView()
}
```

### Full Screen Cover

```swift
.fullScreenCover(isPresented: $showDetail) {
    DetailView()
}
```

---

## 7. Opening Websites (Safari View Controller)

`Link` opens Safari app externally.
To open inside your app you must wrap UIKit.

```swift
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}
```

Usage:

```swift
.sheet(isPresented: $showSafari) {
    SafariView(url: URL(string: "https://apple.com")!)
}
```
