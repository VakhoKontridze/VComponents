//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Stretched Button
extension VStretchedButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VStretchedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            action: action,
            title: title,
            icon: icon
        )
    }
}

extension VStretchedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Loading Stretched Button
extension VLoadingStretchedButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            isLoading: isLoading,
            action: action,
            title: title,
            icon: icon
        )
    }
}

extension VLoadingStretchedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Wrapped Button
extension VWrappedButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VWrappedButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            action: action,
            title: title,
            icon: icon
        )
    }
}

extension VWrappedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Rectangular Caption Button
extension VRectangularCaptionButton {
    @available(*, deprecated, message: "Use `init` with reversed `iconCaption` and `titleCaption` parameter order")
    public init(
        uiModel: VRectangularCaptionButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        iconCaption: Image,
        titleCaption: String
    )
        where CaptionLabel == Never
    {
        self.init(
            uiModel: uiModel,
            action: action,
            icon: icon,
            titleCaption: titleCaption,
            iconCaption: iconCaption
        )
    }
}

extension VRectangularCaptionButtonUIModel {
    @available(*, deprecated, renamed: "titleCaptionTextAndIconCaptionSpacing")
    public var iconCaptionAndTitleCaptionTextSpacing: CGFloat {
        get { titleCaptionTextAndIconCaptionSpacing }
        set { titleCaptionTextAndIconCaptionSpacing = newValue }
    }
}

// MARK: - V Plain Button
extension VPlainButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            action: action,
            title: title,
            icon: icon
        )
    }
}

extension VPlainButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Check Mark
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VCheckBoxUIModel {
    @available(*, deprecated, renamed: "checkmarkIconColors")
    public var checkmarkColors: StateColors {
        get { checkmarkIconColors }
        set { checkmarkIconColors = newValue }
    }
}

// MARK: - V Stretched Toggle Button
extension VStretchedToggleButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VStretchedToggleButtonUIModel = .init(),
        state: Binding<VStretchedToggleButtonState>,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            state: state,
            title: title,
            icon: icon
        )
    }
}

extension VStretchedToggleButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Wrapped Toggle Button
extension VWrappedToggleButton {
    @available(*, deprecated, message: "Use `init` with reversed `icon` and `title` parameter order")
    public init(
        uiModel: VWrappedToggleButtonUIModel = .init(),
        state: Binding<VWrappedToggleButtonState>,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.init(
            uiModel: uiModel,
            state: state,
            title: title,
            icon: icon
        )
    }
}

extension VWrappedToggleButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Rectangular Toggle Button
extension VRectangularToggleButtonUIModel {
    @available(*, unavailable)
    public var iconAndTitleTextSpacing: CGFloat { fatalError() }
}

// MARK: - V Side Bar
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}

// MARK: - V Bottom Sheet
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}

// MARK: - V Menu
@available(*, unavailable)
public struct VMenu {}

@available(*, unavailable)
public struct VMenuRow {}

@available(*, unavailable)
public struct VMenuExpandingRow {}

@available(*, unavailable)
public struct VMenuPickerRow {}

@available(*, unavailable)
@resultBuilder public struct VMenuGroupRowBuilder {
    public static func buildBlock() -> [any VMenuGroupRowProtocol] {
        []
    }
}

@available(*, unavailable)
public protocol VMenuGroupRowConvertible {}

@available(*, unavailable)
public protocol VMenuPickerRowConvertible {}

@available(*, unavailable)
public protocol VMenuGroupRowProtocol {}

@available(*, unavailable)
public protocol VMenuPickerRowProtocol {}

@available(*, unavailable)
public struct VMenuGroupSection {}

@available(*, unavailable)
public struct VMenuPickerSection {}

@available(*, unavailable)
@resultBuilder public struct VMenuSectionBuilder {
    public static func buildBlock() -> [any VMenuSectionProtocol] {
        []
    }
}

@available(*, unavailable)
public protocol VMenuSectionConvertible {}

@available(*, unavailable)
public protocol VMenuSectionProtocol {}

@available(*, unavailable)
public struct VMenuInternalState {}

@available(*, unavailable)
public struct VMenuUIModel {}

// MARK: - V Context Menu
extension View {
    @available(*, unavailable)
    public func vContextMenu(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) -> some View {
        Color.clear
    }

    @available(*, unavailable)
    public func vContextMenu<PreviewContent>(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol],
        preview: () -> PreviewContent
    ) -> some View
        where PreviewContent: View
    {
        Color.clear
    }
}

// MARK: - V Alert
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertUIModel {
    @available(*, deprecated, renamed: "primaryButtonTitleTextColors")
    public var primaryButtonTitleColors: ButtonStateColors {
        get { primaryButtonTitleTextColors }
        set { primaryButtonTitleTextColors = newValue }
    }

    @available(*, deprecated, renamed: "secondaryButtonTitleTextColors")
    public var secondaryButtonTitleColors: ButtonStateColors {
        get { secondaryButtonTitleTextColors }
        set { secondaryButtonTitleTextColors = newValue }
    }

    @available(*, deprecated, renamed: "destructiveButtonTitleTextColors")
    public var destructiveButtonTitleColors: ButtonStateColors {
        get { destructiveButtonTitleTextColors }
        set { destructiveButtonTitleTextColors = newValue }
    }
}
