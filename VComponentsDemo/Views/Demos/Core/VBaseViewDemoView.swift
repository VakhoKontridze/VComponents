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
    
    @State private var navigationBarTitlePosition: NavigationBarTitlePosition = .leading
    @State private var navigationBarLeadingItem: VToggleState = .off
    @State private var navigationBarTrailingItemState: VToggleState = .off
    
    private enum NavigationBarTitlePosition: Int, CaseIterable, VPickerTitledEnumerableOption {
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
        switch navigationBarTitlePosition {
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
        
        model.layout.hitBoxSpacingX = 0
        model.layout.hitBoxSpacingY = 0
        
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
                    VStack(alignment: .leading, spacing: 20, content: {
                        VSegmentedPicker(
                            model: segmentedPickerModel,
                            selection: $navigationBarTitlePosition,
                            title: "Title Position",
                            subtitle: "Changing title position causes view to re-draw itself"
                        )
                        
                        VToggle(state: $navigationBarLeadingItem, title: "Leading items")
                        
                        VToggle(state: $navigationBarTrailingItemState, title: "Trailing items")
                    })
                })
            }
        )
    }
    
    @ViewBuilder var leadingItem: some View {
        if navigationBarLeadingItem.isOn {
            HStack(content: {
                VPlainButton(model: plainButtonModel, action: {}, title: "Item")
            })
        }
    }
    
    @ViewBuilder var trailingItem: some View {
        if navigationBarTrailingItemState.isOn {
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
