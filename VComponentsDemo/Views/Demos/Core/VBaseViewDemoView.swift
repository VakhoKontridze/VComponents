//
//  VBaseViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Base View Demo View
struct VBaseViewDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Base View"
    
    @State private var titleContentType: VBaseViewTitleContentType = .text
    @State private var titlePosition: VBaseViewModel.Layout.TitlePosition = .leading
    @State private var hasLeadingItem: Bool = false
    @State private var hasTrailingItem: Bool = false
    
    private var baseViewModel: VBaseViewModel {
        var model: VBaseViewModel = .init()
        
        model.layout.titlePosition = titlePosition
        
        return model
    }

    private var plainButtonModel: VPlainButtonModel = {
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        return model
    }()
}

// MARK:- Body
extension VBaseViewDemoView {
    @ViewBuilder var body: some View {
        switch titleContentType {
        case .text:
            VBaseView(
                model: baseViewModel,
                title: viewTitle,
                leadingItem: leadingItem,
                trailingItem: trailingItem,
                content: contentView
            )
            
        case .custom:
            VBaseView(
                model: baseViewModel,
                titleContent: viewContent,
                leadingItem: leadingItem,
                trailingItem: trailingItem,
                content: contentView
            )
        }
    }
    
    private func contentView() -> some View {
        DemoView(component: settings)  // Cannot be contained in VHalfModal, becase chaning title position causes glitches
    }
    
    private func settings() -> some View {
        VStack(spacing: 15, content: {
            VSegmentedPicker(selection: $titleContentType, headerTitle: "Title Content")
            
            VSegmentedPicker(selection: $titlePosition, headerTitle: "Title Position")
            
            ToggleSettingView(isOn: $hasLeadingItem, title: "Leading items")
            
            ToggleSettingView(isOn: $hasTrailingItem, title: "Trailing items")
        })
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder private func leadingItem() -> some View {
        if hasLeadingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item")
            })
        }
    }
    
    @ViewBuilder private func trailingItem() -> some View {
        if hasTrailingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 1")
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 2")
            })
        }
    }
    
    private var viewTitle: String { Self.navBarTitle }

    private func viewContent() -> some View {
        HStack(spacing: 5, content: {
            DemoIconContentView()
            
            VText(
                type: .oneLine,
                font: VBaseViewModel.Fonts().title,
                color: VBaseViewModel.Colors().titleText,
                title: viewTitle
            )
        })
    }
}

// MARK:- Helpers
extension VBaseViewModel.Layout.TitlePosition: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        @unknown default: fatalError()
        }
    }
}

private enum VBaseViewTitleContentType: Int, VPickableTitledItem {
    case text
    case custom
    
    var pickerTitle: String {
        switch self {
        case .text: return "Text"
        case .custom: return "Custom"
        }
    }
}

// MARK:- Preview
struct VBaseViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseViewDemoView()
    }
}
