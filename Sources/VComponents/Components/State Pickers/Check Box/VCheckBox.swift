//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box
/// State picker component that toggles between `off`, `on`, and `indeterminate` states, and displays label.
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
/// Component can be also initialized with `Bool`.
///
///     @State private var isOn: Bool = true
///
///     var body: some View {
///         VCheckBox(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VCheckBox<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VCheckBoxUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState {
        .init(
            isEnabled: isEnabled,
            state: state,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VCheckBoxLabel<Label>
    
    // MARK: Initializers
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
        @ViewBuilder label: @escaping (VCheckBoxInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .label(label: label)
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
                    
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            Text(title)
                                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                                .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                                .foregroundColor(uiModel.titleTextColors.value(for: internalState))
                                .font(uiModel.titleTextFont)
                        }
                    )
                    .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
                
            case .label(let label):
                HStack(spacing: 0, content: {
                    checkBox
                    
                    spacer
                    
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            label(internalState)
                        }
                    )
                    .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
            }
        })
        .applyIf(uiModel.appliesStateChangeAnimation, transform: {
            $0.animation(uiModel.stateChangeAnimation, value: internalState)
        })
    }
    
    private var checkBox: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .foregroundColor(uiModel.fillColors.value(for: internalState))
                    
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: uiModel.borderWidth)
                    
                    if let checkmarkIcon {
                        checkmarkIcon
                            .resizable()
                            .scaledToFit()
                            .frame(dimension: uiModel.checkmarkIconDimension)
                            .foregroundColor(uiModel.checkmarkColors.value(for: internalState))
                    }
                })
                .frame(dimension: uiModel.dimension)
                .cornerRadius(uiModel.cornerRadius) // Prevents large content from overflowing
                .padding(uiModel.checkboxHitBox)
            }
        )
    }
    
    private var spacer: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: uiModel.checkBoxAndLabelSpacing)
                    .foregroundColor(.clear)
            }
        )
        .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
    }

    // MARK: Checkmark Icon
    private var checkmarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff:
            return nil

        case .on, .pressedOn:
            return uiModel.checkmarkIconOn.renderingMode(.template)

        case .indeterminate, .pressedIndeterminate:
            return uiModel.checkmarkIconIndeterminate.renderingMode(.template)

        case .disabled:
            return nil
        }
    }
    
    // MARK: Actions
    private func stateChangeHandler(gestureState: GestureBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        
        if gestureState.isClicked {
            playHapticEffect()
            state.setNextState()
        }
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#endif
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VCheckBox_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
            OutOfBoundsContentPreventionPreview().previewDisplayName("Out-of-Bounds Content Prevention")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VCheckBoxState = .on
        
        var body: some View {
            PreviewContainer(content: {
                VCheckBox(
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
                                uiModel.fillColors.off = uiModel.fillColors.pressedOff
                                uiModel.borderColors.off = uiModel.borderColors.pressedOff
                                uiModel.checkmarkColors.off = uiModel.checkmarkColors.pressedOff
                                uiModel.titleTextColors.off = uiModel.titleTextColors.pressedOff
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
                                uiModel.fillColors.on = uiModel.fillColors.pressedOn
                                uiModel.borderColors.on = uiModel.borderColors.pressedOn
                                uiModel.checkmarkColors.on = uiModel.checkmarkColors.pressedOn
                                uiModel.titleTextColors.on = uiModel.titleTextColors.pressedOn
                                return uiModel
                            }(),
                            state: .constant(.on),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Indeterminate",
                    content: {
                        VCheckBox(
                            state: .constant(.indeterminate),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Indeterminate",
                    content: {
                        VCheckBox(
                            uiModel: {
                                var uiModel: VCheckBoxUIModel = .init()
                                uiModel.fillColors.indeterminate = uiModel.fillColors.pressedIndeterminate
                                uiModel.borderColors.indeterminate = uiModel.borderColors.pressedIndeterminate
                                uiModel.checkmarkColors.indeterminate = uiModel.checkmarkColors.pressedIndeterminate
                                uiModel.titleTextColors.indeterminate = uiModel.titleTextColors.pressedIndeterminate
                                return uiModel
                            }(),
                            state: .constant(.indeterminate),
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
                
#if os(macOS)
                Group(content: {
                    PreviewSectionHeader("Native")
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Off",
                        content: {
                            Toggle(
                                "",
                                isOn: .constant(false)
                            )
                            .labelsHidden()
                            .toggleStyle(.checkbox)
                            .padding(.trailing, 95)
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "On",
                        content: {
                            Toggle(
                                "",
                                isOn: .constant(true)
                            )
                            .labelsHidden()
                            .toggleStyle(.checkbox)
                            .padding(.trailing, 95)
                        }
                    )
                    
                    PreviewRow(
                        axis: .horizontal,
                        title: "Disabled",
                        content: {
                            Toggle(
                                "",
                                isOn: .constant(false)
                            )
                            .labelsHidden()
                            .toggleStyle(.checkbox)
                            .disabled(true)
                            .padding(.trailing, 95)
                        }
                    )
                })
#endif
            })
        }
    }

    private struct OutOfBoundsContentPreventionPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VCheckBox(
                    uiModel: {
                        var uiModel: VCheckBoxUIModel = .init()
                        uiModel.checkmarkIconDimension = 100
                        uiModel.checkmarkColors = VCheckBoxUIModel.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    state: .constant(.on),
                    title: title
                )
            })
        }
    }
}
