//
//  VSquareButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Square Button Demo View
struct VSquareButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Square Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VSquareButtonLabel = .title
    @State private var shapeType: VSquareButtonShape = .init(dimension: VSquareButtonUIModel.Layout().dimension, radius: VSquareButtonUIModel.Layout().cornerRadius)
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VSquareButtonUIModel.Layout().hitBox.horizontal)
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var uiModel: VSquareButtonUIModel {
        let defaultUIModel: VSquareButtonUIModel = .init()
        
        var uiModel: VSquareButtonUIModel = .init()
        
        uiModel.layout.cornerRadius = {
            switch shapeType {
            case .circular: return uiModel.layout.dimension / 2
            case .rounded: return uiModel.layout.cornerRadius == uiModel.layout.dimension/2 ? 16 : uiModel.layout.cornerRadius
            }
        }()
        
        uiModel.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox.horizontal == 0 ? 5 : defaultUIModel.layout.hitBox.horizontal
            }
        }()
        uiModel.layout.hitBox.vertical = uiModel.layout.hitBox.horizontal

        if borderType == .bordered {
            uiModel.layout.borderWidth = 2
            
            uiModel.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            uiModel.colors.border = defaultUIModel.colors.background
            
            uiModel.colors.title = uiModel.colors.icon
            
            uiModel.colors.icon = defaultUIModel.colors.background
        }

        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VSquareButton(uiModel: uiModel, action: {}, title: buttonTitle)
            case .icon: VSquareButton(uiModel: uiModel, action: {}, icon: buttonIcon)
            case .custom: VSquareButton(uiModel: uiModel, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VSquareButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem" }
}

// MARK: - Helpers
private typealias VSquareButtonInternalState = VSecondaryButtonInternalState

enum VSquareButtonLabel: Int, StringRepresentableHashableEnumeration {
    case title
    case icon
    case custom
    
    var stringRepresentation: String {
        switch self {
        case .title: return "Title"
        case .icon: return "Icon"
        case .custom: return "Custom"
        }
    }
}

private enum VSquareButtonShape: Int, StringRepresentableHashableEnumeration {
    case rounded
    case circular
    
    var stringRepresentation: String {
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
