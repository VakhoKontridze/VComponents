# VComponents

## Table of Contents

- [Description](#description)
- [Compatibility](#compatibility)
- [Components](#components)
- [Brand Book](#brand-book)
- [Guidelines](#guidelines)
- [Demo](#demo)
- [Installation](#installation)
- [Versioning](#versioning)
- [Contact](#contact)

## Description

VComponents is a SwiftUI package that contains 30+ customizable UI components.

## Compatibility

Versions with different majors are not compatible.

| Release Date | VComponents | iOS  | SwiftUI |
| ---          | ---         | ---  | ---     |
| 2022 09 ??   | 3.0         | 16.0 | 4.0     |
| 2022 05 26   | 2.0         | 15.0 | 3.0     |
| 2021 02 07   | 1.0         | 14.0 | 2.0     |

## Components

**Buttons.** VPrimaryButton, VSecondaryButton, VRoundedButton, VRoundedLabeledButton, VPlainButton

**State Pickers.** VToggle, VCheckBox, VRadioButton

**Item Pickers.** VSegmentedPicker, VWheelPicker

**Value Pickers.** VStepper, VSlider, VRangeSlider

**Inputs.** VTextField, VTextView

**Containers**. VSheet, VDisclosureGroup

**Lists.** VList

**Modals.** VModal, VBottomSheet, VSideBar, VAlert, VConfirmationDialog, VMenu, VContextMenu

**Messages.** VToast

**Indicators.** VSpinner, VProgressBar, VPageIndicator

**Misc.** VText

## Brand Book

<p>
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466168-56484ad7-f13b-45be-9000-1e52cb699605.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466173-44782cb0-144f-42ce-a14b-e9fa719e5108.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466174-528a392b-949a-4e3c-b862-8a7b65106492.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466175-feb582e1-2f40-4096-96cc-635ee5301ac8.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466176-209f3d54-b1b9-466e-bd42-ac30bed1a003.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466178-35d3c3b6-f7bd-44a3-a9ca-8765a62bda3b.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466179-828be48b-1df1-4836-bd56-fc769df97889.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466180-1ea775d4-2041-4bb0-85f3-f72b15a3da08.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466182-4e6fadf2-2e1d-49b8-8e6c-d85d84dc436a.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466184-9f210f29-4562-4841-b99c-a484887e2b80.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466185-98fd6608-948d-41b7-bfce-c78a08791aff.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466187-fca3aaa8-0359-49d9-a2a7-6fe9cf50469d.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466188-c6f14c0c-0c3d-4cbd-b3e7-6f7019ab7685.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466189-3af1d2fb-ecfb-4a4e-a235-06c4a31ed9b7.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466191-dc4efead-5e18-40ae-8e42-d6d04c451508.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466192-3a679ac6-dfa8-4c70-9d69-e844457b861b.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466193-55548f74-9de6-4e99-9c07-f03cc4b6cdc9.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466194-bb16433b-f8b9-451b-a5f5-ac273e281760.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/193466196-8389a3f0-556a-4885-a602-4b6be2c48a2a.png">
</p>

## Guidelines

#### UI Models

Components are not meant to be customized like you would a native SwiftUI component.

Instead, UI model can be passed as parameter to initializers. This parameter has default value, and is not required every time you create a view.

UI Models are structs with default values. They break down into 5 sub-structs: `Layout`, `Colors`, `Fonts`, `Animations`, and `Misc`.

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

#### Types

Some components take type as parameter. Types are represented as enums, as more can be added in the future.

For instance, `VPageIndicator` has three types: `Finite`, `Infinite`, and `Auto`. Unlike UI models, types may be required in some instances. For other enums, a default case is provided.

```swift
var body: some View {
    VStack(content: {
        VPageIndicator(type: .finite, total: 9, selectedIndex: 4)
        
        VPageIndicator(type: .infinite(), total: 99, selectedIndex: 4)
        
        VPageIndicator(type: .auto(), total: 99, selectedIndex: 4)
    })
}
```

Some enums can also contain additional cases, such as `focused` for `VBaseTextField` and `VTextField`.

#### Animations

VComponents approaches animations as bound to components and their UI models, and not to state. Which means, that to modify a state of component with an animation, you need to pass a custom UI model.

Not Preferred:

```swift
@State var isOn: Bool = false

var body: some View {
    VStack(content: {
        VToggle(isOn: $isOn, title: "Lorem ipsum")
        
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
        VToggle(uiModel: uiModel, isOn: $isOn, title: "Lorem ipsum")
        
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

## Demo

Package contains demo app, that can be run to showcase all components.

<img width="700" src="https://user-images.githubusercontent.com/57289621/170541609-a6773104-f17d-4397-ac21-6593f858f90e.jpg">

## Installation

#### Swift Package Manager

Add `https://github.com/VakhoKontridze/VComponents` as a Swift Package in Xcode and follow the instructions.

## Versioning

***Major***. Major changes, such as big overhauls

***Minor***. Minor changes, such as new component, types, or properties in UI models

***Patch***. Bug fixes and improvements

## Contact

e-mail: vakho.kontridze@gmail.com
