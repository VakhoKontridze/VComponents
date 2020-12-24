//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar
public struct VSideBar<Content>: View where Content: View {
    // MARK: Properties
    private let sideBarType: VSideBarType
    @Binding private var isPresented: Bool
    private let dismissAction: (() -> Void)?
    private let content: Content

    // MARK: Initializers
    public init(
        _ sideBarType: VSideBarType = .default,
        isPresented: Binding<Bool>,
        onDismiss dismissAction: (() -> Void)? = nil,
        content: Content
    ) {
        self.sideBarType = sideBarType
        self._isPresented = isPresented
        self.dismissAction = dismissAction
        self.content = content
    }
}

// MARK:- Body
public extension VSideBar {
    @ViewBuilder var body: some View {
        switch sideBarType {
        case .standard(let model): VSideBarStandard(model: model, isPresented: $isPresented, dismiss: dismiss, content: content)
        }
    }
}

// MARK:- Actions
private extension VSideBar {
    func dismiss() {
        dismissAction?()
        withAnimation { isPresented = false }
    }
}

// MARK:- Preview
struct VSideBar_Previews: PreviewProvider {
    static var previews: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .vSideBar(isPresented: .constant(true), content: Color.blue)
    }
}
