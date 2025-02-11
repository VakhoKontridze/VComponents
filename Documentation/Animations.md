# Animations

## Table of Contents

- [Intro](#intro)
- [Configuring Animations](configuring-animations)
- [Cancelling Animations and Applying Animations Externally](#cancelling-animations-and-applying-animations-externally)

## Intro

`VComponents` associates animations directly with components and their UI models, rather than with an external state.

```swift
@State private var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(isOn: $isOn)
        
        VPlainButton(
            action: { isOn.toggle() },
            title: "Toggle"
        )
    })
}
```

## Configuring Animations

By default, `VToggle` has an `easeIn` animation with a duration of `0.1`. This applies uniformly to both touch interactions, as well as any external modifications of the state. So, to modify state with a different animation, you'll need to provide a custom UI model.

```swift
@State private var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(
            uiModel: {
                var uiModel: VToggleUIModel = .init()
                uiModel.stateChangeAnimation = .easeIn(duration: 1)
                return uiModel
            }(),
            isOn: $isOn
        )
        
        VPlainButton(
            action: { isOn.toggle() },
            title: "Toggle"
        )
    })
}
```

## Cancelling Animations and Applying Animations Externally

#### Intro

There are two possible options for completely cancelling animations.

#### Option 1: nil Animation

The first is to set `stateChangeAnimation` to `nil`. While this does not completely remove the animation, it essentially applies a `nil` animation.

```swift
@State private var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(
            uiModel: {
                var uiModel: VToggleUIModel = .init()
                uiModel.stateChangeAnimation = nil
                return uiModel
            }(),
            isOn: $isOn
        )
        
        VPlainButton(
            action: { isOn.toggle() },
            title: "Toggle"
        )
    })
}
```

#### Option 2: Animation Flag

The second is to set `appliesStateChangeAnimation` to `false`. This option ensures that the `stateChangeAnimation` is not applied at all, thus effectively removing any animation tied to state changes, even `nil`.

```swift
@State private var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(
            uiModel: {
                var uiModel: VToggleUIModel = .init()
                uiModel.appliesStateChangeAnimation = false
                return uiModel
            }(),
            isOn: $isOn
        )
        
        VPlainButton(
            action: { isOn.toggle() },
            title: "Toggle"
        )
    })
}
```

#### External Animations

In certain scenarios, the distinction between these two can be substantial. For example, we could set the `appliesStateChangeAnimation` flag to `false` and subsequently mutate the state with an external animation.

```swift
@State private var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(
            uiModel: {
                var uiModel: VToggleUIModel = .init()
                uiModel.appliesStateChangeAnimation = false
                return uiModel
            }(),
            isOn: $isOn
        )
        
        VPlainButton(
            action: { 
                withAnimation(.easeInOut(duration: 1), {
                    isOn.toggle()
                })
            },
            title: "Toggle"
        )
    })
}
```
