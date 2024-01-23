//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Stretched Button
@available(tvOS, unavailable)
extension VStretchedButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
extension VStretchedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Loading Stretched Button
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VLoadingStretchedButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VLoadingStretchedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Wrapped Button
@available(tvOS, unavailable)
extension VWrappedButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
extension VWrappedButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Rectangular Caption Button
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension VRectangularCaptionButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'iconCaption' and 'titleCaption' parameter order")
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

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension VRectangularCaptionButtonUIModel {
    @available(*, deprecated, renamed: "titleCaptionTextAndIconCaptionSpacing")
    public var iconCaptionAndTitleCaptionTextSpacing: CGFloat {
        get { titleCaptionTextAndIconCaptionSpacing }
        set { titleCaptionTextAndIconCaptionSpacing = newValue }
    }
}

// MARK: - V Plain Button
@available(tvOS, unavailable)
extension VPlainButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VStretchedToggleButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VStretchedToggleButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Wrapped Toggle Button
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWrappedToggleButton {
    @available(*, deprecated, message: "Use 'init' with reversed 'icon' and 'title' parameter order")
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

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VWrappedToggleButtonUIModel {
    @available(*, deprecated, renamed: "titleTextAndIconSpacing")
    public var iconAndTitleTextSpacing: CGFloat {
        get { titleTextAndIconSpacing }
        set { titleTextAndIconSpacing = newValue }
    }
}

// MARK: - V Rectangular Toggle Button
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VRectangularToggleButtonUIModel {
    @available(*, unavailable)
    public var iconAndTitleTextSpacing: CGFloat { fatalError() }
}

// MARK: - V Text View
@available(iOS 16.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
extension VTextViewUIModel {
    @available(*, unavailable, message: "Use 'minimumHeight' instead")
    public var minHeight: CGFloat {
        fatalError()
    }
}

// MARK: - V Code Entry View
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VCodeEntryViewUIModel {
    @available(*, deprecated, message: "Use 'spacingType' instead")
    public var spacing: CGFloat {
        get {
            switch spacingType {
            case .fixed(let spacing): return spacing
            case .stretched: fatalError()
            }
        }
        set {
            switch spacingType {
            case .fixed: spacingType = .fixed(spacing: newValue)
            case .stretched: fatalError()
            }
        }
    }
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

// MARK: - V List
@available(*, deprecated, message: "Use modern 'List' API instead")
@available(macOS 13.0, *)
@available(watchOS, unavailable)
public struct VListRow<Content>: View
    where Content: View
{
    private let uiModel: VListRowUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    private let content: () -> Content

    public init(
        uiModel: VListRowUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }

    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0,
            content: {
                if uiModel.separatorType.contains(.top) { separator }

                content()
                    .padding(uiModel.margins)

                if uiModel.separatorType.contains(.bottom) { separator }
            }
        )
        .listRowInsets(EdgeInsets())
        .listRowBackground(uiModel.backgroundColor)
        .applyModifier({
#if !(os(tvOS) || os(watchOS))
            $0.listRowSeparator(.hidden)
#else
            $0
#endif
        })
    }

    private var separator: some View {
        uiModel.separatorColor
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.separatorHeight.toPoints(scale: displayScale))
            .padding(uiModel.separatorMargins)
    }
}


@available(*, deprecated, message: "Use modern 'List' API instead")
@available(macOS 13.0, *)
@available(watchOS, unavailable)
public struct VListRowUIModel {
    public var backgroundColor: Color = ColorBook.background

    public var margins: Margins = .init(
        horizontal: GlobalUIModel.Common.containerContentMargin,
        vertical: 9
    )

    public var separatorType: SeparatorType = .default
    public var separatorHeight: PointPixelMeasurement = .pixels(1)
    public var separatorColor: Color = GlobalUIModel.Common.dividerColor
    public var separatorMargins: HorizontalMargins = .init(GlobalUIModel.Common.containerContentMargin)

    public init() {}

    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    public typealias HorizontalMargins = EdgeInsets_LeadingTrailing

    public struct SeparatorType: OptionSet {
        public static let top: Self = .init(rawValue: 1 << 0)

        public static let bottom: Self = .init(rawValue: 1 << 1)

        public static var `default`: Self { .bottom }

        public static var none: Self { [] }

        public static var all: Self { [.top, .bottom] }

        public static func noFirstSeparator() -> Self {
            .bottom
        }

        public static func noLastSeparator() -> Self {
            .top
        }

        public static func noFirstAndLastSeparators(isFirst: Bool) -> Self {
            isFirst ? .none : .top
        }

        public static func rowEnclosingSeparators(isFirst: Bool) -> Self {
            isFirst ? .all : .bottom
        }

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

@available(macOS 13.0, *)
@available(watchOS, unavailable)
extension VListRowUIModel {
    public static func noSeparators() -> Self {
        var uiModel: Self = .init()

        uiModel.separatorType = .none

        return uiModel
    }

    public static func noFirstSeparator() -> Self {
        var uiModel: Self = .init()

        uiModel.separatorType = .noFirstSeparator()

        return uiModel
    }

    public static func noLastSeparator() -> Self {
        var uiModel: Self = .init()

        uiModel.separatorType = .noLastSeparator()

        return uiModel
    }

    public static func noFirstAndLastSeparators(isFirst: Bool) -> Self {
        var uiModel: Self = .init()

        uiModel.separatorType = .noFirstAndLastSeparators(isFirst: isFirst)

        return uiModel
    }

    public static func rowEnclosingSeparators(isFirst: Bool) -> Self {
        var uiModel: Self = .init()

        uiModel.separatorType = .rowEnclosingSeparators(isFirst: isFirst)

        return uiModel
    }
}

@available(*, deprecated, message: "Use modern 'List' API instead")
@available(macOS 13.0, *)
@available(watchOS, unavailable)
extension View {
    public func vListStyle() -> some View {
        self
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
    }
}
