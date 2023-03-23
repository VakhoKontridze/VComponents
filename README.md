# VComponents

## Table of Contents

- [Description](#description)
- [Compatibility](#compatibility)
- [Components](#components)
- [Guidelines](#guidelines)
- [Installation](#installation)
- [Versioning](#versioning)
- [Contact](#contact)

## Description

VComponents is a `SwiftUI` package that contains 30+ customizable UI components.

## Compatibility

Package provides limited `macOS`, `tvOS`, and `watchOS` support.

Versions with different majors are not directly compatible. When a new major is released, deprecated symbols are removed.

| Ver | Release Date | SDK                                                    | VCore         | Comment                                    |
| :-- | :--          | :--                                                    | :--           | :--                                        |
| 4.0 | 2023 XX XX   | iOS 13.0<br/>macOS 10.15<br/>tvOS 13.0<br/>watchOS 6.0 | 4.7.0 - 4.x.x | iOS 13.0 support.<br/>Multiplatform support.   |
| 3.0 | 2022 10 02   | iOS 16.0                                               | 4.1.0 - 4.x.x | New SwiftUI API.<br/>API changes.              |
| 2.0 | 2022 05 26   | iOS 15.0                                               | 3.2.0 - 3.x.x | New SwiftUI API.<br/>API changes.<br/>SPM support. |
| 1.0 | 2021 02 07   | iOS 14.0                                               | -             | -                                          |

## Components

???

## Guidelines

#### UI Models

Components are not meant to be customized like you would a native `SwiftUI` component.

Instead, UI model can be passed as parameter to initializers. This parameter has default value, and is not required every time you create a view.

UI Models are `struct`s with default values. They break down into 5 models: `Layout`, `Colors`, `Fonts`, `Animations`, and `Misc`.

For instance, changing foreground color of `VSecondaryButton` can be done by passing an IU model.

Not Preferred:

```swift
var body: some View {
    VSecondaryButton(
        action: doSomething,
        title: "Lorem ipsum"
    )
        .foregroundColor(.black)
}
```

Preferred:

```swift
let uiModel: VSecondaryButtonUIModel = {
    var UIModel: VSecondaryButtonUIModel = .init()
    
    uiModel.colors.textContent = .init(
        enabled: .black,
        pressed: .gray,
        disabled: .gray
    )
    
    return uiModel
}()

var body: some View {
    VSecondaryButton(
        uiModel: uiModel,
        action: doSomething,
        title: "Lorem ipsum"
    )
}
```

Alternately, you can create static instances of UI models for reusability.

```swift
extension VSecondaryButtonUIModel {
    static let someUIModel: VSecondaryButtonUIModel = {
        var uiModel: VSecondaryButtonModel = .init()
        
        uiModel.colors.textContent = .init(
            enabled: .black,
            pressed: .gray,
            disabled: .gray
        )
        
        return uiModel
    }()
}

var body: some View {
    VSecondaryButton(
        uiModel: .someUIModel,
        action: doSomething,
        title: "Lorem ipsum"
    )
}
```

#### Animations

VComponents approaches animations as bound to components and their UI models, and not to state. Which means, that to modify a state of component with an animation, you need to pass a custom UI model.

Not Preferred:

```swift
@State var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(
            isOn: $isOn, 
            title: "Lorem ipsum"
        )
        
        VSecondaryButton(
            action: { withAnimation(nil, { isOn.toggle() }) },
            title: "Toggle"
        )
    })
}
```

Preferred:

```swift
@State var isOn: Bool = false

let uiModel: VToggleUIModel = {
    var uiModel: VToggleUIModel = .init()
    uiModel.animations.stateChange = nil
    return uiModel
}()

var body: some View {
    VStack(content: {
        VToggle(
            uiModel: uiModel, 
            isOn: $isOn, 
            title: "Lorem ipsum"
        )
        
        VSecondaryButton(
            action: { isOn.toggle() },
            title: "Toggle"
        )
    })
}
```

First method is not only not preferred, but it will also not work. Despite specifying `nil` to change state, `VToggle` would still use its default animation.

Components manage state parameters internally, and animations used to change them externally do not have any effect.

Thought process behind his design choice was to centralize animations to UI model.

Components also prevent themselves from modifying external state with an animation.

## Installation

#### Swift Package Manager

Add `https://github.com/VakhoKontridze/VComponents` as a Swift Package in Xcode and follow the instructions.

## Versioning

***Major***. Major changes, such as big overhauls

***Minor***. Minor changes, such as new component, types, or properties in UI models

***Patch***. Bug fixes and improvements

## Contact

e-mail: vakho.kontridze@gmail.com
