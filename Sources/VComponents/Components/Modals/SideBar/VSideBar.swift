//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Side Bar
/// Modal component that draws a from left side with background, hosts content, and is present when condition is `true`.
///
/// Model can be passed as parameter.
///
/// `vSideBar` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vSideBar(isPresented: $isPresented, sideBar: {
///                 VSideBar(content: {
///                     ColorBook.accent
///                 })
///             })
///     }
///
public struct VSideBar<Content> where Content: View {
    // MARK: Properties
    fileprivate let model: VSideBarModel
    fileprivate let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with content.
    public init(
        model: VSideBarModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

// MARK: - Extension
extension View {
    /// Presents `VSideBar` when boolean is `true`.
    public func vSideBar<Content>(
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        sideBar: @escaping () -> VSideBar<Content>
    ) -> some View
        where Content: View
    {
        let sideBar = sideBar()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    _VSideBar(
                        model: sideBar.model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: sideBar.content
                    )
                }
            ))
    }
    
    /// Presents `VSideBar` using the item as data source for content.
    @ViewBuilder public func vSideBar<Item, Content>(
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        sideBar: @escaping (Item) -> VSideBar<Content>
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            vSideBar(
                isPresented: .init(
                    get: { true },
                    set: { _ in item.wrappedValue = nil }
                ),
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                sideBar: { sideBar(_item) }
            )
        }
    }
}
