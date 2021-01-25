//
//  VTabNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View
/// Navigation component that switches between multiple views using interactive user interface elements
///
/// Model can be passed as parameter
///
/// Due to the limitations of TabView, tab items only support `Text` and  `Image`
///
/// # Usage Example #
///
/// ```
/// @State var selection: Int = 0
///
/// func item(_ title: String) -> some View {
///     VStack(spacing: 5, content: {
///         Image(systemName: "swift")
///             .resizable()
///             .frame(width: 20, height: 20)
///
///         Text(title)
///     })
/// }
///
/// var body: some View {
///     VTabNavigationView(
///         selection: $selection,
///         pageOne: VTabNavigationViewPage(
///             item: item("Red"),
///             content: Color.red
///         ),
///         pageTwo: VTabNavigationViewPage(
///             item: item("Green"),
///             content: Color.green
///         ),
///         pageThree: VTabNavigationViewPage(
///             item: item("Blue"),
///             content: Color.blue
///         ),
///         pageFour: VTabNavigationViewPage(
///             item: item("Pink"),
///             content: Color.pink
///         ),
///         pageFive: VTabNavigationViewPage(
///             item: item("Orange"),
///             content: Color.orange
///         )
///     )
/// }
/// ```
///
public struct VTabNavigationView<C0, C1, C2, C3, C4, C5, ItemContent>: View
    where
        C0: View,
        C1: View,
        C2: View,
        C3: View,
        C4: View,
        C5: View,
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
    private let pageSix: VTabNavigationViewPage<C5, ItemContent>?
    
    // MARK: Initializers
    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>,
        pageThree: VTabNavigationViewPage<C2, ItemContent>,
        pageFour: VTabNavigationViewPage<C3, ItemContent>,
        pageFive: VTabNavigationViewPage<C4, ItemContent>
    )
        where C5 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = pageFour
        self.pageFive = pageFive
        self.pageSix = nil
    }
    
    public init(
        model: VTabNavigationViewModel = .init(),
        selection: Binding<Int>,
        pageOne: VTabNavigationViewPage<C0, ItemContent>,
        pageTwo: VTabNavigationViewPage<C1, ItemContent>,
        pageThree: VTabNavigationViewPage<C2, ItemContent>,
        pageFour: VTabNavigationViewPage<C3, ItemContent>
    )
        where
            C4 == Never,
            C5 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = pageFour
        self.pageFive = nil
        self.pageSix = nil
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
            C4 == Never,
            C5 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = pageThree
        self.pageFour = nil
        self.pageFive = nil
        self.pageSix = nil
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
            C4 == Never,
            C5 == Never
    {
        self.model = model
        self._selection = selection
        self.pageOne = pageOne
        self.pageTwo = pageTwo
        self.pageThree = nil
        self.pageFour = nil
        self.pageFive = nil
        self.pageSix = nil
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
            if let page = pageSix { pageContent(page).tag(5) }
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
        VTabNavigationView<Color, Color, Color, Never, Never, Never, Text>(
            model: .init(),
            selection: .constant(0),
            pageOne: pageOne,
            pageTwo: pageTwo,
            pageThree: pageThree
        )
    }
}
