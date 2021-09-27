//
//  VCloseButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Close Button Demo View
struct VCloseButtonDemoView: View {
    // MARK: Properties
    static let navBarTitle: String { "Close Button" }
    
    @State private var state: VCloseButtonState = .enabled
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VCloseButtonModel.Layout().hitBox.horizontal)
    
    private var model: VCloseButtonModel {
        let defaultModel: VCloseButtonModel = .init()
        
        var model: VCloseButtonModel = .init()
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBox.horizontal = 0
            model.layout.hitBox.vertical = 0
            
        case .extended:
            model.layout.hitBox.horizontal = defaultModel.layout.hitBox.horizontal.isZero ? 5 : defaultModel.layout.hitBox.vertical
            model.layout.hitBox.vertical = defaultModel.layout.hitBox.vertical.isZero ? 5 : defaultModel.layout.hitBox.vertical
        }

        return model
    }

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    private func component() -> some View {
        VCloseButton(model: model, state: state, action: {})
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
    }
}

// MARK: - Helpers
extension VCloseButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VCloseButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButtonDemoView()
    }
}
