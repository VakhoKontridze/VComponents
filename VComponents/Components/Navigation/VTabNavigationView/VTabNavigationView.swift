//
//  VTabNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View
public struct VTabNavigationView<C0, C1, C2, C3, C4, ItemContent>: View
    where
        C0: View,
        C1: View,
        C2: View,
        C3: View,
        C4: View,
        ItemContent: View
{
    // MARK: Properties
    private let model: VTabNavigationViewModel
    
    @Binding private var selection: Int

    private let pageOne: VTabNavigationViewPage<C0, ItemContent>?
    private let pageTwo: VTabNavigationViewPage<C1, ItemContent>?
    private let pageThree: VTabNavigationViewPage<C2, ItemContent>?
    private let pageFour: VTabNavigationViewPage<C3, ItemContent>?
    private let pageFive: VTabNavigationViewPage<C4, ItemContent>?
    
    // MARK: Initializers
    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>,
        pageThree: VTabNavigationViewPage<C2, ItemContent>,
        pageFour: VTabNavigationViewPage<C3, ItemContent>,
        pageFive: VTabNavigationViewPage<C4, ItemContent>
    ) {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = pageFour
        self.pageFive = pageFive
    }
    
    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>,
        pageThree: VTabNavigationViewPage<C2, ItemContent>,
        pageFour: VTabNavigationViewPage<C3, ItemContent>
    )
        where C4 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = pageFour
        self.pageFive = nil
    }
    
    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>,
        pageThree: VTabNavigationViewPage<C2, ItemContent>
    )
        where
            C3 == Never,
            C4 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = nil
        self.pageFive = nil
    }

    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>
    )
        where
            C2 == Never,
            C3 == Never,
            C4 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = nil
        self.pageFour = nil
        self.pageFive = nil
    }
}

// MARK:- Body
extension VTabNavigationView {
    public var body: some View {
        TabView(selection: $selection, content: {
            if let page = pageOne { pageContent(page).tag(0) }
            if let page = pageTwo { pageContent(page).tag(1) }
            if let page = pageThree { pageContent(page).tag(2) }
            if let page = pageFour { pageContent(page).tag(3) }
            if let page = pageFive { pageContent(page).tag(4) }
        })
            .setUpTabNavigationViewAppearance(model: model)
    }
    
    private func pageContent<PageContent>(
        _ page: VTabNavigationViewPage<PageContent, ItemContent>
    ) -> some View
        where PageContent: View
    {
        let originalAccentColor: Color = Color(UIColor(Color.accentColor).cgColor)
        
        return page.content
            .accentColor(originalAccentColor)
            .tabItem { page.item }
    }
}

// MARK: Preview
struct VTabNavigationView_Previews: PreviewProvider {
    private static let pageOne = VTabNavigationViewPage(item: Text("Red"), content: Color.red)
    private static let pageTwo = VTabNavigationViewPage(item: Text("Green"), content: Color.green)
    private static let pageThree = VTabNavigationViewPage(item: Text("Blue"), content: Color.blue)
    
    static var previews: some View {
        VTabNavigationView<Color, Color, Color, Never, Never, Text>(
            model: .init(),
            selection: .constant(0),
            pageOne: pageOne,
            pageTwo: pageTwo,
            pageThree: pageThree
        )
    }
}
