//
//  VSquareButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Square Button Demo View
struct VSquareButtonDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Square Button"
    
    @State private var state: VSquareButtonState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var shapeType: SquareButtonShapeType = .init(dimension: VSquareButtonModel.Layout().dimension, radius: VSquareButtonModel.Layout().cornerRadius)
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VSquareButtonModel.Layout().hitBox.horizontal)
    @State private var borderType: ButtonComponentBorderType = .borderless
    
    private var model: VSquareButtonModel {
        let defaultModel: VSquareButtonModel = .init()
        
        var model: VSquareButtonModel = .init()
        
        switch shapeType {
        case .circular:
            model.layout.cornerRadius = model.layout.dimension / 2
            
        case .rounded:
            model.layout.cornerRadius = model.layout.cornerRadius == model.layout.dimension/2 ? 16 : model.layout.cornerRadius
        }
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBox.horizontal = 0
            model.layout.hitBox.vertical = 0
            
        case .extended:
            model.layout.hitBox.horizontal = defaultModel.layout.hitBox.horizontal.isZero ? 5 : defaultModel.layout.hitBox.horizontal
            model.layout.hitBox.vertical = defaultModel.layout.hitBox.vertical.isZero ? 5 : defaultModel.layout.hitBox.vertical
        }

        if borderType == .bordered {
            model.layout.borderWidth = 1
            
            model.colors.textContent = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.pressed,
                disabled: defaultModel.colors.background.disabled
            )
            
            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )
            
            model.colors.border = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.disabled,   // It's better this way
                disabled: defaultModel.colors.background.disabled
            )
        }

        return model
    }
}

// MARK: - Body
extension VSquareButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VSquareButton(model: model, state: state, action: {}, title: buttonTitle)
        case .custom: VSquareButton(model: model, state: state, action: {}, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonTitle: String { "Lorem" }

    private func buttonContent() -> some View {
        let color: Color = {
            switch borderType {
            case .bordered: return VSquareButtonModel().colors.background.enabled
            case .borderless: return ColorBook.primaryInverted
            }
        }()
        
        return DemoIconContentView(dimension: 20, color: color)
    }
}

// MARK: - Helpers
extension VSquareButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

private enum SquareButtonShapeType: Int, VPickableTitledItem {
    case rounded
    case circular
    
    var pickerTitle: String {
        switch self {
        case .rounded: return "Rounded"
        case .circular: return "Circular"
        }
    }
    
    init(dimension: CGFloat, radius: CGFloat) {
        switch radius {
        case dimension/2: self = .circular
        default: self = .rounded
        }
    }
}

// MARK: - Preview
struct VSquareButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSquareButtonDemoView()
    }
}
