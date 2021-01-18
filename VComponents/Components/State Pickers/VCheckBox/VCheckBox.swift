//
//  VCheckBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V Check Box
/// State picker component that toggles between off, on, intermediate, or disabled states, and displays content
///
/// Model can be passed as parameter
///
/// # Usage Example #
///
/// ```
/// @State var state: VCheckBoxState = .on
///
/// var body: some View {
///     VCheckBox(
///         state: $state,
///         title: "Lorem ipsum"
///     )
/// }
/// ```
///
/// Component can also be initialized with title, or with or withour any content
///
/// Component can also be initialized with bool as state
///
public struct VCheckBox<Content>: View where Content: View {
    // MARK: Properties
    private let model: VCheckBoxModel
    
    @Binding private var state: VCheckBoxState
    @State private var isPressed: Bool = false
    private var internalState: VCheckBoxInternalState { .init(state: state, isPressed: isPressed) }
    private var contentIsEnabled: Bool { state.isEnabled && model.contentIsClickable }
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self._state = state
        self.content = content
    }

    public init(
        model: VCheckBoxModel = .init(),
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            model: model,
            state: Binding<VCheckBoxState>(bool: isOn),
            content: content
        )
    }

    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>,
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

    public init(
        model: VCheckBoxModel = .init(),
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

    public init(
        model: VCheckBoxModel = .init(),
        state: Binding<VCheckBoxState>
    )
        where Content == Never
    {
        self.model = model
        self._state = state
        self.content = nil
    }

    public init(
        model: VCheckBoxModel = .init(),
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
extension VCheckBox {
    @ViewBuilder public var body: some View {
        switch content {
        case nil:
            checkBox
            
        case let content?:
            HStack(spacing: 0, content: {
                checkBox
                spacerView
                contentView(content: content)
            })
        }
    }
    
    private var checkBox: some View {
        VBaseButton(isEnabled: state.isEnabled, action: action, onPress: { _ in }, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                    .foregroundColor(model.colors.fillColor(state: internalState))
                
                RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                    .strokeBorder(model.colors.borderColor(state: internalState), lineWidth: model.layout.borderWith)

                if let icon = icon {
                    icon
                        .resizable()
                        .frame(dimension: model.layout.iconDimension)
                        .foregroundColor(model.colors.iconColor(state: internalState))
                }
            })
                .frame(dimension: model.layout.dimension)
                .padding(model.layout.hitBox)
        })
    }
    
    private var spacerView: some View {
        VBaseButton(isEnabled: contentIsEnabled, action: action, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: model.layout.contentMarginLeading)
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

// MARK:- Icon
private extension VCheckBox {
    var icon: Image? {
        switch state {
        case .off: return nil
        case .on: return ImageBook.checkBoxOn
        case .intermediate: return ImageBook.checkBoxInterm
        case .disabled: return nil
        }
    }
}

// MARK:- Action
private extension VCheckBox {
    func action() {
        withAnimation(model.animation, { state.nextState() })
    }
}

// MARK:- Preview
struct VCheckBox_Previews: PreviewProvider {
    @State private static var state: VCheckBoxState = .on

    static var previews: some View {
        VCheckBox(state: $state, title: "Lorem ipsum")
    }
}
