//
//  VRadioButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button
/// State picker component that toggles between off, on, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
///
/// UI Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
///     @State private var state: VRadioButtonState = .on
///
///     var body: some View {
///         VRadioButton(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VRadioButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VRadioButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState { .init(isEnabled: isEnabled, isOn: state == .on, isPressed: isPressed) }
    
    private let label: VRadioButtonLabel<Label>
    
    // MARK: Initializers - State
    /// Initializes `VRadioButton` with state.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VRadioButton` with state and title.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VRadioButton` with state and label.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        state: Binding<VRadioButtonState>,
        @ViewBuilder label: @escaping (VRadioButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .label(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes `VRadioButton` with `Bool`.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        isOn: Binding<Bool>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = Binding(isOn: isOn)
        self.label = .empty
    }
    
    /// Initializes `VRadioButton` with `Bool` and title.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = Binding(isOn: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes `VRadioButton` with `Bool` and label.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder label: @escaping (VRadioButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = Binding(isOn: isOn)
        self.label = .label(label: label)
    }

    // MARK: Body
    public var body: some View {
        Group(content: {
            switch label {
            case .empty:
                radioButton
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    radioButton
                    
                    spacer

                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            VText(
                                type: uiModel.layout.titleTextLineType,
                                minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                                color: uiModel.colors.title.value(for: internalState),
                                font: uiModel.fonts.title,
                                text: title
                            )
                        }
                    )
                        .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
                
            case .label(let label):
                HStack(spacing: 0, content: {
                    radioButton
                    
                    spacer
                    
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            label(internalState)
                        }
                    )
                        .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
            }
        })
            .animation(uiModel.animations.stateChange, value: internalState)
    }
    
    private var radioButton: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    Circle()
                        .frame(dimension: uiModel.layout.dimension)
                        .foregroundColor(uiModel.colors.fill.value(for: internalState))
                    
                    Circle()
                        .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
                        .frame(dimension: uiModel.layout.dimension)
                    
                    Circle()
                        .frame(dimension: uiModel.layout.bulletDimension)
                        .foregroundColor(uiModel.colors.bullet.value(for: internalState))
                })
                    .frame(dimension: uiModel.layout.dimension)
                    .padding(uiModel.layout.hitBox)
            }
        )
    }
    
    private var spacer: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: uiModel.layout.radioLabelSpacing)
                    .foregroundColor(.clear)
            }
        )
            .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: GestureBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextStateRadio() }
    }
}

// MARK: - Helpers
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VRadioButtonState {
    mutating fileprivate func setNextStateRadio() {
        switch self {
        case .off: self = .on
        case .on: break
        }
    }
}

// MARK: - Preview
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRadioButton_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem ipsum".pseudoRTL(languageDirection) }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VRadioButtonState = .off
        
        var body: some View {
            PreviewContainer(content: {
                VRadioButton(
                    state: $state,
                    title: title
                )
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .horizontal,
                    title: "Off",
                    content: {
                        VRadioButton(
                            state: .constant(.off),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VRadioButton(
                            uiModel: {
                                var uiModel: VRadioButtonUIModel = .init()
                                uiModel.colors.fill.off = uiModel.colors.fill.pressedOff
                                uiModel.colors.border.off = uiModel.colors.border.pressedOff
                                uiModel.colors.bullet.off = uiModel.colors.bullet.pressedOff
                                uiModel.colors.title.off = uiModel.colors.title.pressedOff
                                return uiModel
                            }(),
                            state: .constant(.off),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "On",
                    content: {
                        VRadioButton(
                            state: .constant(.on),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VRadioButton(
                            uiModel: {
                                var uiModel: VRadioButtonUIModel = .init()
                                uiModel.colors.fill.on = uiModel.colors.fill.pressedOn
                                uiModel.colors.border.on = uiModel.colors.border.pressedOn
                                uiModel.colors.bullet.on = uiModel.colors.bullet.pressedOn
                                uiModel.colors.title.on = uiModel.colors.title.pressedOn
                                return uiModel
                            }(),
                            state: .constant(.on),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VRadioButton(
                            state: .constant(.off),
                            title: title
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
