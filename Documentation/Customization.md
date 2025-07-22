# Customization

## Table of Contents

- [Intro](#intro)
- [Example](#example)
- [Factory Instances](#factory-instances)
- [Pre-Existing Factory Instances](#pre-existing-factory-instances)

## Intro

Components are not meant to be customized with view modifiers, the same way you would customize a `SwiftUI` component. All components have a Appearances that they take in initializers. All Appearance have default values, and all properties within those Appearances have default values as well.

## Example

For instance, you can change the foreground color of a `VPlainButton` by modifying its Appearance.

Not Preferred:

```swift
var body: some View {
    VPlainButton(
        action: doSomething,
        title: "Lorem Ipsum"
    )
    .foregroundStyle(.primary)
}
```

Preferred:

```swift
let appearance: VPlainButtonAppearance = {
    var appearance: VPlainButtonAppearance = .init()
    
    appearance.titleTextColors = VPlainButtonAppearance.StateColors(
        enabled: Color.primary,
        pressed: Color.secondary,
        disabled: Color.secondary
    )
    
    return appearance
}()

var body: some View {
    VPlainButton(
        appearance: appearance,
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

## Factory Instances

Alternately, you can create `static` instances of Appearances for reusability.

```swift
extension VPlainButtonAppearance {
    static let someAppearance: Self = {
        var appearance: Self = .init()
        
        appearance.titleTextColors = StateColors(
            enabled: Color.primary,
            pressed: Color.secondary,
            disabled: Color.secondary
        )
        
        return appearance
    }()
}

var body: some View {
    VPlainButton(
        appearance: .someAppearance,
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

## Pre-Existing Factory Instances

Frequently, you will discover pre-existing static factory-initialized Appearances associated with each component. It's recommended to check Appearance files before creating them yourself.

```swift
var body: some View {
    VWrappingMarquee(appearance: .insettedGradientMask) {
        HStack {
            Image(systemName: "swift")
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
        .drawingGroup() // For `Image`
    }
}
```
