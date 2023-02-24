//
//  VProgressBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import Combine
import VComponents

// MARK: - V Spinner Demo View
struct VProgressBarDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Progress Bar" }
    
    @State private var value: Double = 0.5
    
    @State private var useAnimation: Bool = VProgressBarUIModel.Animations().progress != nil
    
    private var uiModel: VProgressBarUIModel {
        let defaultUIModel: VProgressBarUIModel = .init()
        
        var uiModel: VProgressBarUIModel = .init()
        uiModel.animations.progress = useAnimation ? (defaultUIModel.animations.progress != nil ? defaultUIModel.animations.progress : .default) : nil
        
        return uiModel
    }

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
            value: value,
            content: { VProgressBar(value: value) }
        )
    }
    
    @ViewBuilder private func settings() -> some View {
        ToggleSettingView(isOn: $useAnimation, title: "Progress Animation")
    }

    // MARK: Timer
    fileprivate func updateValue(_ output: Date) {
        let increment: Double = 0.05
        var valueToSet: Double = value + increment
        if valueToSet >= 1 + increment { valueToSet = 0 }
        
        value = valueToSet
    }
}

// MARK: - Preview
struct VProgressBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VProgressBarDemoView()
    }
}
