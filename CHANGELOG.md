## Change Log

#### [2.0.0(17)]

- Buttons, state pickers, and item pickers have been reworked
- For most components, `State`'s have been removed. Use `disabled` modifier instead.
- `VTextField` now support native `focusable()` API
- `VTextFieldHighlight` has been removed in favor of custom `VTextFieldModels`'s
- `warning` highlight has been added to `VTextFieldModel`
- Buttons—`VChevronButton` and `VCloseButton`—have been removed
- `VBaseTextField` has been removed, as it's obsoleted by native `TextField` since SwiftUI `3.0`
- `VList` can now be initialized with constant range and row content
- `VList` and `VSectionList` have been removed
- Navigation components—`VTabNavigationView` and `VNavigationView`—have been removed
- `VBaseView` has been removed
- `StateColors`'s and `StateOpacities`'s have been replaced with`GenericStateModel`'s
- `VMenuPicker`/`Menu` label issue with iOS `15` has been fixed
- Modal component sizes have been fixed in landscape orientation
- `VSquareButton` font has been changed to system bold size 15
- `VPlainButton` font has been changed to system medium size 15
- `VWebLink` has been renamed to `VLink`
- `VBaseList` has been renamed to `VList`
- Generic type `Content` has been renamed to `Label` in button and state pickers as per SwiftUI's guidelines 
- `VPickableItem` has been renamed to `PickableEnumeration`
- `LayoutGroup`'s have been renamed to `EdgeInsets`'s

#### [1.6.0(16)](https://github.com/VakhoKontridze/VComponents/releases/download/1.6.0/VComponents.xcframework.zip) — *2022 01 07*

- Issues with conditional `View` function `if` have been fixed
- `truncatingMode` property has been added to `VText`
- `minimumScaleFactor` property has been added to `VText`
- `showIndicator` properties have been moved from `Misc` to `Layout` in models, and empty `Misc` object have been deprecated
- `oneLine` is now a default parameter in `VText`
- `oneLine` is now a default parameter in `VToast`

#### [1.5.0(15)](https://github.com/VakhoKontridze/VComponents/releases/download/1.5.0/VComponents.xcframework.zip) — *2021 12 24*

- `VBaseButton` API has been updated by implementing `VBaseButtonGestureState`
- Implementation of state-bound components have been updated
- `VCheckBox`, `VRadioButton`, and `VToggle` now support colors for pressed states
- `StateColors_EPDL` has been renamed to `StateColors_EPLD`

#### [1.4.6(14)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.6/VComponents.xcframework.zip) — *2021 12 10*

- Fixed VBaseButton click overriding scroll gesture
- `VPrimaryButton` height has been changed to `56`

#### [1.4.5(13)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.5/VComponents.xcframework.zip) — *2021 11 05*

- `nextState` has been renamed to `setNextState` in component state enums
- Several color group objects and initializers have been renamed

#### [1.4.4(12)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.4/VComponents.xcframework.zip) — *2021 10 28*

- `Resize Indicator` has been renamed to `Grabber` in `VHalfModal`

#### [1.4.3(11)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.3/VComponents.xcframework.zip) — *2021 10 11*

- Bug fixes and improvements

#### [1.4.2(10)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.2/VComponents.xcframework.zip) — *2021 09 02*

- Fixed `continuous` `VSpinner` breaking in `NavigationView` in SwiftUI 3.0

#### [1.4.1(9)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.1/VComponents.xcframework.zip) — *2021 08 29*

- `VLink` has been renamed to `VWebLink`
- `VSectionListRowViewModelable` has been dropped for `Identifiable`
- `intermediate` has been renamed to `indeterminate`
- Layout and color groups used in models can now be initialized as `.zero`, `.clear`, and `.solid`

#### [1.4.0(8)](https://github.com/VakhoKontridze/VComponents/releases/download/1.4.0/VComponents.xcframework.zip) — *2021 08 26*

- Navigation can now occur using `vNavigationLink` extension
- Divider margins can now be changed in `VBaseList`, `VList`, `VSectionList`, and `VAccordion` via models
- Default divider color in `VNavigationView` has changed from `ColorBook.clear` to gray
- Default title alignment has changed in `VBaseView` from leading to center
- `VSectionListRow` has been renamed to `VSectionListRowViewModelable`
- `VSectionListSection` has been renamed to `VSectionListSectionViewModelable`

#### [1.3.1(7)](https://github.com/VakhoKontridze/VComponents/releases/download/1.1.1/VComponents.xcframework.zip) — *2021 02 27*

- Issue with `VBaseTextField` and `VTextField` calling onChange handler one keystroke behind has been fixed

#### [1.3.0(6)](https://github.com/VakhoKontridze/VComponents/releases/download/1.3.0/VComponents.xcframework.zip) — *2021 02 16*

- Autocapitalization has been added to input components

#### [1.2.1(5)](https://github.com/VakhoKontridze/VComponents/releases/download/1.2.1/VComponents.xcframework.zip) — *2021 02 14*

- `VHalfModal` navigation bar close button layout has been fixed

#### [1.2.0(4)](https://github.com/VakhoKontridze/VComponents/releases/download/1.2.0/VComponents.xcframework.zip) — *2021 02 12*

- `VSection` has been renamed to `VList`
- `VTable` has been renamed to `VSectionList`
- `VLazyList` has been renamed to `VLazyScrollView`

#### [1.1.1(3)](https://github.com/VakhoKontridze/VComponents/releases/download/1.1.1/VComponents.xcframework.zip) — *2021 02 10*

- Bug fixes and improvements

#### [1.1.0(2)](https://github.com/VakhoKontridze/VComponents/releases/download/1.1.0/VComponents.xcframework.zip) — *2021 02 09*

- Documentation on public declarations, methods, and properties have been added

#### [1.0.0(1)](https://github.com/VakhoKontridze/VComponents/releases/download/1.0.0/VComponents.xcframework.zip) — *2021 02 07*

- Initial release
