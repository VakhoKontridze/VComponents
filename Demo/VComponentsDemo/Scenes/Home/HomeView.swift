//
//  HomeView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore
import VComponents

// MARK: - Home View
struct HomeView: View {
    // MARK: Properties
    private static var navBarTitle: String { "VComponents Demo" }

    // MARK: Body
    var body: some View {
        NavigationView(content: {
            DemoListView(type: .disclosureGroup, sections: HomeRow.sections)
                .standardNavigationTitle(Self.navBarTitle)
        })
            .navigationViewStyle(.stack)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
