//
//  VSideBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents

// MARK: - V Side Bar Demo View
struct VSideBarDemoView: View {
    static var navBarTitle: String { "Side Bar" }
    
    @State private var isPresented: Bool = false
    @State private var dismissType: VSideBarModel.Misc.DismissType = .default
    
    private var model: VSideBarModel {
        var model: VSideBarModel = .init()
        
        model.misc.dismissType = dismissType
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vSideBar(isPresented: $isPresented, sideBar: {
                VSideBar(
                    model: model,
                    content: { sideBarContent }
                )
            })
    }
    
    private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VStack(spacing: 3, content: {
                VText(color: ColorBook.primary, font: .callout, title: "Dismiss Method:")
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(content: {
                        ForEach(VSideBarModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                            dismissTypeView(position)
                        })
                    })
                })
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
    }
    
    private func dismissTypeView(_ position: VSideBarModel.Misc.DismissType) -> some View {
        VCheckBox(
            model: {
                var model: VCheckBoxModel = .init()
                model.layout.titleLineLimit = 1
                return model
            }(),
            isOn: .init(
                get: { dismissType.contains(position) },
                set: { isOn in
                    switch isOn {
                    case false: dismissType.remove(position)
                    case true: dismissType.insert(position)
                    }
                }
            ),
            title: position.title
        )
    }

    private var sideBarContent: some View {
        ZStack(content: {
            VList(data: 0..<40, rowContent: { num in
                Text(String(num))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            
            if dismissType.isEmpty {
                NoDismissTypeWarningView(onDismiss: { isPresented = false })
            }
        })
    }
}

// MARK: - Helpers
extension VSideBarModel.Misc.DismissType {
    fileprivate var title: String {
        switch self {
        case .backTap: return "Back tap"
        case .dragBack: return "Drag back"
        default: fatalError()
        }
    }
}

// MARK: - Preview
struct VSideBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSideBarDemoView()
    }
}
