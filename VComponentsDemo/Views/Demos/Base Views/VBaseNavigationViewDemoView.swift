//
//  VBaseNavigationViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Base Navigation View and Base View Demo View
struct VBaseNavigationViewDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base Navigation View"
}

// MARK:- Body
extension VBaseNavigationViewDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            ScrollView(showsIndicators: false, content: {
                HomeSectionView(title: nil, content: {
                    HomeRowView(
                        title: "Filled",
                        action: { SceneDelegate.setRootView(to: NavigationDemoView1(type: .filled())) }
                    )
                    
                    HomeRowView(
                        title: "Transparent",
                        action: { SceneDelegate.setRootView(to: NavigationDemoView1(type: .transparent())) },
                        showSeparator: false
                    )
                })
            })
                .padding(10)
        })
            .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
    }
}

// MARK:- Walkthrough
private struct NavigationDemoView1: View {
    private let type: VBaseNavigationViewType
    
    init(type: VBaseNavigationViewType) {
        self.type = type
    }
}

extension NavigationDemoView1 {
    var body: some View {
        VBaseNavigationView(type, content: {
            VBaseView(title: "Home", content: {
                NavigationDemoView(
                    color: .red,
                    instruction: [
                        "You are on Home page",
                        "From here you can navigate to Details"
                    ].joined(separator: "\n\n"),
                    destination: NavigationDemoView2()
                )
            })
        })
    }
}

private struct NavigationDemoView2: View {
    var body: some View {
        VBaseView(title: "Details", content: {
            NavigationDemoView(
                color: .green,
                instruction: [
                    "You are on Details page",
                    "From here you can navigate back, or go futher to Additional Details"
                ].joined(separator: "\n\n"),
                destination: NavigationDemoView3()
            )
        })
    }
}

private struct NavigationDemoView3: View {
    var body: some View {
        VBaseView(title: "Additional Details", content: {
            NavigationDemoView(
                color: .green,
                instruction: [
                    "You are on Additional Details page",
                    "From here you can navigate back, or jump to new the navigation stack"
                ].joined(separator: "\n\n"),
                action: { SceneDelegate.setRootView(to: HomeView()) }
            )
        })
    }
}

// MARK:- Navigation Demo View
private struct NavigationDemoView<Destination>: View where Destination: View {
    // MARK: Properties
    private let color: Color
    
    private let instruction: String
    
    private let action: ActionType
    enum ActionType {
        case navigation(_ destination: Destination)
        case custom(_ action: () -> Void)
    }
    
    // MARK: Initializers
    init(
        color: Color,
        instruction: String,
        destination: Destination
    ) {
        self.color = color
        self.instruction = instruction
        self.action = .navigation(destination)
    }
}

extension NavigationDemoView where Destination == Never {
    init(
        color: Color,
        instruction: String,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.instruction = instruction
        self.action = .custom(action)
    }
}
    
extension NavigationDemoView {
    var body: some View {
        ZStack(content: {
            color
                .opacity(0.25)
                .edgesIgnoringSafeArea(.all)
            
            Text(instruction)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .multilineTextAlignment(.center)
            
            switch action {
            case .navigation(let desitnation): NavigationLink("Continue", destination: desitnation)
            case .custom(let action): Button("Continue", action: action)
            }
        })
    }
}

// MARK:- Preview
struct VBaseNavigationViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseNavigationViewDemoView()
    }
}
