//
//  VProgressBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import Combine
import VComponents

// MARK:- V Spinner Demo View
struct VProgressBarDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Progress Bar"
    
    @State private var useAnimation: Bool = true
    
    @State private var value: Double = 0.5
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

// MARK:- Body
extension VProgressBarDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Default"), content: {
                    VProgressBar(value: value)
                })
            })
        })
            .onReceive(timer, perform: updateValue)
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                state: .init(
                    get: { useAnimation ? .on : .off },
                    set: { useAnimation = $0.isOn }
                ),
                title: "Animation"
            )
        })
    }
}

// MARK:- Timer
private extension VProgressBarDemoView {
    func updateValue(_ output: Date) {
        let increment: Double = 0.05
        var valueToSet: Double = value + increment
        if valueToSet >= 1 + increment { valueToSet = 0 }
        
        switch useAnimation {
        case false: value = valueToSet
        case true: withAnimation { value  = valueToSet }
        }
    }
}

// MARK: Preview
struct VProgressBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VProgressBarDemoView()
    }
}
