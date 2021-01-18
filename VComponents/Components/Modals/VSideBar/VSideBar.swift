//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar
/// Modal component that draws a from left side with background, hosts content, and is present when condition is true
///
/// Model, and onAppear and onDisappear callbacks can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///         .vSideBar(isPresented: $isPresented, sideBar: {
///             VSideBar(content: {
///                 ColorBook.accent
///             })
///         })
/// }
/// ```
///
public struct VSideBar<Content> where Content: View {
    // MARK: Properties
    public var model: VSideBarModel
    
    public var content: () -> Content
    
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    public init(
        model: VSideBarModel = .init(),
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
extension View {
    /// Presents side bar
    public func vSideBar<Content>(
        isPresented: Binding<Bool>,
        sideBar: @escaping () -> VSideBar<Content>
    ) -> some View
        where Content: View
    {
        ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                VSideBarVCRepresentable(
                    isPresented: isPresented,
                    content: _VSideBar(isPresented: isPresented, sideBar: sideBar()),
                    blinding: sideBar().model.colors.blinding.edgesIgnoringSafeArea(.all),
                    contentWidth: sideBar().model.layout.widthType.width,
                    onBackTap: { withAnimation { isPresented.wrappedValue = false } }
                )
            }
        })
    }
}
