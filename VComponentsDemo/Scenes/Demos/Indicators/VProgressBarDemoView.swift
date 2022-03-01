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
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var useAnimation: Bool = VProgressBarModel.Animations().progress != nil
    
    private var model: VProgressBarModel {
        let defaultModel: VProgressBarModel = .init()
        
        var model: VProgressBarModel = .init()
        model.animations.progress = useAnimation ? (defaultModel.animations.progress != nil ? defaultModel.animations.progress : .default) : nil
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
            .onReceive(timer, perform: updateValue)
    }
    
    @ViewBuilder private func component() -> some View {
        VSliderDemoView.sliderRowView(title: .init(value), content: {
            VProgressBar(value: value)
        })
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

// MARK: Preview
struct VProgressBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VProgressBarDemoView()
    }
}
