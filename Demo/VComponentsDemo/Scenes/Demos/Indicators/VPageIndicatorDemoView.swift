//
//  VPageIndicatorDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import Combine
import VComponents
import VCore

// MARK: - V Page Indicator Demo View
struct VPageIndicatorDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Page Indicator" }
    
    private let total: Int = 15
    @State private var selectedIndex: Int = 0
    
    @State private var pageIndicatorType: VPageIndicatorTypeHelper = .automatic
    @State private var direction: OmniLayoutDirection = .leftToRight

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect().eraseToAnyPublisher(), perform: updateValue)
    }
    
    private func component() -> some View {
        DemoTitledSettingView(
            title: "\(selectedIndex+1)/\(total)",
            content: {
                VPageIndicator(
                    type: {
                        switch pageIndicatorType {
                        case .standard:
                            return .standard(uiModel: {
                                var uiModel: VPageIndicatorStandardUIModel = .init()
                                uiModel.layout.direction = direction
                                return uiModel
                            }())
                        
                        case .compact:
                            return .compact(uiModel: {
                                var uiModel: VPageIndicatorCompactUIModel = .init()
                                uiModel.layout.direction = direction
                                return uiModel
                            }())
                        
                        case .automatic:
                            return .automatic(uiModel: {
                                var uiModel: VPageIndicatorAutomaticUIModel = .init()
                                uiModel.layout.direction = direction
                                return uiModel
                            }())
                        }
                    }(),
                    total: total,
                    selectedIndex: selectedIndex
                )
            }
        )
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $pageIndicatorType, headerTitle: "Type")
        
        VWheelPicker(selection: $direction, headerTitle: "Direction")
    }

    // MARK: Timer
    fileprivate func updateValue(_ output: Date) {
        var valueToSet: Int = selectedIndex + 1
        if valueToSet > total-1 { valueToSet = 0 }
        
        selectedIndex = valueToSet
    }
}

// MARK: - Helpers
private enum VPageIndicatorTypeHelper: Int, StringRepresentableHashableEnumeration {
    case standard
    case compact
    case automatic
    
    var stringRepresentation: String {
        switch self {
        case .standard: return "Standard"
        case .compact: return "Compact"
        case .automatic: return "Automatic"
        }
    }
}

extension OmniLayoutDirection: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .leftToRight: return "Left-to-right"
        case .rightToLeft: return "Right-to-bottom"
        case .topToBottom: return "Top-to-bottom"
        case .bottomToTop: return "Bottom-to-top"
        }
    }
}

// MARK: - Preview
struct VPageIndicatorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorDemoView()
    }
}
