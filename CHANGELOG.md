# Change Log

#### [2.0.0(17)]

General

- Project is migrated from `XCFramework` to `Swift Package`
- Project now partially supports `macOS`, `tvOS`, and `watchOS`
- Components are reworked
- Colors have been reworked
- Button, state, and value picker components' state enums are removed, and `disabled` modifier can be used instead
- Generic type `Content` is renamed to `Label` in button and state pickers as per `SwiftUI`'s guidelines
- `ImageBook` is made public, and asset icons in library can no be re-set
- `VComponentsLocalizationService` is added, that supports localization within the package
- Several internal properties are now exposed to public in models

VPrimaryButton

- Button loader size is changed from `10` to `15`

VSquareButton

- Button font is changed to `system bold` size `15`

VPlainButton

- Button font is changed to `system medium` size `15`

VChevronButton

- Button is removed in favor of more general `VSquareButton` 

VCloseButton

- Button is removed in favor of more general `VSquareButton`

VWebLink

- `VWebLink` is renamed to `VLink`

VToggle

- `titleLabelLineLimit` is added to `VToggleModel`

VCheckBox

- `titleLabelLineLimit` is added to `VCHeckBoxModel`

VRadioButton

- `titleLabelLineLimit` is added to `VRadioButtonModel`

VSegmentedPicker

- `headerLineLimit` and `footerLineLimit` are added to `VSegmentedPickerModel`

VMenuPicker

- Label issue with `iOS` `15` is fixed

VWheelPicker

- `headerLineLimit` and `footerLineLimit` are added to `VWheelPicker`

VBaseTextField

- TextField is obsoleted by native `TextField` since SwiftUI `3.0`, and is removed

VTextField

- TextField now support native `focusable()` API
- `VTextFieldHighlight` is removed in favor of custom `VTextFieldModel`'s
- TextField Height is changed from `50` to `45`
- TextField corner radius is changed from `10` to `12`
- Placeholder font is changed to `system` size `16`
- `warning` highlight is added to `VTextFieldModel`
- `headerLineLimit` and `footerLineLimit` are added to `VTextFieldModel`

VSheet

- Sheet margins are changed from `10` to `15`

VAccordion

- `VAccordion` is renamed to `VDisclosureGroup`
- DisclosureGroup margins are changed from `10` to `15`

VBaseList

- `VBaseList` is renamed to `VList`
- List can now be initialized with constant range and row content

VList

- List is removed in favor of `VBaseList` (now `VList`) and `VSheet`

VSectionList

- List is removed in favor of `VBaseList` (now `VList`) and `VSheet`

VTabNavigationView

- TabNavigationView is removed

VNavigationView

- NavigationView is removed

VModal

- Modal now supports landscape mode
- `headerAlignment` is added to `VModalModel`
- Modal margins are changed from `10` to `15`
- Modal now has option for adding shadow

VHalfModal

- `VHalfModal` is renamed to `VBottomSheet`
- BottomSheet now supports landscape mode
- `headerAlignment` is added to `VBottomSheetModel`
- BottomSheet can now be snapped to height by dragging it at high velocities
- BottomSheet now supports content autoresizing
- BottomSheet height has changed to `0.6`, `0.6`, and `0.9` ratios of screen height as min, ideal, and max heights
- BottomSheet margins are changed from `10` to `15` 
- BottomSheet now has option for adding shadow
- Issue with modal snapping to max height if dragged to min when `pullDown` dismiss type is not enabled is fixed

VSideBar

- SideBar now supports landscape mode
- SideBar margins are changed from `10` to `15`
- SideBar now has option for adding shadow

VDialog

- `VDialog` is renamed to `VAlert`
- Alert now supports landscape mode
- Alert can now be created with `Error`
- Alert now has option for adding shadow

VActionSheet

- `VActionSheet` is renamed to `VConfirmationDialog`

VMenu

- Label issue with `iOS` `15` is fixed

VToast

- `VToastType` `oneLine` is renamed to `singleLine`

VBaseView

- View is removed as it offers no additional customization

VText

- `VTextType` `oneLine` is renamed to `singleLine`

Other

- `StateColors`'s and `StateOpacities`'s are replaced with`GenericStateModel`'s
- `LayoutGroup`'s is renamed to `EdgeInsets`'s
- `VPickableItem` is renamed to `PickableEnumeration`

#### [1.6.0(16)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.6.0) — *2022 01 07*

General

- `showIndicator` property is moved from `Misc` to `Layout` in the models, and empty `Misc` objects are deprecated

VToast

- `oneLine` is now a default parameter in the initializer

VText

- `oneLine` is now a default parameter in the initializer
- `truncatingMode` property is added to `VTextModel`
- `minimumScaleFactor` property is added to `VTextModel`

Extensions

- Issues with conditional `View` function `if` are fixed

#### [1.5.0(15)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.5.0) — *2021 12 24*

VBaseButton

- `VBaseButton` API is updated by implementing `VBaseButtonGestureState`
- Implementation of state-bound components is also updated

VCheckBox

- Component now supports colors for pressed state in `VCheckBoxModel`

VRadioButton

- Component now supports colors for pressed state in `VRadioButtonModl`

VToggle

- Component now supports colors for pressed state in `VToggleModel`

Other

- `StateColors_EPDL` is renamed to `StateColors_EPLD`

#### [1.4.6(14)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.6) — *2021 12 10*

VBaseButton

- Clicks overriding scroll gesture is fixed

VPrimaryButton

- Button height is changed to `56`

#### [1.4.5(13)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.5) — *2021 11 05*

General

- `nextState` is renamed to `setNextState` in state-bound component states

Other

- Several color group objects and their parameters are renamed

#### [1.4.4(12)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.4) — *2021 10 28*

VHalfModal

- `Resize Indicator` is renamed to `Grabber`

#### [1.4.3(11)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.3) — *2021 10 11*

Bug fixes and improvements

#### [1.4.2(10)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.2) — *2021 09 02*

VSpinner

- Issue with `continuous` spinner breaking in `NavigationView` in `SwiftUI` `3.0` is fixed

#### [1.4.1(9)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.1) — *2021 08 29*

VCheckBox

- `intermediate` is renamed to `indeterminate`

VLink

- `VLink` is renamed to `VWebLink`

VSectionList
- `VSectionListRowViewModelable` is deprecated in favor of `Identifiable`

Other

- Layout and color groups used in models can now be initialized as `.zero`, `.clear`, and `.solid`

#### [1.4.0(8)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.0) — *2021 08 26*

VNavigationLink

- Navigation can now occur using `vNavigationLink` `View` extension

VBaseList

- Divider margins are added to `VBaseListModel`

VList

- Divider margins are added to `VListModel`

VSectionList

- Divider margins are added to `VSectionListModel`
- `VSectionListRow` is renamed to `VSectionListRowViewModelable`
- `VSectionListSection` is renamed to `VSectionListSectionViewModelable`

VAccordion

- Divider margins are added to `VAccordionModel`

VNavigationView

- Default divider color is changed from `ColorBook.clear` to gray

VBaseView

- Default title alignment is changed from `leading` to `center`

#### [1.3.1(7)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.1) — *2021 02 27*

VBaseTextField

- TextField calling `onChange` handler one keystroke behind is fixed

VTextField

- TextField calling `onChange` handler one keystroke behind is fixed

#### [1.3.0(6)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.3.0) — *2021 02 16*

VBaseTextField

- `autocapitalization` is added to `VBaseTextFieldModel`

VTextField

- `autocapitalization` is added to `VTextFieldModel`

#### [1.2.1(5)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.2.1) — *2021 02 14*

VHalfModal

- Close button layout when embedded inside `VNavigationView` is fixed

#### [1.2.0(4)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.2.0) — *2021 02 12*

VSection

- `VSection` is renamed to `VList`

VTable

- `VTable` is renamed to `VSectionList`

VLazyList

- `VLazyList` is renamed to `VLazyScrollView`

#### [1.1.1(3)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.1) — *2021 02 10*

Bug fixes and improvements

#### [1.1.0(2)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.0) — *2021 02 09*

General

- Documentation on public declarations, methods, and properties are added

#### [1.0.0(1)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.0.0) — *2021 02 07*

Initial release
