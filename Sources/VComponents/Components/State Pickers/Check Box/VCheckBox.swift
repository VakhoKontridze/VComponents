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
/// Component can be also initialized with `Bool`:
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
    // MARK: Properties
    private let uiModel: VCheckBoxUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VCheckBoxState
    private var internalState: VCheckBoxInternalState { .init(isEnabled: isEnabled, state: state, isPressed: isPressed) }
    
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
                                .multilineTextAlignment(uiModel.layout.titleTextLineType.textAlignment ?? .leading)
                                .lineLimit(type: uiModel.layout.titleTextLineType.textLineLimitType)
                                .minimumScaleFactor(uiModel.layout.titleTextMinimumScaleFactor)
                                .foregroundColor(uiModel.colors.titleText.value(for: internalState))
                                .font(uiModel.fonts.titleText)
                        }
                    )
                    .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
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
                    .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
            }
        })
        .applyIf(uiModel.animations.appliesStateChangeAnimation, transform: {
            $0.animation(uiModel.animations.stateChange, value: internalState)
        })
    }
    
    private var checkBox: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                        .foregroundColor(uiModel.colors.fill.value(for: internalState))
                    
                    RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                        .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
                    
                    if let checkmarkIcon {
                        checkmarkIcon
                            .resizable()
                            .scaledToFit()
                            .frame(dimension: uiModel.layout.checkmarkIconDimension)
                            .foregroundColor(uiModel.colors.checkmark.value(for: internalState))
                    }
                })
                .frame(dimension: uiModel.layout.dimension)
                .cornerRadius(uiModel.layout.cornerRadius) // Prevents large content from going out of bounds
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
                    .frame(width: uiModel.layout.checkBoxAndLabelSpacing)
                    .foregroundColor(.clear)
            }
        )
        .disabled(!uiModel.misc.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
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
        HapticManager.shared.playImpact(uiModel.animations.haptic)
#endif
    }
    
    // MARK: Icon
    private var checkmarkIcon: Image? {
        switch internalState {
        case .off, .pressedOff: return nil
        case .on, .pressedOn: return ImageBook.checkBoxCheckmarkOn
        case .indeterminate, .pressedIndeterminate: return ImageBook.checkBoxCheckmarkIndeterminate
        case .disabled: return nil
        }
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
                                uiModel.colors.fill.off = uiModel.colors.fill.pressedOff
                                uiModel.colors.border.off = uiModel.colors.border.pressedOff
                                uiModel.colors.checkmark.off = uiModel.colors.checkmark.pressedOff
                                uiModel.colors.titleText.off = uiModel.colors.titleText.pressedOff
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
                                uiModel.colors.titleText.on = uiModel.colors.titleText.pressedOn
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
                                uiModel.colors.fill.indeterminate = uiModel.colors.fill.pressedIndeterminate
                                uiModel.colors.border.indeterminate = uiModel.colors.border.pressedIndeterminate
                                uiModel.colors.checkmark.indeterminate = uiModel.colors.checkmark.pressedIndeterminate
                                uiModel.colors.titleText.indeterminate = uiModel.colors.titleText.pressedIndeterminate
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
                        uiModel.layout.checkmarkIconDimension = 100
                        uiModel.colors.checkmark = VCheckBoxUIModel.Colors.StateColors(ColorBook.accentRed)
                        return uiModel
                    }(),
                    state: .constant(.on),
                    title: title
                )
            })
        }
    }
}
