# Change Log

### 7.0.0(69)

General

- Minimum SDK version is increased to `iOS` `16.0`, `macOS` `13.0`, `tvOS` `16.0`, and `watchOS` `9.0`
- Minimum `Swift` language version is increased to `6.0`
- Previously deprecated symbols are removed
- All border properties are now represented with `PointPixelMeasurement` instead of `CGFloat`
- All `Font` properties now have `DynamicTypeSizeType` properties in UI models

VGroupBox

- GroupBox now has border configuration
- `roundedCorners` and `cornerRadius` are replaced with `cornerRadii`

VDisclosureGroup

- DisclosureGroup now has border configuration
- `cornerRadius` is replaced with `cornerRadii` and `reversesHorizontalCornersForRTLLanguages`

VCarousel

- A new component is added, that paginates between child views horizontally

VModal

- Presentation API is overhauled
- Size API is extended
- Modal now supports `macOS`, `tvOS`, and `visionOS`
- Modal now has border configuration
- Modal no longer requires `ColorScheme` as parameter when it's overridden in the root
- `roundedCorners` and `cornerRadius` are replaced with `cornerRadii`

VBottomSheet

- Presentation API is overhauled
- BottomSheet now supports `macOS`
- Modal no longer requires `ColorScheme` as parameter when it's overridden in the root

VSideBar

- Presentation API is overhauled
- Size API is extended
- SideBar now supports `macOS`
- Modal no longer requires `ColorScheme` as parameter when it's overridden in the root
- `roundedCorners` and `cornerRadius` are replaced with `cornerRadii`

VAlert

- Presentation API is overhauled
- Width API is extended
- Alert now supports `macOS`
- `buttonTitleTextFont` is added in UI model
- Alert now has border configuration
- Modal no longer requires `ColorScheme` as parameter when it's overridden in the root
- `roundedCorners` and `cornerRadius` are replaced with `cornerRadii`

VNotification

- A new component is added, that presents notification modally

VToast

- Presentation API is overhauled
- Width API is extended
- Toast now supports separate width configurations for portrait and landscape modes
- Toast now has border configuration
- Toast can now be dismissed with swipe
- Toast now has `info` highlight
- Modal no longer requires `ColorScheme` as parameter when it's overridden in the root

VDashedSpinner

- Spinner is removed

### [6.0.8(68)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.8) — *2024 08 02*

Other

- Build issue caused by unsafe flags in `Swift` settings is fixed

### [6.0.7(67)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.7) — *2024 07 09*

Other

- Compilation time bottlenecks are fixed

### [6.0.6(66)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.6) — *2024 06 06*

Other

- Bug fixes and improvements

### [6.0.5(65)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.5) — *2024 06 02*

VSlider

- Crash that sometimes occurs when width is `0` is fixed

VRangeSlider

- Crash that sometimes occurs when width is `0` is fixed

VStretchedIndicatorStaticPagerTabView

- Crash that occurs when data is empty is fixed

VWrappedIndicatorStaticPagerTabView

- Crash that occurs when data is empty is fixed

### [6.0.4(64)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.4) — *2024 05 23*

Other

- Bug fixes and improvements

### [6.0.3(63)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.3) — *2024 04 22*

VTappableText

- TappableText is deprecated in favor of combination of `AttributedString.init(stringAndDefault:attributeContainers:)` and `View.addOpenURLAction(_:)`

### [6.0.2(62)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.2) — *2024 03 09*

VWrappingMarquee

- Runtime warning caused by invalid gradient when content size is zero is fixed

VBouncingMarquee

- Runtime warning caused by invalid gradient when content size is zero is fixed

### [6.0.1(61)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.1) — *2024 03 07*

General

- Minimum `Swift` language version is increased to `5.10`

VTextField

- Clear button will no longer occupy space when TextField is configured with `secure` content type
- Clear and visibility buttons have better hit detection, preventing touches from accidentally focusing the TextField

### [6.0.0(60)](https://github.com/VakhoKontridze/VComponents/releases/tag/6.0.0) — *2024 02 18*

General

- Package now partially supports `visionOS` `1.0`
- Colors are overhauled to better support other platforms
- Previously deprecated symbols are removed

VStretchedButton

- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VLoadingStretchedButton

- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VWrappedButton

- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VRectangularButton

- Button now supports icon `Font` customization when `init` with icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VRectangularCaptionButton

- Button now supports icon `Font` customization when. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.
- Button now supports caption icon `Font` customization when `init` with icon or title and icon is used. `isIconCaptionResizable`, `iconCaptionContentMode`, and `iconCaptionFont` properties are added. Also, `iconCaptionColors`, `iconCaptionOpacities`, and `iconCaptionSize` are made `Optional`.

VPlainButton

- `hitBox` is set to `zero`
- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VToggle

- Toggle now supports `watchOS`
- `thumbDimension` is replaced with `thumbSize`
- `thumbCornerRadius` is added to UI model
- `borderWidth` and `borderColors` properties are added to UI model

VCheckBox

- CheckBox is redesigned for `iOS` with larger, more circular design
- `hitBox` is set to `zero`, and `checkBoxAndLabelSpacing` is set to `5`, as CheckBox now has native extended hit areas
- `dimension` is replaced with `size`
- `bulletDimension` is replaced with `bulletSize`
- `checkmarkIconDimension` is replaced with `checkmarkIconSize`
- `checkmarkIconOpacities` is added to UI model
- CheckBox now supports button icon `Font` customization. `isCheckmarkIconResizable`, `checkmarkIconContentMode`, and `checkmarkIconFont` properties are added. Also, `checkmarkIconColors` and `checkmarkIconSize` are made `Optional`.

VRadioButton

- Radio Button is redesigned for `iOS` with larger design
- `hitBox` is set to `zero`, and `checkBoxAndLabelSpacing` is set to `5`, as CheckBox now has native extended hit areas
- `dimension` is replaced with `size`
- `cornerRadius` and `bulletCornerRadius` are added to UI model

VStretchedToggleButton

- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VWrappedToggleButton

- Toggle button now supports `watchOS`
- Button now supports icon `Font` customization when `init` with icon or title and icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VRectangularToggleButton

- Toggle button now supports `watchOS`
- Button now supports icon `Font` customization when `init` with icon is used. `isIconResizable`, `iconContentMode`, and `iconFont` properties are added. Also, `iconColors`, `iconOpacities`, and `iconSize` are made `Optional`.

VStepper

- Stepper is removed

VSlider

- Track will no longer be padded horizontally
- `thumbDimension` is replaced with `thumbSize`

VRangeSlider

- Track will no longer be padded horizontally
- `thumbDimension` is replaced with `thumbSize`

VTextField

- `searchIconDimension` is replaced with `searchIconSize`
- `searchIconOpacities` is added to UI model
- TextField now supports button icon `Font` customization. `isSearchIconResizable`, `searchIconContentMode`, and `searchIconFont` properties are added. Also, `searchIconColors` and `searchIconSize` are made `Optional`.

VGroupBox

- `backgroundColor` is changed to `UIColor.secondarySystemBackground` on `iOS`. `VGroupBoxUIModel.systemBackgroundColor` can be used to support previous configuration.

VDisclosureGroup

- `backgroundColor` is changed to `UIColor.secondarySystemBackground` on `iOS`. `VDisclosureGroupUIModel.systemBackgroundColor` can be used to support previous configuration.

VModal

- Modal will no longer dismiss from back-tap before it finished presentation animation 

VBottomSheet

- BottomSheet will no longer dismiss from back-tap before it finished presentation animation

VSideBar

- SideBar will no longer dismiss from back-tap before it finished presentation animation

VWrappingMarquee

- `gradientColorContainerEdge` and `gradientColorContentEdge` are replaced with `gradientMaskOpacityContainerEdge` and `gradientMaskOpacityContentEdge` to avoid requiring explicit background colors

VBouncingMarquee

- `gradientColorContainerEdge` and `gradientColorContentEdge` are replaced with `gradientMaskOpacityContainerEdge` and `gradientMaskOpacityContentEdge` to avoid requiring explicit background colors

Other

- `VComponentsColorBook` is no longer exposed to public

### [5.3.1(59)](https://github.com/VakhoKontridze/VComponents/releases/tag/5.3.1) — *2024 01 23*

VTextView

- Issue with minimum height is fixed, and `minHeight` is replaced with `minimumHeight`

### [5.3.0(58)](https://github.com/VakhoKontridze/VComponents/releases/tag/5.3.0) — *2024 01 12*

VBouncingMarquee

- Rendering issue in `iOS` `17.0` is fixed

VCodeEntryView

- `spacing` is replaced with `spacingType` to support stretched layout

### [5.2.0(57)](https://github.com/VakhoKontridze/VComponents/releases/tag/5.2.0) — *2023 12 07*

VStretchedButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VLoadingStretchedButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VWrappedButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VRectangularCaptionButton

- `titleCaptionTextAndIconCaptionPlacement` is added for configuring the placement between title caption text and icon caption

VPlainButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VStretchedToggleButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VWrappedToggleButton

- `titleTextAndIconPlacement` is added for configuring the placement between title text and icon

VListRow

- ListRow is deprecated in favor of more modern `List` API

VFetchingAsyncImage

- A new component is moved from [VCore](https://github.com/VakhoKontridze/VCore), that asynchronously loads and displays an `Image` with a fetch handler

VTappableText

- A new component is added, that inserts tappable components in `Text`

### [5.1.0(56)](https://github.com/VakhoKontridze/VComponents/releases/tag/5.1.0) — *2023 11 11*

VRectangularCaptionButton

- `captionFrameAlignment` is added

VCheckBox

- `hitBox` type is changed from `CGFloat` to `HitBox` 

VSideBar

- `defaultContentSafeAreaEdges(interfaceOrientation:)` method is added in UI model that atomically calculates `contentSafeAreaEdges`
- Issue with SideBar dismissing without animation on drag-back is fixed

VTextField

- `headerTitleTextFrameAlignment` and `footerTitleTextFrameAlignment` are added

VTextView

- `headerTitleTextFrameAlignment` and `footerTitleTextFrameAlignment` are added

VCodeEntryView

- Issue with invisible toolbar items is fixed

VAlert

- `titleTextFrameAlignment` and `messageTextFrameAlignment` are added
- `attributes` are added to `VAlertParameters` for additional customization
- `vAlert(...)` method now supports content

VMenu

- Menu is deprecated, until native counterpart is added

VContextMenu

- ContextMenu is deprecated, until native counterpart is added

Helpers - Architectural Pattern Helpers

- `attributes` is added to `VAlertParameters` for additional customization
- `attributes` is added to `VAlertParameters` for additional customization

Other

- Issue with XCode previews in modal components is fixed
- Redundant `Identifiable` conformances are removed

### [5.0.0(55)](https://github.com/VakhoKontridze/VComponents/releases/tag/5.0.0) — *2023 10 08*

General

- Minimum SDK version is increased to `iOS` `15.0`, `macOS` `12.0`, `tvOS` `15.0`, and `watchOS` `8.0`
- Minimum `Swift` language version is increased to `5.9`
- Previously deprecated symbols are removed
- Button components will now register gestures even if the background is clear
- UIModels are re-structured and no longer depend on sub UI models

VStretchedButton

- `init` with icon is added

VLoadingStretchedButton
- `init` with icon is added

VWrappedButton

- Component is renamed to `VWrappedButton`
- `cornerRadius` can now be changed to be anything other than half of height
- `hiBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`
- `init` with icon is added

VRectangularButton

- Component is renamed to `VRectangularButton`
- `hiBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`

VRectangularCaptionButton

- Component is renamed to `VRectangularCaptionButton`
- `iconMargins` that had no effect previously, now apply to icon
- `roundedRectangleSize` is renamed to `rectangleSize`
- `cornerRadius` is renamed to `rectangleCornerRadius`
- `background` is renamed to `rectangleColors`
- `backgroundPressedScale` is renamed to `rectanglePressedScale`
- `borderWidth` is renamed to `rectangleBorderWidth`
- `borderColors` is renamed to `rectangleBorderColors`
- `labelPressedScale` is renamed to `iconPressedScale`
- `init` with icon is added

VPlainButton

- `hiBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`

VCheckBox

- `hiBox` is renamed to `checkBoxHitBox`
- `checkBoxHitBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`

VRadioButton

- `hiBox` is renamed to `radioButtonHitBox`
- `radioButtonHitBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`

VStretchedToggleButton

- A new state-picker component is added that resembles `VStretchedButton`

VWrappedToggleButton

- A new state-picker component is added that resembles `VCapsuleButton`

VRectangularToggleButton

- A new state-picker component is added that resembles `VRectangularButton`

VSegmentedPicker

- `VSegmentedPicker` is removed

VWheelPicker

- `VWheelPicker` is removed

VStepper

- `iconDimension` is renamed to `buttonIconDimension`
- `divider` is renamed to `dividerSize`

VSlider

- `isBodyDraggable` is added, and default value is set to `false` for `iOS`, changing the default behavior of the slider

VTextField

- `headerTitleTextLineType` is changed to `multiline` with `leading` alignment and `1...2` lines
- `headerAndFooterMarginHorizontal` is split to `headerMarginHorizontal` and `footerMarginHorizontal`

VTextView

- `headerTitleTextLineType` is changed to `multiline` with `leading` alignment and `1...2` lines
- `headerAndFooterMarginHorizontal` is split to `headerMarginHorizontal` and `footerMarginHorizontal`
- `contentMargin` is renamed to `contentMargins`

VCodeEntryView

- A new input component is added that allows for the entry of a code, such as PIN

VDisclosureGroup

- Disclosure button angles can now be customized for different states

VStretchedIndicatorStaticPagerTabView

- A new container component is added that presents children in `TabView` with custom header

VWrappedIndicatorStaticPagerTabView

- A new container component is added that presents children in `TabView` with custom header

VDynamicPagerTabView

- A new container component is added that presents children in `TabView` with custom header

VModal

- Keyboard handling is improved
- Size configuration is improved to support fractions and points separately for width and height
- Headers are removed
- `labelAndCloseButtonSpacing` is renamed to `headerLabelAndCloseButtonSpacing`
- `blur` is removed
- Dimming view now detects gestures even when clear

VBottomSheet

- Keyboard handling is improved
- Size configuration is improved to support fractions and points separately for width and heights
- Headers are removed
- `labelAndCloseButtonSpacing` is renamed to `headerLabelAndCloseButtonSpacing`
- Dimming view now detects gestures even when clear

VSideBar

- Keyboard handling is improved
- Size configuration is improved to support fractions and points separately for width and height
- Dimming view now detects gestures even when clear

VAlert

- Size configuration is improved
- `titleTextLineType` is changed to `multiline` with `center` alignment and `1...2` lines
- `blur` is removed
- Dimming view now detects gestures even when clear

VMenu

- `hiBox` is now backed up by `EdgeInsets_LeadingTrailingTopBottom`

VPageIndicator

- API is overhauled to support different widths and heights for deselected and selected dots
- Page indicator now support custom corner radii

VCompactPageIndicator

- Page indicator now support custom corner radii

VAutomaticPageIndicator

- Page indicator is removed due to it being obsoleted by `ViewThatFits`

VRollingCounter

- A new component is added that highlights change in a floating-number

Other

- `ColorBook` is renamed to `VComponentsColorBook` to avoid issues with name-shadowing
- `ColorBook.canvas` is renamed to `ColorBook.secondaryBackground`
- `ColorBook.layer` is renamed to `ColorBook.background`
- `ImageBook` is no longer exposed to `public`, but UI models take icons instead

### [4.3.8(54)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.8) — *2023 09 03*

VPageIndicator

- Backing `Circle` is changed to `Capsule` to support different width and height

VCompactPageIndicator

- Backing `Circle` is changed to `Capsule` to support different width and height

Helpers - Architectural Pattern Helpers

- `VAlertPresentable` is removed
- `VSpinnerPresentable` is removed

### [4.3.7(53)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.7) — *2023 09 01*

VSegmentedPicker

- Issue with indicator position on last row is fixed

### [4.3.6(52)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.6) — *2023 08 06*

VAlert

- Issue of title and message not wrapping to multiple lines is fixed

### [4.3.5(51)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.5) — *2023 08 06*

VToast

- Issue with lifecycle duration not respecting appear animation duration is fixed
- Issue with hidden offset is fixed

### [4.3.4(50)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.4) — *2023 07 17*

Other

- Bug fixes and improvements

### [4.3.3(49)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.3) — *2023 06 10*

VListRow

- Issue with `VListRow.rowEnclosingSeparators(isFirst:)` not inserting first and last separators is fixed

### [4.3.2(48)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.2) — *2023 06 10*

VSegmentedPicker

- Issue with all rows scaling down on press is fixed

### [4.3.1(47)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.1) — *2023 06 07*

VRoundedButton

- `iconSize` is changed to `24x24` on `iOS` and to `26x26` on `watchOS`

### [4.3.0(46)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.3.0) — *2023 05 06*

VStretchedButton

- Component now supports shadows

VLoadingStretchedButton

- Component now supports shadows

VCapsuleButton

- Component now supports shadows

VRoundedButton

- Component now supports shadows

VRoundedCaptionButton

- Component now supports shadows

VPlainButton

- `iconSize` is changed to `24`

VSheet

- Component is renamed to `VGroupBox`

VAlert

- API is overhauled

VConfirmationDialog

- Component is deprecated, and is replaced with `ConfirmationDialog` from [VCore](https://github.com/VakhoKontridze/VCore)

VMenu

- API is overhauled

VContextMenu

- API is overhauled

### [4.2.3(45)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.2.3) — *2023 05 01*

Other

- Issue with large icons going out of bounds in several components is fixed 

### [4.2.2(44)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.2.2) — *2023 05 01*

Other

- Platform-specific compilation errors are fixed

### [4.2.1(43)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.2.1) — *2023 05 01*

VBottomSheet

- BottomSheet now supports `iOS` `14.0`
- Issue with header title not being visible under some conditions is fixed

Other

- Compilation errors are fixed

### [4.2.0(42)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.2.0) — *2023 04 29*

General

- `colorScheme` is added to modal components

VSegmentedPicker

- Picker API is overhauled

VWheelPicker

- Picker API is overhauled

VMenu

- Rows can now be disabled
- Picker API is overhauled

VContextMenu

- Rows can now be disabled

### [4.1.0(41)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.1.0) — *2023 04 21*

VModal

- Modal now supports `iOS` `14.0`
- Issue with screen-sized modal in landscape is fixed

VBottomSheet

- Issue with screen-sized modal in landscape is fixed

VSideBar

- SideBar now supports `iOS` `14.0`
- Issue with screen-sized modal in landscape is fixed

### [4.0.7(40)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.7) — *2023 04 20*

Other

- Issue with button's content overflowing over rounded corners when margins are zero is fixed

### [4.0.6(39)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.6) — *2023 04 15*

VSheet

- Default value of `roundedCorner` is fixed to be `allCorners` again in `VSheetUIModel`

### [4.0.5(38)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.5) — *2023 04 15*

Other

- Issue with `PresentationHost` breaking modal frames when presented from `UIHostingController` is fixed

### [4.0.4(37)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.4) — *2023 04 14*

VBottomSheet

- Issue with positioning of smaller sheets when using fully fixed height is fixed

### [4.0.3(36)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.3) — *2023 04 13*

Other

- Issue of DEBUG imports preventing archiving is fixed 

### [4.0.2(35)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.2) — *2023 04 13*

VBottomSheet

- Issue with positioning when using fully fixed height is fixed

### [4.0.1(34)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.1) — *2023 04 12*

General

- Default haptic value is set to `nil` for most button components - `VCapsuleButton`, `VRoundedButton`, `VRoundedCaptionButton`, and `VPlainButton`

### [4.0.0(33)](https://github.com/VakhoKontridze/VComponents/releases/tag/4.0.0) — *2023 04 09*

General

- Minimum SDK version is decreased to `iOS` `13.0`
- Package now partially supports `macOS` `10.15`, `tvOS` `13.0`, and `watchOS` `6.0`
- Minimum `Swift` language version is increased to `5.8`
- Previously deprecated symbols are removed
- Package now supports RTL languages
- Fonts now support dynamic sizing
- Haptic effects are added to most interactive components
- Buttons that contained `customLabelContent` in UI models now support label APIs that pass internal states to the custom label callback 
- Some colors are changed throughout the package
- "TitleLineType" used in names is changed to "TextLineType"
- Shadow offsets are changed from `CGSize` to `CGPoint`

VStretchedButton

- A new button type is added as a non-loading alternative to `VLoadingStretchedButton`

VPrimaryButton

- `VPrimaryButton` is renamed to `VLoadingStretchedButton`
- `animatesStateChange` is added in `VLoadingStretchedButtonUIModel`
- `backgroundPressedScale` and `labelPressedScale` are added in `VLoadingStretchedButtonUIModel`

VSecondaryButton

- `VSecondaryButton` is renamed to `VCapsuleButton`
- `animatesStateChange` is added in `VCapsuleButtonUIModel`
- `backgroundPressedScale` is added in `VCapsuleButtonUIModel`
- `labelPressedScale` is added in `VCapsuleButtonUIModel`
- `backgroundPressedScale` and `labelPressedScale` are added in `VCapsuleButtonUIModel`

VRoundedButton

- `VRoundedButton` not supports size instead of dimension
- `animatesStateChange` is added in `VRoundedButtonUIModel`
- `backgroundPressedScale` and `labelPressedScale` are added in `VRoundedButtonUIModel`

VRoundedLabeledButton

- `VRoundedLabeledButton` is renamed to `VRoundedCaptionButton`
- `VRoundedCaptionButton` not supports size instead of dimension
- `animatesStateChange` is added in `VRoundedLabeledButtonUIModel`
- `backgroundPressedScale`, `labelPressedScale`, and `captionPressedScale` are added in `VRoundedLabeledButtonUIModel`

VPlainButton

- `animatesStateChange` is added in `VPlainButtonUIModel`
- `labelPressedScale` is added in `VPlainButtonUIModel`

VSegmentedPicker

- `indicatorShadowOffsetX` and `indicatorShadowOffsetY` are replaced with `indicatorShadowOffset` in `VSegmentedPickerUIModel`
- `indicatorShadow.width` is changed from `0` to `1`

VWheelPicker

- `headerMarginHorizontal` is renamed to `HeaderTitleTextAndFooterTitleTextMarginHorizontal` in `VWheelPickerUIModel`

VStepper

- `iconDimension` is changed from `15` to `14`

VSlider

- `direction` is added to `VSliderUIModel` that support omni-directional layout
- `thumbShadowOffset` is added to `VSliderUIModel`
- `borderWidth`, and `border` colors are added in `VSliderUIModel`, that allows for border customization
- Issue with thumb not accounting for slider height is fixed

VRangeSlider

- `direction` is added to `VRangeSliderUIModel` that support omni-directional layout
- `thumbShadowOffset` is added to `VRangeSliderUIModel`
- `borderWidth`, and `border` colors are added in `VRangeSliderUIModel`, that allows for border customization
- Issue with thumb not accounting for slider height is fixed

VBottomSheet

- `VBottomSheetUIModel.noHeaderLabel` is renamed to `VBottomSheetUIModel.onlyGrabber`

VAlert

- `titleLineLimit` is replaced with `titleLineType` in `VAlertUIModel`
- `messageLineLimit` is replaced with `messageLineType` in `VAlertUIModel`

VToast

- `WidthType` is added in `VToastUIModel` that allows for additional customization, such as wrapping, stretching, or applying fixed width
- Highlighted factory instances are added to `VToastUIModel`
- `text` font no longer depends on backing `UIFont`
- Shadow configuration is added to `VToast`, but currently set to clear

VContinuousSpinner

- `borderWidth` is renamed to `thickness` in `VContinuousSpinnerUIModel`

VProgressBar

- `direction` is added to `VProgressBarUIModel` that support omni-directional layout
- `borderWidth`, and `border` colors are added in `VProgressBarUIModel`, that allows for border customization

VPageIndicator

- `dotBorderWidth`, and `dotBorder`/`selectedDotBorder` colors are added in `VPageIndicatorUIModel`, that allows for border customization
- `selectedIndex` is renamed to `current`

VCompactPageIndicator

- `dotBorderWidth`, and `dotBorder`/`selectedDotBorder` colors are added in `VCompactPageIndicatorUIModel`, that allows for border customization
- `selectedIndex` is renamed to `current`

VAutomaticPageIndicator

- `dotBorderWidth`, and `dotBorder`/`selectedDotBorder` colors are added in `VAutomaticPageIndicatorUIModel`, that allows for border customization
- `selectedIndex` is renamed to `current`

Helpers - Architectural Pattern Helpers

- `VAlertUIModel` is moved from `VAlertParameters` to `View.vAlert(id:parameters)`
- `SpinnerType` is removed from `VSpinnerParameters` and is moved to `View.vContinuousSpinner(parameters:)` and `View.vDashedSpinner(parameters:)`

Other

- Demo app is replaced with previews
- `ColorBook.accent` is renamed to `Color.blue`
- `PresentationHost` is moved to [VCore](https://github.com/VakhoKontridze/VCore)

### [3.2.3(32)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.2.3) — *2023 04 09*

Other

- Bug fixes and improvements

### [3.2.2(31)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.2.2) — *2023 04 02*

VSlider

- Issue with tap gesture registering incorrect location is fixed

### [3.2.1(30)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.2.1) — *2023 03 23*

VTextField

- Issue with password visibility icon not being visible is fixed
- Close button animation is set to `nil`
- Issue with keyboard animation affecting close button's offset is fixed

### [3.2.0(29)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.2.0) — *2023 03 09*

VRoundedLabeledButton

- Missing `titleLabelLineType` from `VRoundedLabeledButtonUIModel` is now utilized inside the button

VRadioButton

- Issue with radio button turning off after being tapped is fixed

VTextField

- `VTextFieldType` is renamed to `ContentType` and is moved to `VTextFieldUIModel`

VTextView

- `TextLineLimitType` is removed from `init` and can now be customized via `textLineType` in `VTextViewUIModel`

VList

- `VListRowSeparatorType` is renamed to `SeparatorType` and is moved to `VListRowUIModel`

VModal

- Issue with some content not stretching to full width is fixed

VToast

- `VToastTextLineType` is renamed to `TextLineType` and is moved to `VToastUIModel`

VSpinner

- `VSpinner` is split to `VContinuousSpinner` and `VDashedSpinner`

VPageIndicator

- `VPageIndicator` is split to `VPageIndicator`, `VCompactPageIndicator` and `VAutomaticPageIndicator`

VMarquee

- `VMarquee` is split to `VWrappingMarquee` and `VBouncingMarquee`

Other

- `presentationHost(id:allowsHitTests:isPresented:content:)` method is added that replaces current `PresentationHost` API
- Issue with tap gesture falling through some contents when presenting modal using `PresentationHost` is fixed
- Memory leak caused by `forceDismiss(id:)` method in `PresentationHost` is fixed

### [3.1.0(28)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.1.0) — *2023 03 03*

General

- Various properties inside UI models are replaced with relevant mapped sub UI models for additional customization. For instance, spinner properties inside `VPrimaryButtonUIModel` are replaced with `VPlainButtonUIModel`.

VPrimaryButton

- `animations` model is added to `VPrimaryButtonUIModel` for customizing spinner animations

VPageIndicator

- `direction` is added to `VPageIndicatorUIModel` that support omni-directional layout
- `dot` parameter is added to initializer that supports dot customization
- `VPageIndicatorUIModel` is split into 3 subsequent UI models representing each type
- `VPageIndicatorType.finite` is renamed to `VPageIndicatorType.standard` 
- `VPageIndicatorType.infinite` is renamed to `VPageIndicatorType.compact`

VMarquee

- Marquee container is added that auto-scrolls it's content

API

`VComponentsLocalizationService` is renamed to `VComponentsLocalizationManager`

### [3.0.0(27)](https://github.com/VakhoKontridze/VComponents/releases/tag/3.0.0) — *2022 10 02*

General

- Minimum SDK version is increased to `iOS` `16.0`
- Minimum `Swift` language version is increased to `5.7`
- Previously deprecated symbols are removed

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
- `indicatorPress` is added in `VSegmentedPickerUIModel`
- `rowContentPressedScale` is added in `VSegmentedPickerUIModel`
- Header and footer color mismatched when disabled is fixed
- `title` is renamed to `rowTitle` in `VSegmentedPickerUIModel`

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
- `VAlertPresentable` is added in style of `AlertPresentable` from [VCore](https://github.com/VakhoKontridze/VCore)

VConfirmationDialog

- ConfirmationDialog now builds actions using `resultBuilder`
- ConfirmationDialog API is updated to match `VAlert`
- `VConfirmationDialogPresentable` is added in style of `ConfirmationDialogPresentable` from [VCore](https://github.com/VakhoKontridze/VCore)

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

- `VSpinnerPresentable` is added in style of `ProgressViewPresentable` from [VCore](https://github.com/VakhoKontridze/VCore)

VText

- `VTextType` is renamed to `TextLineType`

Other

- `PresentationHost` API is updated, and all modals now have id-based `View` extension methods
- `PresentationHostViewController` is no longer `public`
- `PickableEnumeration` is renamed to `HashableEnumeration`
- `PickableTitledEnumeration` is renamed to `StringRepresentableHashableEnumeration`
- `HashableEnumeration` and `CustomStringConvertibleHashableEnumeration` are moved to [VCore](https://github.com/VakhoKontridze/VCore)
- `GenericState`s and `GenericStateModels`s are moved to [VCore](https://github.com/VakhoKontridze/VCore)
- `BasicAnimation` is moved to [VCore](https://github.com/VakhoKontridze/VCore)
- `pressed` and `disabled` `Color`s in `ColorBook` are updated, to be `0.3` opacity of original reference `Color`s

### [2.3.4(26)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.4) — *2022 07 04*

Other

- Bug fixes and improvements

### [2.3.3(25)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.3) — *2022 07 04*

Models

- `EdgeInsets`s are renamed to full names from [VCore](https://github.com/VakhoKontridze/VCore)

### [2.3.2(24)](https://github.com/VakhoKontridze/VComponents/releases/tag/2.3.2) — *2022 07 04*

Other

- Bug fixes and improvements

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

- Button is deprecated, use `SwiftUIBaseButton` from [VCore](https://github.com/VakhoKontridze/VCore)

VTextField

- Issue with keyboard dismissing after changing the secure status is fixed

VList

- `VListLayoutType` is deprecated. Old `VList` now supports flexible layout, and new `VStaticList` is added for fixed layout.
- Last separator is now visible by default
- Separator is added before the first row, which is visible by default

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
- Minimum SDK version is increased to `iOS` `15.0`
- Previously deprecated symbols are removed
- Components are reworked
- Colors are reworked
- Button, state, and value picker components' state enums are removed, and `disabled` modifier can be used instead
- Generic type `Content` is renamed to `Label` in button and state pickers as per `SwiftUI`'s guidelines
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

Other

- `ImageBook` is made public, and asset icons in library can no be re-set
- Several internal properties are now exposed to `public` in models

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

### [1.3.1(7)](https://github.com/VakhoKontridze/VComponents/releases/tag/1.3.1) — *2021 02 27*

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
