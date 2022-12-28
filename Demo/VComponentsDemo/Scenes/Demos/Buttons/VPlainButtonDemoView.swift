//
//  VPlainButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Plain Button Demo View
struct VPlainButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Plain Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VPlainButtonLabel = .title
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VPlainButtonUIModel.Layout().hitBox.horizontal)
    
    private var uiModel: VPlainButtonUIModel {
        let defaultUIModel: VPlainButtonUIModel = .init()
        
        var uiModel: VPlainButtonUIModel = .init()
        
        uiModel.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox.horizontal == 0 ? 5 : defaultUIModel.layout.hitBox.horizontal
            }
        }()
        uiModel.layout.hitBox.vertical = uiModel.layout.hitBox.horizontal

        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VPlainButton(uiModel: uiModel, action: {}, title: buttonTitle)
            case .icon: VPlainButton(uiModel: uiModel, action: {}, icon: buttonIcon)
            case .iconTitle: VPlainButton(uiModel: uiModel, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VPlainButton(uiModel: uiModel, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VPlainButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private typealias VPlainButtonInternalState = VSecondaryButtonInternalState

private enum VPlainButtonLabel: Int, StringRepresentableHashableEnumeration {
    case title
    case icon
    case iconTitle
    case custom
    
    var stringRepresentation: String {
        switch self {
        case .title: return "Title"
        case .icon: return "Icon"
        case .iconTitle: return "Icon & Title"
        case .custom: return "Custom"
        }
    }
}

// MARK: - Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}
