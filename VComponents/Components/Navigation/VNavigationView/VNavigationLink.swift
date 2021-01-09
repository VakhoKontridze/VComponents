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
public struct VNavigationLink<Destination, Label>: View
    where
        Destination: View,
        Label: View
{
    // MARK: Properties
    private let destination: Destination
    private let label: () -> Label
    
    // MARK: Initializers
    public init(
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }
}

// MARK:- Body
public extension VNavigationLink {
    var body: some View {
        NavigationLink(
            destination: destination.environment(\.vNavigationViewBackButtonHidden, false),
            label: label
        )
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
