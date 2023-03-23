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
@available(macOS, unavailable) // No `SwiftUIBaseButton` support
@available(tvOS, unavailable) // No `SwiftUIBaseButton` support
@available(watchOS, unavailable) // No `SwiftUIBaseButton` support
public struct VRadioButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VRadioButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VRadioButtonState
    private var internalState: VRadioButtonInternalState { .init(isEnabled: isEnabled, isOn: state == .on, isPressed: isPressed) }
    
    private let label: VRadioButtonLabel<Label>
    
    private var labelIsEnabled: Bool { uiModel.misc.labelIsClickable && internalState.isEnabled }
    
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
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .content(content: label)
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
        self._state = .init(isOn: isOn)
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
        self._state = .init(isOn: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes `VRadioButton` with `Bool` and label.
    public init(
        uiModel: VRadioButtonUIModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .content(content: label)
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

                    SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
                        VText(
                            type: uiModel.layout.titleTextLineType,
                            minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
                            color: uiModel.colors.title.value(for: internalState),
                            font: uiModel.fonts.title,
                            text: title
                        )
                    })
                        .disabled(!labelIsEnabled)
                })
                
            case .content(let label):
                HStack(spacing: 0, content: {
                    radioButton
                    
                    spacer
                    
                    SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
                        label()
                            .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
                    })
                        .disabled(!labelIsEnabled)
                })
            }
        })
            .animation(uiModel.animations.stateChange, value: internalState)
    }
    
    private var radioButton: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
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
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var spacer: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: uiModel.layout.radioLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextStateRadio() }
    }
}

// MARK: - Helpers
@available(macOS, unavailable)
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRadioButton_Previews: PreviewProvider {
    private static var title: String { "Lorem Ipsum" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
    }
    
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
