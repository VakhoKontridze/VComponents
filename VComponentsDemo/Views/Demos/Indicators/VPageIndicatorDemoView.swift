//
//  VPageIndicatorDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import Combine
import VComponents

// MARK:- V Page Indicator Demo VIew
struct VPageIndicatorDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Page Indicator"
    
    private let total: Int = 15
    @State private var selectedIndex: Int = 0
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var pageIndicatorType: VPageIndicatorTypeHelper = VPageIndicatorType.default.helperType
}

// MARK:- Body
extension VPageIndicatorDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
            .onReceive(timer, perform: updateValue)
    }
    
    @ViewBuilder private func component() -> some View {
        VSliderDemoView.sliderRowView(title: "\(selectedIndex+1)/\(total)", content: {
            VPageIndicator(
                type: pageIndicatorType.indicatorType,
                total: total,
                selectedIndex: selectedIndex
            )
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: $pageIndicatorType,
            headerTitle: "Type",
            footerTitle: pageIndicatorType.description
        )
    }
}

// MARK:- Timer
private extension VPageIndicatorDemoView {
    func updateValue(_ output: Date) {
        var valueToSet: Int = selectedIndex + 1
        if valueToSet > total-1 { valueToSet = 0 }
        
        selectedIndex = valueToSet
    }
}

// MARK:- Helpers
private enum VPageIndicatorTypeHelper: Int, VPickableTitledItem {
    case finite
    case infinite
    case auto
    
    var pickerTitle: String {
        switch self {
        case .finite: return "Finite"
        case .infinite: return "Infinite"
        case .auto: return "Auto"
        }
    }
    
    var description: String {
        switch self {
        case .finite: return "Finite number of dots would be displayed"
        case .infinite: return "Infinite dots are possible, but limited number are displayed. Scrolling with acrousel effect may become enabled."
        case .auto: return "Type that switches between \"Finite\" and \"Infinite\""
        }
    }
    
    var indicatorType: VPageIndicatorType {
        switch self {
        case .finite: return .finite
        case .infinite: return .infinite()
        case .auto: return .auto()
        }
    }
}

private extension VPageIndicatorType {
    var helperType: VPageIndicatorTypeHelper {
        switch self {
        case .finite: return .finite
        case .infinite: return .infinite
        case .auto: return .auto
        @unknown default: fatalError()
        }
    }
}

// MARK:- Preview
struct VPageIndicatorDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPageIndicatorDemoView()
    }
}
