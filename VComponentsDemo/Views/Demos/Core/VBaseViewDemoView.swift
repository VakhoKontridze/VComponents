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
    static let navigationBarTitle: String = "Base View"
    
    @State private var titlePosition: VBaseViewModel.Layout.TitlePosition = .leading
    @State private var hasLeadingItem: Bool = false
    @State private var hasTrailingItem: Bool = false
    
    private var baseViewModel: VBaseViewModel {
        var model: VBaseViewModel = .init()
        
        model.layout.titlePosition = titlePosition
        
        return model
    }

    private var segmentedPickerModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.animations.selection = nil
        return model
    }()
    
    private var plainButtonModel: VPlainButtonModel = {
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        return model
    }()
}

// MARK:- Body
extension VBaseViewDemoView {
    var body: some View {
        VBaseView(
            model: baseViewModel,
            title: Self.navigationBarTitle,
            leadingItem: leadingItem,
            trailingItem: trailingItem,
            content: {
                DemoView(type: .section, content: {
                    VStack(spacing: 20, content: {
                        VSegmentedPicker(
                            model: segmentedPickerModel,
                            selection: $titlePosition,
                            title: "Title Position"
                        )
                        
                        ToggleSettingView(isOn: $hasLeadingItem, title: "Leading items")
                        
                        ToggleSettingView(isOn: $hasTrailingItem, title: "Trailing items")
                    })
                })
            }
        )
    }
    
    @ViewBuilder func leadingItem() -> some View {
        if hasLeadingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item")
            })
        }
    }
    
    @ViewBuilder func trailingItem() -> some View {
        if hasTrailingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 1")
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 2")
            })
        }
    }
}

// MARK:- Helpers
extension VBaseViewModel.Layout.TitlePosition: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        }
    }
}

// MARK:- Preview
struct VBaseViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseViewDemoView()
    }
}
