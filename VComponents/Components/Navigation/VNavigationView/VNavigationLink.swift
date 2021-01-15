//
//  VNavigationLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/9/21.
//

import SwiftUI

// MARK:- V Navigation View Back Button Hidden
struct VNavigationViewBackButtonHidden: EnvironmentKey {
    static var defaultValue: Bool = true
}

extension EnvironmentValues {
    var vNavigationViewBackButtonHidden: Bool {
        get { self[VNavigationViewBackButtonHidden.self] }
        set { self[VNavigationViewBackButtonHidden.self] = newValue }
    }
}

// MARK:- V Navigation Link
/// Button that controls a navigation presentation
///
/// Can be initialized with destination and label
/// Can be initialized with destination, activation state, and label
public struct VNavigationLink<Destination, Label>: View
    where
        Destination: View,
        Label: View
{
    // MARK: Properties
    private let linkType: LinkType
    private enum LinkType {
        case interactive
        case stateTriggered
    }
    
    private let destination: Destination
    @Binding private var isActive: Bool
    private let label: () -> Label
    
    // MARK: Initializers
    public init(
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.linkType = .interactive
        
        self.destination = destination
        self._isActive = .constant(false)
        self.label = label
    }
    
    public init(
        destination: Destination,
        isActive: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.linkType = .stateTriggered
        
        self.destination = destination
        self._isActive = isActive
        self.label = label
    }
}

// MARK:- Body
extension VNavigationLink {
    @ViewBuilder public var body: some View {
        switch linkType {
        case .interactive: NavigationLink(destination: destinationView, label: label)
        case .stateTriggered: NavigationLink(destination: destinationView, isActive: $isActive, label: label)
        }
    }
    
    private var destinationView: some View {
        destination.environment(\.vNavigationViewBackButtonHidden, false)
    }
}

// MARK:- Preview
struct VNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationView(content: {
            VBaseView(title: "Home", content: {
                VNavigationLink(destination: Color.red, label: { Text("Go to Details") })
            })
        })
    }
}
