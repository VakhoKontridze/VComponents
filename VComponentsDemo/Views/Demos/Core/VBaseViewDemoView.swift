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
    
    @State private var titlePosition: TitlePosition = .leading
    @State private var hasLeadingItem: Bool = false
    @State private var hasTrailingItem: Bool = false
    
    private enum TitlePosition: Int, CaseIterable, VPickerTitledEnumerableItem {
        case leading
        case center
        
        var pickerTitle: String {
            switch self {
            case .leading: return "Leading"
            case .center: return "Center"
            }
        }
    }
    
    var viewModel: VBaseViewModel {
        switch titlePosition {
        case .leading: return .leadingTitle()
        case .center: return .centerTitle()
        }
    }
    
    private var segmentedPickerModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        
        model.animation = nil
        
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
            model: viewModel,
            title: Self.navigationBarTitle,
            leadingItem: leadingItem,
            trailingItem: trailingItem,
            content: {
                DemoView(type: .section, content: {
                    VStack(spacing: 20, content: {
                        VSegmentedPicker(
                            model: segmentedPickerModel,
                            selection: $titlePosition,
                            title: "Title Position",
                            subtitle: "Changing title position causes view to re-draw itself"
                        )
                        
                        VToggle(isOn: $hasLeadingItem, title: "Leading items").frame(maxWidth: .infinity, alignment: .leading)
                        
                        VToggle(isOn: $hasTrailingItem, title: "Trailing items").frame(maxWidth: .infinity, alignment: .leading)
                    })
                })
            }
        )
    }
    
    @ViewBuilder var leadingItem: some View {
        if hasLeadingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item")
            })
        }
    }
    
    @ViewBuilder var trailingItem: some View {
        if hasTrailingItem {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 1")
                VPlainButton(model: plainButtonModel, action: {}, title: "Item 2")
            })
        }
    }
}

// MARK:- Preview
struct VBaseViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseViewDemoView()
    }
}
