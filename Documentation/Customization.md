# Customization

## Table of Contents

- [Intro](#intro)
- [Example](#example)
- [Mutating Methods](#mutating-methods)
- [Pre-Existing Mutating Methods](#pre-existing-mutating-methods)

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
var body: some View {
    VPlainButton(
        appearance: VPlainButtonAppearance {
            $0.labelTextColors = VPlainButtonAppearance.StateColors(
                enabled: Color.primary,
                pressed: Color.secondary,
                disabled: Color.secondary
            )
        },
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

Every Appearance has an initializer that takes a transform closure, so customization can be written inline. To reuse an Appearance across call sites, assign it to a property:

```swift
let appearance: VPlainButtonAppearance = .init {
    $0.labelTextColors = VPlainButtonAppearance.StateColors(
        enabled: Color.primary,
        pressed: Color.secondary,
        disabled: Color.secondary
    )
}
```

## Mutating Methods

Alternately, you can declare `mutating` methods on Appearances for reusability.

```swift
extension VPlainButtonAppearance {
    mutating func applySomeStyle() {
        labelTextColors = StateColors(
            enabled: Color.primary,
            pressed: Color.secondary,
            disabled: Color.secondary
        )
    }
}

var body: some View {
    VPlainButton(
        appearance: VPlainButtonAppearance { $0.applySomeStyle() },
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

Several of them can be applied to the same Appearance, alongside individual property assignments:

```swift
var body: some View {
    VPlainButton(
        appearance: VPlainButtonAppearance {
            $0.applyStandardStyle()
            $0.applyCompactLayout()
            $0.sensoryFeedback = nil
        },
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

The same initializer also takes a base Appearance, which the transform is applied on top of:

```swift
var body: some View {
    VPlainButton(
        appearance: VPlainButtonAppearance(sharedAppearance) {
            $0.sensoryFeedback = nil
        },
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

## Pre-Existing Mutating Methods

Frequently, you will discover pre-existing mutating methods associated with each component. It's recommended to check Appearance files before writing them yourself.

```swift
var body: some View {
    VWrappingMarquee(
        appearance: VWrappingMarqueeAppearance { $0.applyInsettedGradientMask() }
    ) {
        HStack {
            Image(systemName: "swift")
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
        .drawingGroup() // For `Image`
    }
}
```
