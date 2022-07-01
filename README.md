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

| Release Date | VComponents | iOS  | SwiftUI |
| ---          | ---         | ---  | ---     |
| 2022 05 26   | 2.0         | 15.0 | 3.0     |
| 2021 02 07   | 1.0         | 14.0 | 2.0     |

## Components

**Buttons.** VPrimaryButton, VSecondaryButton, VSquareButton, VPlainButton, VNavigationLink, VLink

**State Pickers.** VToggle, VCheckBox, VRadioButton

**Item Pickers.** VSegmentedPicker, VWheelPicker

**Value Pickers.** VStepper, VSlider, VRangeSlider

**Inputs.** VTextField

**Containers**. VSheet, VDisclosureGroup

**Lists.** VLazyScrollView, VList, VStaticList

**Modals.** VModal, VBottomSheet, VSideBar, VAlert, VConfirmationDialog, VMenu, VContextMenu

**Messages.** VToast

**Indicators.** VSpinner, VProgressBar, VPageIndicator

**Misc.** VText

## Brand Book

<p>
    <img width="300" src="https://user-images.githubusercontent.com/57289621/175477100-0f79fc5b-71e3-4553-ac06-9a7ce73531dd.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540197-785e93c8-7026-4b5c-a356-b9506b280989.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540202-a201d445-6b59-4d43-be18-d204f38321e9.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540203-0c92e02b-c61b-4ec3-acce-df7f8cc75ac8.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540207-0954e5ee-31df-430d-888e-33b0a731b49d.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540210-eb3a4b27-6c70-4bff-9648-74f48f195158.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540213-8aaf0819-17ca-4d10-859d-be6b4aa0d1a9.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/175922207-b07a015e-5b15-4d79-bd4b-c5e05dbc8491.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540217-9e16f5e3-b21f-4206-b470-ec6d6a125278.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540219-f5fb31af-0ac2-40ef-bc04-d1df526dab4f.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540220-d02a82f9-1cd6-4f5b-ae8b-f56857e9d109.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540222-9a1c058d-657f-4c12-9e99-05e145ea5d27.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540225-8a0991f1-c367-43b3-9146-c0ab21d3808c.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540229-a2e791fb-2123-435d-a2a9-3934d19c0843.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/175052648-b83bec65-4a23-4143-8522-9dcc91cbdc7a.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540231-415ac837-8c47-4969-96de-303dbc99c7e9.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/173796372-2027c2b6-2de5-4d6c-bf25-5f2a3c455db4.png">
    <img width="300" src="https://user-images.githubusercontent.com/57289621/170540237-5ba7e55f-56f7-4a3e-83e1-576c995636bb.png">
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
        
        return uiMmodel
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
