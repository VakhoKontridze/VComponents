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
    static var navBarTitle: String { "Square Button" }
    
    @State private var isEnabled: Bool = true
    @State private var contentType: VSquareButtonContent = .title
    @State private var shapeType: VSquareButtonShape = .init(dimension: VSquareButtonModel.Layout().dimension, radius: VSquareButtonModel.Layout().cornerRadius)
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VSquareButtonModel.Layout().hitBox.horizontal)
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var model: VSquareButtonModel {
        let defaultModel: VSquareButtonModel = .init()
        
        var model: VSquareButtonModel = .init()
        
        model.layout.cornerRadius = {
            switch shapeType {
            case .circular: return model.layout.dimension / 2
            case .rounded: return model.layout.cornerRadius == model.layout.dimension/2 ? 16 : model.layout.cornerRadius
            }
        }()
        
        model.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultModel.layout.hitBox.horizontal == 0 ? 5 : defaultModel.layout.hitBox.horizontal
            }
        }()
        model.layout.hitBox.vertical = model.layout.hitBox.horizontal

        if borderType == .bordered {
            model.layout.borderWidth = 2
            
            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            model.colors.border = defaultModel.colors.background
            
            model.colors.title = model.colors.icon
            
            model.colors.icon = defaultModel.colors.background
        }

        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch contentType {
            case .title: VSquareButton(model: model, action: {}, title: buttonTitle)
            case .icon: VSquareButton(model: model, action: {}, icon: buttonIcon)
            case .custom: VSquareButton(model: model, action: {}, content: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VSquareButtonState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem" }
}

// MARK: - Helpers
private typealias VSquareButtonState = VSecondaryButtonState

enum VSquareButtonContent: Int, VPickableTitledItem {
    case title
    case icon
    case custom
    
    var pickerTitle: String {
        switch self {
        case .title: return "Title"
        case .icon: return "Icon"
        case .custom: return "Custom"
        }
    }
}

private enum VSquareButtonShape: Int, VPickableTitledItem {
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
