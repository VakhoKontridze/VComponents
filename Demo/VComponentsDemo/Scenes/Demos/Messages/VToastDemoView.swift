//
//  VToastDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Toast Demo View
struct VToastDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Toast" }
    
    @State private var isPresented: Bool = false
    
    @State private var presentationEdge: VToastUIModel.Layout.PresentationEdge = .default
    @State private var textLineType: VTextLineTypeHelper = .singleLine
    @State private var text: String = "Lorem ipsum dolor sit amet"
    
    private var uiModel: VToastUIModel {
        var uiModel: VToastUIModel = .init()
        uiModel.layout.titleTextLineType = textLineType.textLineType
        uiModel.layout.presentationEdge = presentationEdge
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settingsSections: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vToast(
                id: "toast_demo",
                uiModel: uiModel,
                isPresented: $isPresented,
                text: text
            )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: $presentationEdge,
                headerTitle: "Presentation Edge"
            )
        })
        
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: $textLineType,
                headerTitle: "Type",
                footerTitle: "In multi-line type, line limit and alignment can be set. For demo purposes, they are set to 5 and leading."
            )
            
            VTextField(text: $text)
        })
    }
}

// MARK: - Helpers
private enum VTextLineTypeHelper: Int, StringRepresentableHashableEnumeration {
    case singleLine
    case multiLine
    
    var stringRepresentation: String {
        switch self {
        case .singleLine: return "Single-line"
        case .multiLine: return "Multi-line"
        }
    }
    
    var textLineType: VToastUIModel.Layout.TextLineType {
        switch self {
        case .singleLine: return .singleLine
        case .multiLine: return .multiLine(alignment: .leading, lineLimit: 5)
        }
    }
}

extension VToastUIModel.Layout.PresentationEdge: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .top: return "Top"
        case .bottom: return "Bottom"
        }
    }
}

// MARK: - Preview
struct VToastDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToastDemoView()
    }
}
