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
//        NavigationView(content: {
//            DemoListView(sections: HomeRow.sections)
//                .standardNavigationTitle(Self.navBarTitle)
//        })
//            .navigationViewStyle(.stack)
        ZStack(alignment: .top, content: {
            ColorBook.canvas.ignoresSafeArea()
            
            VSheet(content: {
                VList(
                    uiModel: {
                        var uiModel: VListUIModel = .init()
                        uiModel.layout.showsFirstSeparator = false
                        uiModel.layout.showsLastSeparator = false
                        return uiModel
                    }(),
                    data: 0..<5,
                    content: { num in
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )

            })
                .padding()
        })
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
