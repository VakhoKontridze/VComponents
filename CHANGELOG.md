# Change Log

### 3.1.0(28)

VPageIndicator

- `axis` is added to UI models that support vertical layout
- `VPageIndicatorUIModel` is split into 3 subsequent UI models representing each type

VMarquee

- Marquee container is added, that auto-scrolls it's content

API

`VComponentsLocalizationService` is renamed to `VComponentsLocalizationManager`

### [3.0.0(27)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.0.0) — *2022 10 02*

General

- `PresentationHost` API is updated, and all modals now have id-based `View` extension methods
- `PresentationHostViewController` is no longer `public`

VPrimaryButton

- Corner radius is changed from `20` to `16`.
- `titleMinimumScaleFactor` is added in `VPrimaryButtonUIModel`

VSecondaryButton

- `titleMinimumScaleFactor` is added in `VSecondaryButtonUIModel`

VSquareButton

- `VSquareButton` is renamed to `VRoundedButton`
- `titleMinimumScaleFactor` is added in `VRoundedButtonUIModel`

VRoundedLabeledButton

- New button type is added

VPlainButton

- `titleMinimumScaleFactor` is added in `VPlainButtonUIModel`

VNavigationLink

- Component is removed, as Package migrates to `NavigationStack`-based programatic navigation

VLink

- Component is removed, to support more UI customization with simple `UIApplication.shared.open(:)` 

VToggle

- `titleLineLimit` is replaced with `titleLineType` in `VToggleUIModel`
- `titleMinimumScaleFactor` is added in `VToggleUIModel`

VCheckBox

- `titleLineLimit` is replaced with `titleLineType` in `VCheckBoxUIModel`
- `titleMinimumScaleFactor` is added in `VCheckBoxUIModel`

VRadioButton

- `titleLineLimit` is replaced with `titleLineType` in `VRadioButtonUIModel`
- `titleMinimumScaleFactor` is added in `VRadioButtonUIModel`

VSegmentedPicker

- `headerLineLimit` is replaced with `headerTitleLineType` is `VSegmentedPickerUIModel`
- `footerLineLimit` is replaced with `footerTitleLineType` is `VSegmentedPickerUIModel`
- `titleMinimumScaleFactor` is added in `VSegmentedPickerUIModel`
- Header and footer color mismatched when disabled is fixed

VWheelPicker

- `headerLineLimit` is replaced with `headerTitleLineType` is `VWheelPickerUIModel`
- `footerLineLimit` is replaced with `footerTitleLineType` is `VWheelPickerUIModel`
- `titleMinimumScaleFactor` is added in `VWheelPickerUIModel`
- Header and footer color mismatched when disabled is fixed

VMenuPicker

- MenuPicker is deprecated. Use `VMenu` with `VMenuPickerSection`.

VTextField

- TextField Height is changed from `45` to `50`
- `placeholder` color is added to `VTextFieldUIModel`
- `headerLineLimit` is replaced with `headerTitleLineType` is `VTextFieldUIModel`
- `footerLineLimit` is replaced with `footerTitleLineType` is `VTextFieldUIModel`
- Header and footer color mismatched when disabled is fixed

VTextView

- TextView component is added

VDisclosureGroup

- Chevron icon direction is now right for collapsed state, and down for expanded
- `contentMargins` are changed from `15`s to `zero` in `VDisclosureGroupUIModel`. This configuration supports list with already-padded rows. But in case of non-list content, additional padding must be used.
- `VDisclosureGroupUIModel.insettedContent` is added
- Issue with corner radius messing layout when content margin is `zero` is fixed

VLazyScrollView

- List is removed for more versatile `VListRow`-based API

VList

- List is removed for more versatile `VListRow`-based API

VStaticList

- List is removed for more versatile `VListRow`-based API

VModal

- Modal header title now can be changed via `vModalHeaderTitle(_:)` and `vModalHeaderLabel(_:)`
- `contentMargins` are changed from `15`s to `zero` in `VModalUIModel`. This configuration supports list with already-padded rows. But in case of non-list content, additional padding must be used.
- `VModalUIModel.insettedContent` is added
- `VModalUIModel.noHeaderLabel` is added
- `headerSafeAreaEdges` is added to `VModalUIModel` that can be used for full-sized modal

VBottomSheet

- BottomSheet header title now can be changed via `vBottomSheetHeaderTitle(_:)` and `vBottomSheetHeaderLabel(_:)`
- `contentMargins` are changed from `15`s to `zero` in `VBottomSheetUIModel`. This configuration supports list with already-padded rows. But in case of non-list content, additional padding must be used.
- `VBottomSheetUIModel.insettedContent` is added
- `VBottomSheetUIModel.scrollableContent` is added
- `VBottomSheetUIModel.noHeaderLabel` is added
- `VBottomSheetUIModel.scrollableContentNoHeaderLabel` is added
- `VBottomSheetUIModel.fullSizedContent` is added
- `headerSafeAreaEdges` is added to `VBottomSheetUIModel` that can be used for full-sized modal
- Issue with content clipping outside container with big corner radius is fixed
- Issue with content not stretching to full height when grabber, header, and divider are all hidden if fixed
- `isContentDraggable` is renamed to `contentIsDraggable` in `VBottomSheetUIModel`

VSideBar

- `contentMargins` are changed from `15`s to `zero` in `VSideBarUIModel`. This configuration supports list with already-padded rows. But in case of non-list content, additional padding must be used.
- `VSideBarUIModel.insettedContent` is added

VAlert

- Alert now builds actions using `resultBuilder`
- `VAlertPresentable` is added in style of `AlertPresentable` from `VCore`

VConfirmationDialog

- ConfirmationDialog now builds actions using `resultBuilder`
- ConfirmationDialog API is updated to match `VAlert`
- `VConfirmationDialogPresentable` is added in style of `ConfirmationDialogPresentable` from `VCore`

VMenu

- Menu now support multiple section
- Menu now builds sections and rows using `resultBuilder`
- Menu now supports picker section, transferred from `VMenuPicker`

VContextMenu

- ContextMenu now support multiple section
- ContextMenu now builds sections and rows using `resultBuilder`
- ContextMenu now supports picker section, transferred from `VMenuPicker`

VToast

- `VToastType` is renamed to `VToastTextLineType`

VSpinner

- `VSpinnerPresentable` is added in style of `ProgressViewPresentable` from `VCore`

VText

- `VTextType` is renamed to `TextLineType`

Other

- `PickableEnumeration` is renamed to `HashableEnumeration`
- `PickableTitledEnumeration` is renamed to `StringRepresentableHashableEnumeration`
- `HashableEnumeration` and `CustomStringConvertibleHashableEnumeration` are moved to `VCore`
- `GenericState`s and `GenericStateModels`s are moved to `VCore`
- `BasicAnimation` is moved to `VCore`
- pressed and disabled `Color`s in `ColorBook` are updated, to be `0.3` opacity of original reference `Color`s

### [2.3.4(26)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.4) — *2022 07 04*

General

- Bug fixes and improvements

### [2.3.3(25)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.3) — *2022 07 04*

Models

- `EdgeInsets`s are renamed to full names from `VCore`

### [2.3.2(24)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.2) — *2022 07 04*

Other

- `VCore` is updated to the latest version

### [2.3.1(23)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.1) — *2022 07 04*

General

- Divider and separators are now scaled to screen sizes

VModal

- Issue with content clipping outside border, when margins are zero, is fixed

### [2.3.0(22)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.0) — *2022 06 27*

VSideBar

- SideBar now supports presentation from all four edges
- Issue with buttons, nested inside `ScrollView`, not registering clicks is fixed

### [2.2.0(21)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.2.0) — *2022 06 25*

VBaseButton

- Button is deprecated, use `SwiftUIBaseButton` from `VCore`

VTextField

- Issue with keyboard dismissing after changing the secure status is fixed

VList

- `VListLayoutType` is deprecated. Old `VList` now supports flexible layout, and new `VStaticList` is added for fixed layout.
- Last separator is now visible by default
- Separator has been added before the first row, which is visible by default

VStaticList

- New list component is added that has a fixed layout

VContextMenu

- ContextMenu component is added

### [2.1.2(20)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.1.2) — *2022 06 20*

General

- `Model` objects are renamed to `UIModel`s

### [2.1.1(19)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.1.1) — *2022 06 17*

Other

- Missing demo app `.xcodeproj` file is now tracked

### [2.1.0(18)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.1.0) — *2022 06 15*

VSlider

- `roundsProgressViewRightEdge` is added to `VSliderModel` to round progress view
- Progress view is now rounded by default

VProgressBar

- `roundsProgressViewRightEdge` is added to `VProgressBar` to round progress view
- Progress view is now rounded by default

Other

- `ModalSizes` and `ModalSizes.SizeConfiguration` now conform to `Equatable, `Hashable`, and `Comparable`
- `asSwiftUIAnimation` is renamed to `toSwiftUIAnimation` in `BasicAnimation`

### [2.0.0(17)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.0.0) — *2022 05 26*

General

- Project is migrated from `XCFramework` to `Swift` Package
- Project now partially supports `macOS`, `tvOS`, and `watchOS`
- Components are reworked
- Colors have been reworked
- Button, state, and value picker components' state enums are removed, and `disabled` modifier can be used instead
- Generic type `Content` is renamed to `Label` in button and state pickers as per `SwiftUI`'s guidelines
- `ImageBook` is made public, and asset icons in library can no be re-set
- Several internal properties are now exposed to public in models
- `blinder` is renamed to `dimmingView`

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

- `titleLineLimit` is added to `VToggleModel`

VCheckBox

- `titleLineLimit` is added to `VCHeckBoxModel`

VRadioButton

- `titleLineLimit` is added to `VRadioButtonModel`

VSegmentedPicker

- `headerLineLimit` and `footerLineLimit` are added to `VSegmentedPickerModel`

VMenuPicker

- Label issue with `iOS` `15` is fixed

VWheelPicker

- `headerLineLimit` and `footerLineLimit` are added to `VWheelPicker`

VRangeSlider

- RangeSlider would now crash if invalid height parameters are used

VBaseTextField

- TextField is obsoleted by native `TextField` since SwiftUI `3.0`, and is removed

VTextField

- TextField now support native `focusable()` API
- `VTextFieldHighlight` is removed in favor of custom `VTextFieldModel`s
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

- Modal is migrated to new `SwiftUI` `3.0` API
- Modal now supports landscape mode
- `headerAlignment` is added to `VModalModel`
- Modal margins are changed from `10` to `15`
- Modal now has option for adding shadow

VHalfModal

- `VHalfModal` is renamed to `VBottomSheet
- BottomSheet is migrated to new `SwiftUI` `3.0` API`
- BottomSheet now supports landscape mode
- `headerAlignment` is added to `VBottomSheetModel`
- BottomSheet can now be snapped to height by dragging it at high velocities
- BottomSheet now supports content autoresizing
- BottomSheet height has changed to `0.6`, `0.6`, and `0.9` ratios of screen height as min, ideal, and max heights
- BottomSheet margins are changed from `10` to `15` 
- BottomSheet now has option for adding shadow
- Issue with modal snapping to max height if dragged to min when `pullDown` dismiss type is not enabled is fixed
- BottomSheet would now crash if invalid height parameters are used

VSideBar

- SideBar is migrated to new `SwiftUI` `3.0` API`
- SideBar now supports landscape mode
- SideBar margins are changed from `10` to `15`
- SideBar now has option for adding shadow

VDialog

- `VDialog` is renamed to `VAlert`
- Alert is migrated to new `SwiftUI` `3.0` API`
- Alert now supports landscape mode
- Alert can now be created with `Error`
- Alert now has option for adding shadow
- `description` is renamed to `message`

VActionSheet

- `VActionSheet` is renamed to `VConfirmationDialog`
- ConfirmationDialog is migrated to new `SwiftUI` `3.0` API`
- `description` is renamed to `message`

VMenu

- Label issue with `iOS` `15` is fixed

VToast

- Toast is migrated to new `SwiftUI` `3.0` API`
- `rounded` `VToast.Layout.CornerRadiusType` is renamed to `capsule`
- `custom` `VToast.Layout.CornerRadiusType` is renamed to `rounded`
- `VToastType` `oneLine` is renamed to `singleLine`

VPageIndicator

- PageIndicator would now crash if invalid height parameters are used

VBaseView

- View is removed as it offers no additional customization

VText

- `VTextType` `oneLine` is renamed to `singleLine`

Other

- `StateColors`s and `StateOpacities`s are replaced with`GenericStateModel`s
- `LayoutGroup`s are renamed to `EdgeInsets`s
- `VPickableItem` is renamed to `PickableEnumeration`

API

- `VComponentsLocalizationService` is added, that supports localization within the Package

### [1.6.0(16)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.6.0) — *2022 01 07*

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

### [1.5.0(15)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.5.0) — *2021 12 24*

VBaseButton

- `VBaseButton` API is updated by implementing `VBaseButtonGestureState`
- Implementation of state-bound components is also updated

VCheckBox

- Component now supports colors for pressed state in `VCheckBoxModel`

VRadioButton

- Component now supports colors for pressed state in `VRadioButtonModel`

VToggle

- Component now supports colors for pressed state in `VToggleModel`

Other

- `StateColors_EPDL` is renamed to `StateColors_EPLD`

### [1.4.6(14)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.6) — *2021 12 10*

VBaseButton

- Clicks overriding scroll gesture is fixed

VPrimaryButton

- Button height is changed to `56`

### [1.4.5(13)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.5) — *2021 11 05*

General

- `nextState` is renamed to `setNextState` in state-bound component states

Other

- Several color group objects and their parameters are renamed

### [1.4.4(12)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.4) — *2021 10 28*

VHalfModal

- `Resize Indicator` is renamed to `Grabber`

### [1.4.3(11)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.3) — *2021 10 11*

Bug fixes and improvements

### [1.4.2(10)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.2) — *2021 09 02*

VSpinner

- Issue with `continuous` spinner breaking in `NavigationView` in `SwiftUI` `3.0` is fixed

### [1.4.1(9)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.1) — *2021 08 29*

VCheckBox

- `intermediate` is renamed to `indeterminate`

VLink

- `VLink` is renamed to `VWebLink`

VSectionList
- `VSectionListRowViewModelable` is deprecated in favor of `Identifiable`

Other

- Layout and color groups used in models can now be initialized as `.zero`, `.clear`, and `.solid`

### [1.4.0(8)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.4.0) — *2021 08 26*

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

### [1.3.1(7)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.1) — *2021 02 27*

VBaseTextField

- TextField calling `onChange` handler one keystroke behind is fixed

VTextField

- TextField calling `onChange` handler one keystroke behind is fixed

### [1.3.0(6)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.3.0) — *2021 02 16*

VBaseTextField

- `autocapitalization` is added to `VBaseTextFieldModel`

VTextField

- `autocapitalization` is added to `VTextFieldModel`

### [1.2.1(5)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.2.1) — *2021 02 14*

VHalfModal

- Close button layout when embedded inside `VNavigationView` is fixed

### [1.2.0(4)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.2.0) — *2021 02 12*

VSection

- `VSection` is renamed to `VList`

VTable

- `VTable` is renamed to `VSectionList`

VLazyList

- `VLazyList` is renamed to `VLazyScrollView`

### [1.1.1(3)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.1) — *2021 02 10*

Bug fixes and improvements

### [1.1.0(2)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.1.0) — *2021 02 09*

General

- Documentation on public declarations, methods, and properties are added

### [1.0.0(1)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.0.0) — *2021 02 07*

Initial release
