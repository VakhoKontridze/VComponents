//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Toggle
/// State picker component that toggles between off, on, or disabled states, and displays label.
///
/// Component can be initialized without label, with label, or label.
///
/// UI Model can be passed as parameter.
///
/// `Bool` can also be passed as state.
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
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIBaseButton` support.
public struct VToggle<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VToggleUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    @Binding private var state: VToggleState
    private var internalState: VToggleInternalState { .init(isEnabled: isEnabled, isOn: state == .on, isPressed: isPressed) }
    
    private let label: VToggleLabel<Label>
    
    private var labelIsEnabled: Bool { uiModel.misc.labelIsClickable && internalState.isEnabled }
    
    // MARK: Initializers - State
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
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self._state = state
        self.label = .content(content: label)
    }
    
    // MARK: Initializers - Bool
    /// Initializes `VToggle` with `Bool`.
    public init(
        uiModel: VToggleUIModel = .init(),
        isOn: Binding<Bool>
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .empty
    }
    
    /// Initializes `VToggle` with `Bool` and title.
    public init(
        uiModel: VToggleUIModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self._state = .init(isOn: isOn)
        self.label = .title(title: title)
    }
    
    /// Initializes `VToggle` with `Bool` and label.
    public init(
        uiModel: VToggleUIModel = .init(),
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
                toggle
                
            case .title(let title):
                HStack(spacing: 0, content: {
                    toggle
                    
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
                    toggle
                    
                    spacer
                    
                    SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
                        label()
                            .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
                    })
                        .disabled(!labelIsEnabled)
                })
            }
        })
            .animation(uiModel.animations.stateChange, value: state)
    }
    
    private var toggle: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                    .foregroundColor(uiModel.colors.fill.value(for: internalState))

                Circle()
                    .frame(dimension: uiModel.layout.thumbDimension)
                    .foregroundColor(uiModel.colors.thumb.value(for: internalState))
                    .offset(x: thumbOffset)
            })
                .frame(size: uiModel.layout.size)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var spacer: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: uiModel.layout.toggleLabelSpacing)
                .foregroundColor(.clear)
        })
            .disabled(!labelIsEnabled)
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { state.setNextState() }
    }

    // MARK: Thumb Position
    private var thumbOffset: CGFloat {
        let offset: CGFloat = uiModel.layout.animationOffset
        
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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VToggle_Previews: PreviewProvider {
    // Configuration
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem Ipsum" }

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
                                uiModel.colors.fill.off = uiModel.colors.fill.pressedOff
                                uiModel.colors.thumb.off = uiModel.colors.thumb.pressedOff
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
                                uiModel.colors.fill.on = uiModel.colors.fill.pressedOn
                                uiModel.colors.thumb.on = uiModel.colors.thumb.pressedOn
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
