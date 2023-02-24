//
//  VSideBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Side Bar Demo View
struct VSideBarDemoView: View {
    static var navBarTitle: String { "Side Bar" }
    
    @State private var isPresented: Bool = false
    @State private var presentationEdge: VSideBarUIModel.Layout.PresentationEdge = .default
    @State private var dismissType: VSideBarUIModel.Misc.DismissType = .default
    
    private var uiModel: VSideBarUIModel {
        var uiModel: VSideBarUIModel = presentationEdge.uiModel
        
        uiModel.misc.dismissType = dismissType
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settingsSections: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vSideBar(
                id: "side_bar_demo",
                uiModel: uiModel,
                isPresented: $isPresented,
                content: { sideBarContent }
            )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $presentationEdge, headerTitle: "Presentation Edge")
        })
        
        DemoViewSettingsSection(content: {
            VStack(spacing: 3, content: {
                VText(color: ColorBook.primary, font: .callout, text: "Dismiss Method:")
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(content: {
                        ForEach(VSideBarUIModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                            dismissTypeView(position)
                        })
                    })
                })
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
    }
    
    private func dismissTypeView(_ position: VSideBarUIModel.Misc.DismissType) -> some View {
        VCheckBox(
            uiModel: {
                var uiModel: VCheckBoxUIModel = .init()
                uiModel.layout.titleLineType = .singleLine
                return uiModel
            }(),
            isOn: .init(
                get: { dismissType.contains(position) },
                set: { isOn in
                    if isOn {
                        dismissType.insert(position)
                    } else {
                        dismissType.remove(position)
                    }
                }
            ),
            title: position.title
        )
    }

    private var sideBarContent: some View {
        ZStack(content: {
            List(content: {
                ForEach(0..<40, content: { num in
                    VListRow(separator: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                })
            })
                .vListStyle()
                .padding(.vertical, 1) // Fixes SwiftUI `ScrollView` safe area bug

            if dismissType.isEmpty {
                NoDismissTypeWarningView(onDismiss: { isPresented = false })
            }
        })
    }
}

// MARK: - Helpers
extension VSideBarUIModel.Layout.PresentationEdge: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        case .top: return "Top"
        case .bottom: return "Bottom"
        }
    }
}

extension VSideBarUIModel.Misc.DismissType {
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
