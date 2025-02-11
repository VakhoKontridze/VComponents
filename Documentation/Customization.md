# Customization

## Table of Contents

- [Intro](#intro)
- [Example](#example)
- [Factory](#factory)
- [Pre-Existing Factory](#pre-existing-factory)

## Intro

Components are not meant to be customized with view modifiers, the same way you would customize a `SwiftUI` component. All components have a UI models that they take in initializers. All UI models have default values, and all properties within those UI models have default values as well.

## Example

For instance, you can change the foreground color of a `VPlainButton` by modifying its UI model.

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
let uiModel: VPlainButtonUIModel = {
    var uiModel: VPlainButtonUIModel = .init()
    
    uiModel.titleTextColors = VPlainButtonUIModel.StateColors(
        enabled: Color.primary,
        pressed: Color.secondary,
        disabled: Color.secondary
    )
    
    return uiModel
}()

var body: some View {
    VPlainButton(
        uiModel: uiModel,
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

## Factory

Alternately, you can create `static` instances of UI models for reusability.

```swift
extension VPlainButtonUIModel {
    static let someUIModel: Self = {
        var uiModel: Self = .init()
        
        uiModel.titleTextColors = StateColors(
            enabled: Color.primary,
            pressed: Color.secondary,
            disabled: Color.secondary
        )
        
        return uiModel
    }()
}

var body: some View {
    VPlainButton(
        uiModel: .someUIModel,
        action: doSomething,
        title: "Lorem Ipsum"
    )
}
```

## Pre-Existing Factory

Frequently, you will discover pre-existing static factory-initialized UI models associated with each component. It's recommended to check UI model files before creating them yourself.

```swift
var body: some View {
    VWrappingMarquee(
        uiModel: .insettedGradientMask,
        content: {
            HStack(content: {
                Image(systemName: "swift")
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            })
            .drawingGroup() // For `Image`
        }
    )
}
```
