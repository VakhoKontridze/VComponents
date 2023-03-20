//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box
/// State picker component that toggles between off, on, indeterminate, or disabled states, and displays label.
///
/// Component can be initialized without label, with title, or label.
///
/// UI Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
///
///     @State private var state: VCheckBoxState = .on
///
///     var body: some View {
///         VCheckBox(
///             state: $state,
///             title: "Lorem Ipsum"
///         )
///     }
///
public struct VCheckBox<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VCheckBoxUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
    private let label: VCheckBoxLabel<Label>
    
    private var labelIsEnabled: Bool { uiModel.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
    /// Initializes `VCheckBox` with state.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VCheckBox` with state and title.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VCheckBox` with state and label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .custom(label: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes `VCheckBox` with `Bool`.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .empty
    }
    
    /// Initializes `VCheckBox` with `Bool` and title.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes `VCheckBox` with `Bool` and label.
    public init(
        uiModel: VCheckBoxUIModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .custom(label: label)
    }

    // MARK: Body
    public var body: some View {
        Group(content: {
            switch label {
            case .empty:
                checkBox
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    checkBox
                    
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
                
            case .custom(let label):
                HStack(spacing: 0, content: {
                    checkBox
                    
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
    
    private var checkBox: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                    .foregroundColor(uiModel.colors.fill.value(for: internalState))
                
                RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                    .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)

                if let checkMarkIcon {
                    checkMarkIcon
                        .resizable()
                        .frame(dimension: uiModel.layout.iconDimension)
                        .foregroundColor(uiModel.colors.checkmark.value(for: internalState))
                }
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
                .frame(width: uiModel.layout.checkBoxLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
    }

    // MARK: Icon
    private var checkMarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff: return nil
        case .on, .pressedOn: return ImageBook.checkBoxCheckMarkOn
        case .indeterminate, .pressedIndeterminate: return ImageBook.checkBoxCheckMarkIndeterminate
        case .disabled: return nil
        }
    }
}

// MARK: - Preview
struct VCheckBox_Previews: PreviewProvider {
    private static var title: String { "Lorem Ipsum" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
    }
    
    private struct Preview: View {
        @State private var state: VCheckBoxState = .on
        
        var body: some View {
            PreviewContainer(content: {
                VCheckBox(
                    state: $state,
                    title: "Lorem Ipsum"
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
                        VCheckBox(
                            state: .constant(.off),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VCheckBox(
                            uiModel: {
                                var uiModel: VCheckBoxUIModel = .init()
                                uiModel.colors.fill.off = uiModel.colors.fill.pressedOff
                                uiModel.colors.border.off = uiModel.colors.border.pressedOff
                                uiModel.colors.checkmark.off = uiModel.colors.checkmark.pressedOff
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
                        VCheckBox(
                            state: .constant(.on),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VCheckBox(
                            uiModel: {
                                var uiModel: VCheckBoxUIModel = .init()
                                uiModel.colors.fill.on = uiModel.colors.fill.pressedOn
                                uiModel.colors.border.on = uiModel.colors.border.pressedOn
                                uiModel.colors.checkmark.on = uiModel.colors.checkmark.pressedOn
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
                        VCheckBox(
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
