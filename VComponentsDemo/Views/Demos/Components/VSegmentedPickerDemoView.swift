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
    
    private let segmentedPickerTitles: [String] = ["One", "Two", "Three"]
    private let segmentedPickerContents: [VDemoIconContentView] = [Color.red, .green, .blue].map { VDemoIconContentView(dimension: 15, color: $0) }
    
    @State private var segmentedPickerSelection1: Int = 0
    @State private var segmentedPickerSelection2: Int = 0
    @State private var segmentedPickerSelection3: Int = 0
    @State private var segmentedPickerSelection4: Int = 0
    @State private var segmentedPickerSelection5: Int = 0
    @State private var segmentedPickerSelection6: Int = 0
    @State private var segmentedPickerSelection7: Int = 0
    @State private var segmentedPickerSelection8: Int = 0
    @State private var segmentedPickerState: VSegmentedPickerState = .enabled
    
    private let noAnimationSegmentedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.behavior.selectionAnimation = nil
        return model
    }()
    
    private let noLoweredOpacityWhenPressedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.colors.pressedOpacity = 1
        return model
    }()
    
    private let noSmallerIndcatorWhenPressedModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.layout.indicatorPressedScale = 1
        return model
    }()
    
    private let noLoweredOpacityWhenDisabledModel: VSegmentedPickerModel = {
        var model: VSegmentedPickerModel = .init()
        model.colors.disabledOpacity = 1
        return model
    }()
}

// MARK:- Body
extension VSegmentedPickerDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, controller: { controller }, content: {
            DemoRowView(type: .titled("Text"), content: {
                VSegmentedPicker(
                    selection: $segmentedPickerSelection1,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.map { VSegmentedPickerTextRow(title: $0) }
                )
            })
            
            DemoRowView(type: .titled("Image"), content: {
                VSegmentedPicker(
                    selection: $segmentedPickerSelection2,
                    state: segmentedPickerState,
                    data: segmentedPickerContents.map { VSegmentedPickerRow(content: $0) }
                )
            })
            
            DemoRowView(type: .titled("Image and Text"), content: {
                VSegmentedPicker(
                    selection: $segmentedPickerSelection3,
                    state: segmentedPickerState,
                    data: segmentedPickerContents.indices.map { i in
                        .init(content:
                            HStack(spacing: 5, content: {
                                segmentedPickerContents[i]
                                Text(segmentedPickerTitles[i])
                            })
                        )
                    }
                )
            })
            
            DemoRowView(type: .titled("Disabled Row"), content: {
                VSegmentedPicker(
                    selection: $segmentedPickerSelection4,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.enumerated().map { VSegmentedPickerTextRow(title: $1, isEnabled: $0 != 1) }
                )
            })
            
            DemoRowView(type: .titled("No Animation"), content: {
                VSegmentedPicker(
                    model: noAnimationSegmentedModel,
                    selection: $segmentedPickerSelection5,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.map { VSegmentedPickerTextRow(title: $0) }
                )
            })
            
            DemoRowView(type: .titled("No Lowered Opacity when Pressed"), content: {
                VSegmentedPicker(
                    model: noLoweredOpacityWhenPressedModel,
                    selection: $segmentedPickerSelection6,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.map { VSegmentedPickerTextRow(title: $0) }
                )
            })
            
            DemoRowView(type: .titled("No Smaller Indicator when Pressed"), content: {
                VSegmentedPicker(
                    model: noSmallerIndcatorWhenPressedModel,
                    selection: $segmentedPickerSelection7,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.map { VSegmentedPickerTextRow(title: $0) }
                )
            })
            
            DemoRowView(type: .titled("No Lowered Opacity when Disabled"), content: {
                VSegmentedPicker(
                    model: noLoweredOpacityWhenDisabledModel,
                    selection: $segmentedPickerSelection8,
                    state: segmentedPickerState,
                    data: segmentedPickerTitles.enumerated().map { VSegmentedPickerTextRow(title: $1, isEnabled: $0 != 1) }
                )
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ToggleSettingView(
                isOn: .init(
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
    
    init(dimension: CGFloat = 20, color: Color = ColorBook.accent) {
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
