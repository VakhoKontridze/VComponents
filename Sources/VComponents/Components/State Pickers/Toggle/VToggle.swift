//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Toggle
/// State picker component that toggles between `off` and `on` states, and displays label.
///
///     @State private var state: VToggleState = .on
///
///     var body: some View {
///         VToggle(
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
///         VToggle(
///             state: Binding(isOn: $isOn),
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `View.onTouchInteraction(perform:)` support.
public struct VToggle<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VToggleUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VToggleState
    private var internalState: VToggleInternalState {
        .init(
            isEnabled: isEnabled,
            isOn: state == .on,
            isPressed: isPressed
        )
    }

    // MARK: Properties - Label
    private let label: VToggleLabel<Label>
    
    // MARK: Initializers
    /// Initializes `VToggle` with state.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .empty
    }
    
    /// Initializes `VToggle` with state and title.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = state
        self.label = .title(title: title)
    }
    
    /// Initializes `VToggle` with state and label.
    public init(
        uiModel: VToggleUIModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder label: @escaping (VToggleInternalState) -> Label
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
                toggle
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    toggle
                    
                    spacer
                    
                    SwiftUIGestureBaseButton(
                        onStateChange: stateChangeHandler,
                        label: {
                            Text(title)
                                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                                .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                                .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
                                .font(uiModel.titleTextFont)
                        }
                    )
                    .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
                })
                
            case .label(let label):
                HStack(spacing: 0, content: {
                    toggle
                    
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
    
    private var toggle: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                ZStack(content: {
                    RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                        .foregroundStyle(uiModel.fillColors.value(for: internalState))
                    
                    Circle()
                        .frame(dimension: uiModel.thumbDimension)
                        .foregroundStyle(uiModel.thumbColors.value(for: internalState))
                        .offset(x: thumbOffset)
                })
                .frame(size: uiModel.size)
            }
        )
    }
    
    private var spacer: some View {
        SwiftUIGestureBaseButton(
            onStateChange: stateChangeHandler,
            label: {
                Rectangle()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: uiModel.toggleAndLabelSpacing)
                    .foregroundStyle(.clear)
            }
        )
        .disabled(!uiModel.labelIsClickable) // `disabled(:_)` because it's a `SwiftUIGestureBaseButton`
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
    
    // MARK: Thumb Position
    private var thumbOffset: CGFloat {
        let offset: CGFloat = uiModel.thumbOffset
        
        switch internalState {
        case .off: return -offset
        case .on: return offset
        case .pressedOff: return -offset
        case .pressedOn: return offset
        case .disabled: return -offset
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VToggle_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem ipsum".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var state: VToggleState = .on
        
        var body: some View {
            PreviewContainer(content: {
                VToggle(
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
                        VToggle(
                            state: .constant(.off),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed Off",
                    content: {
                        VToggle(
                            uiModel: {
                                var uiModel: VToggleUIModel = .init()
                                uiModel.fillColors.off = uiModel.fillColors.pressedOff
                                uiModel.thumbColors.off = uiModel.thumbColors.pressedOff
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
                        VToggle(
                            state: .constant(.on),
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed On",
                    content: {
                        VToggle(
                            uiModel: {
                                var uiModel: VToggleUIModel = .init()
                                uiModel.fillColors.on = uiModel.fillColors.pressedOn
                                uiModel.thumbColors.on = uiModel.thumbColors.pressedOn
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
                    title: "Disabled",
                    content: {
                        VToggle(
                            state: .constant(.off),
                            title: title
                        )
                        .disabled(true)
                    }
                )
                
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
                        .toggleStyle(.switch)
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
                        .toggleStyle(.switch)
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
                        .toggleStyle(.switch)
                        .disabled(true)
                        .padding(.trailing, 95)
                    }
                )
            })
        }
    }
}
