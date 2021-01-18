//
//  VSegmentedPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI
import VComponents

// MARK:- V Segmented Picker Demo View
struct VSegmentedPickerDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Segmented Picker"

    @State private var segmentedPickerSelection1: Options = .red
    @State private var segmentedPickerSelection2: Options = .red
    @State private var segmentedPickerSelection3: Int = 0
    @State private var segmentedPickerSelection4: Options = .red
    @State private var segmentedPickerSelection5: Options = .red
    @State private var segmentedPickerSelection6: Options = .red
    @State private var segmentedPickerSelection7: Options = .red
    @State private var segmentedPickerSelection8: Options = .red
    @State private var segmentedPickerSelection9: Options = .red
    @State private var segmentedPickerSelection10: Options = .red
    @State private var segmentedPickerState: VSegmentedPickerState = .enabled
    
    private enum Options: Int, CaseIterable, VPickerTitledEnumerableItem {
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
            
            return VDemoIconContentView(color: color)
        }
    }

    private let noAnimationSegmentedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.animation = nil
        return model
    }()
    
    private let noLoweredOpacityWhenPressedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.colors.content.pressedOpacity = 1
        return model
    }()
    
    private let noSmallerIndcatorWhenPressedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.layout.indicatorPressedScale = 1
        return model
    }()
    
    private let noLoweredOpacityWhenDisabledModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.colors.content.disabledOpacity = 1
        return model
    }()
}

// MARK:- Body
extension VSegmentedPickerDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Text"), content: {
                    VSegmentedPicker(
                        selection: $segmentedPickerSelection1,
                        state: segmentedPickerState
                    )
                })
                
                DemoRowView(type: .titled("Image"), content: {
                    VSegmentedPicker(
                        selection: $segmentedPickerSelection2,
                        state: segmentedPickerState,
                        content: {
                            $0.pickerSymbol
                        }
                    )
                })
                
                DemoRowView(type: .titled("Image and Text"), content: {
                    VSegmentedPicker(
                        selectedIndex: $segmentedPickerSelection3,
                        state: segmentedPickerState,
                        data: Options.allCases,
                        content: { option in
                            HStack(spacing: 5, content: {
                                option.pickerSymbol
                                
                                VBaseTitle(
                                    title: option.pickerTitle,
                                    color: ColorBook.primary,
                                    font: VSegmentedPickerModel.Fonts().rows,
                                    type: .oneLine
                                )
                            })
                        }
                    )
                })
                
                DemoRowView(type: .titled("Title"), content: {
                    VSegmentedPicker(
                        selection: $segmentedPickerSelection4,
                        state: segmentedPickerState,
                        title: "Lorem ipsum dolor sit amet"
                    )
                })
                
                DemoRowView(type: .titled("Title and Subtitle"), content: {
                    VSegmentedPicker(
                        selection: $segmentedPickerSelection5,
                        state: segmentedPickerState,
                        title: "Lorem ipsum dolor sit amet",
                        subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus."
                    )
                })
                
                DemoRowView(type: .titled("Disabled Row"), content: {
                    VSegmentedPicker(
                        selection: $segmentedPickerSelection6,
                        state: segmentedPickerState,
                        disabledItems: [.green]
                    )
                })
                
                DemoRowView(type: .titled("No Animation"), content: {
                    VSegmentedPicker(
                        model: noAnimationSegmentedModel,
                        selection: $segmentedPickerSelection7,
                        state: segmentedPickerState
                    )
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                    VSegmentedPicker(
                        model: noLoweredOpacityWhenPressedModel,
                        selection: $segmentedPickerSelection8,
                        state: segmentedPickerState
                    )
                })
                
                DemoRowView(type: .titled("No Smaller Indicator when Pressed"), content: {
                    VSegmentedPicker(
                        model: noSmallerIndcatorWhenPressedModel,
                        selection: $segmentedPickerSelection9,
                        state: segmentedPickerState
                    )
                })
                
                DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                    VSegmentedPicker(
                        model: noLoweredOpacityWhenDisabledModel,
                        selection: $segmentedPickerSelection10,
                        state: segmentedPickerState,
                        disabledItems: [.green]
                    )
                })
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ControllerToggleView(
                state: .init(
                    get: { segmentedPickerState == .disabled },
                    set: { segmentedPickerState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Preview
struct VSegmentedPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSegmentedPickerDemoView()
    }
}

struct VDemoIconContentView: View {
    private let dimension: CGFloat
    private let color: Color
    
    init(dimension: CGFloat = 15, color: Color = ColorBook.accent) {
        self.dimension = dimension
        self.color = color
    }
    
    var body: some View {
        Image(systemName: "swift")
            .resizable()
            .frame(dimension: dimension)
            .foregroundColor(color)
    }
}
