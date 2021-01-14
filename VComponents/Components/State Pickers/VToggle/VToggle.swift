//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Toggle
/// State picker component that toggles between off, on, or disabled states, and displays content
public struct VToggle<Content>: View where Content: View {
    // MARK: Properties
    private let model: VToggleModel
    
    @Binding private var state: VToggleState
    @State private var isPressed: Bool = false
    private var internalState: VToggleInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsEnabled: Bool { state.isEnabled && model.behavior.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    /// Initializes component with content
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(state: $state, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///             .foregroundColor(.accentColor)
    ///     })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(model: model, state: $state, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///             .foregroundColor(.accentColor)
    ///     })
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - state: Enum that describes state, such as off, on, or disabled
    ///   - content: View that describes purpose of the action
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = content
    }
    
    /// Initializes component with content
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(isOn: $isOn, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///             .foregroundColor(.accentColor)
    ///     })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(model: model, isOn: $isOn, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///             .foregroundColor(.accentColor)
    ///     })
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - isOn: Bool that describes state
    ///   - content: View that describes purpose of the action
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            model: model,
            state: Binding<VToggleState>(bool: isOn),
            content: content
        )
    }

    /// Initializes component with title
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(state: $state, title: "Press")
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(model: model, state: $state, title: "Press")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - state: Enum that describes state, such as off, on, or disabled
    ///   - title: Title that describes purpose of the action
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>,
        title: String
    )
        where Content == VBaseTitle
    {
        self.init(
            model: model,
            state: state,
            content: {
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(state: .init(state: state.wrappedValue, isPressed: false)),
                    font: model.font,
                    type: .multiLine(limit: nil, alignment: .leading)
                )
            }
        )
    }
    
    /// Initializes component with title
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(isOn: $isOn, title: "Press")
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(model: model, isOn: $isOn, title: "Press")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - isOn: Bool that describes state
    ///   - title: Title that describes purpose of the action
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>,
        title: String
    )
        where Content == VBaseTitle
    {
        self.init(
            model: model,
            state: .init(bool: isOn),
            content: {
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(state: .init(bool: isOn.wrappedValue, isPressed: false)),
                    font: model.font,
                    type: .multiLine(limit: nil, alignment: .leading)
                )
            }
        )
    }

    /// Initializes component
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(state: $state)
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var state: VToggleState = .on
    ///
    /// var body: some View {
    ///     VToggle(model: model, state: $state)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - state: Enum that describes state, such as off, on, or disabled
    public init(
        model: VToggleModel = .init(),
        state: Binding<VToggleState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = nil
    }
    
    /// Initializes component
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(isOn: $isOn)
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VToggleModel = .init()
    /// @State var isOn: Bool = true
    ///
    /// var body: some View {
    ///     VToggle(model: model, isOn: $isOn)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - isOn: Bool that describes state
    public init(
        model: VToggleModel = .init(),
        isOn: Binding<Bool>
    )
        where Content == Never
    {
        self.model = model
        self._state = .init(bool: isOn)
        self.content = nil
    }
}

// MARK:- Body
extension VToggle {
    @ViewBuilder public var body: some View {
        switch content {
        case nil:
            toggle
            
        case let content?:
            HStack(spacing: 0, content: {
                toggle
                spacerView
                contentView(content: content)
            })
        }
    }
    
    private var toggle: some View {
        VBaseButton(isEnabled: state.isEnabled, action: action, onPress: { _ in }, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: model.layout.size.height)
                    .foregroundColor(model.colors.fillColor(state: internalState))

                Circle()
                    .frame(dimension: model.layout.thumbDimension)
                    .foregroundColor(model.colors.thumbColor(state: internalState))
                    .offset(x: thumbOffset)
            })
                .frame(size: model.layout.size)
        })
    }
    
    private var spacerView: some View {
        VBaseButton(isEnabled: contentIsEnabled, action: action, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.contentMargin)
                .foregroundColor(.clear)
        })
    }
    
    private func contentView(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VBaseButton(isEnabled: contentIsEnabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .opacity(model.colors.contentOpacity(state: internalState))
        })
    }
}

// MARK:- Thumb Position
private extension VToggle {
    var thumbOffset: CGFloat {
        let offset: CGFloat = model.layout.animationOffset
        
        switch internalState {
        case .off: return -offset
        case .on: return offset
        case .pressedOff: return -offset
        case .pressedOn: return offset
        case .disabled: return -offset
        }
    }
}

// MARK:- Action
private extension VToggle {
    func action() {
        withAnimation(model.behavior.animation, { state.nextState() })
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var state: VToggleState = .on

    static var previews: some View {
        VToggle(state: $state, title: "Press")
            .padding()
    }
}
