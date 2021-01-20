//
//  VWheelPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VComponents

// MARK:- V Wheel Picker Demo View
struct VWheelPickerDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Wheel Picker"

    @State private var wheelPickerSelection1: Items = .red
    @State private var wheelPickerSelection2: Items = .red
    @State private var wheelPickerSelection3: Int = 0
    @State private var wheelPickerSelection4: Items = .red
    @State private var wheelPickerSelection5: Items = .red
    @State private var wheelPickerSelection6: Items = .red
    @State private var wheelPickerState: VWheelPickerState = .enabled
    
    private enum Items: Int, VPickableTitledItem {
        case red
        case green
        case blue
        
        var pickerTitle: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
        
        var pickerSymbol: some View {
            let color: Color = {
                switch self {
                case .red: return .red
                case .green: return .green
                case .blue: return .blue
                }
            }()
            
            return DemoIconContentView(color: color)
        }
    }

    private let noLoweredOpacityWhenDisabledModel: VWheelPickerModel = {
        var model: VWheelPickerModel = .init()
        model.colors.content.disabledOpacity = 1
        return model
    }()
}

// MARK:- Body
extension VWheelPickerDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Text"), content: {
                    VWheelPicker(
                        selection: $wheelPickerSelection1,
                        state: wheelPickerState
                    )
                })
                
                DemoRowView(type: .titled("Image"), content: {
                    VWheelPicker(
                        selection: $wheelPickerSelection2,
                        state: wheelPickerState,
                        content: {
                            $0.pickerSymbol
                        }
                    )
                })
                
                DemoRowView(type: .titled("Image and Text"), content: {
                    VWheelPicker(
                        selectedIndex: $wheelPickerSelection3,
                        state: wheelPickerState,
                        data: Items.allCases,
                        content: { item in
                            HStack(spacing: 5, content: {
                                item.pickerSymbol
                                
                                VText(
                                    title: item.pickerTitle,
                                    color: ColorBook.primary,
                                    font: VWheelPickerModel.Fonts().rows,
                                    type: .oneLine
                                )
                            })
                        }
                    )
                })
                
                DemoRowView(type: .titled("Title"), content: {
                    VWheelPicker(
                        selection: $wheelPickerSelection4,
                        state: wheelPickerState,
                        title: "Lorem ipsum dolor sit amet"
                    )
                })
                
                DemoRowView(type: .titled("Title and description"), content: {
                    VWheelPicker(
                        selection: $wheelPickerSelection5,
                        state: wheelPickerState,
                        title: "Lorem ipsum dolor sit amet",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus."
                    )
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                    VWheelPicker(
                        model: noLoweredOpacityWhenDisabledModel,
                        selection: $wheelPickerSelection6,
                        state: wheelPickerState
                    )
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ControllerToggleView(
                state: .init(
                    get: { wheelPickerState == .disabled },
                    set: { wheelPickerState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Preview
struct VWheelPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VWheelPickerDemoView()
    }
}
