//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Side Bar
/// Modal component that draws a from left side with background, hosts content, and is present when condition is true.
///
/// Model can be passed as parameter.
///
/// `vSideBar` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen.
///
/// Usage Example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VSecondaryButton(
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
    /// Presents `VSideBar`.
    public func vSideBar<Content>(
        isPresented: Binding<Bool>,
        sideBar: @escaping () -> VSideBar<Content>
    ) -> some View
        where Content: View
    {
        let sideBar = sideBar()
        
        return self
            .overlay(Group(content: {
                if isPresented.wrappedValue {
                    WindowOverlayView(
                        isPresented: isPresented,
                        content:
                            _VSideBar(
                                model: sideBar.model,
                                isPresented: isPresented,
                                content: sideBar.content
                            )
                    )
                }
            }))
    }
}
