//
//  VSegmentedPicker.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker
public struct VSegmentedPicker<RowContent>: View where RowContent: View {
    // MARK: Properties
    private let model: VSegmentedPickerModel
    
    @Binding private var selection: Int
    
    private let state: VSegmentedPickerState
    @State private var pressedIndex: Int? = nil
    private func rowState(for index: Int) -> VSegmentedPickerRowState { .init(
        isEnabled: !state.isDisabled && data[index].isEnabled,
        isPressed: pressedIndex == index
    ) }
    
    let data: [VSegmentedPickerRow<RowContent>]
    
    @State private var rowWidth: CGFloat = .zero
    
    // MARK: Initializers
    public init(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        data: [VSegmentedPickerRow<RowContent>]
    ) {
        self.model = model
        self._selection = selection
        self.state = state
        self.data = data
    }
    
    public init<S>(
        model: VSegmentedPickerModel = .init(),
        selection: Binding<Int>,
        state: VSegmentedPickerState = .enabled,
        data: [VSegmentedPickerTextRow<S>]
    )
        where
            RowContent == VGenericTitleContentView<S>,
            S: StringProtocol
    {
        self.init(
            model: model,
            selection: selection,
            state: state,
            data: data.map { row in
                .init(
                    content: VGenericTitleContentView(title: row.title, color: model.colors.textColor(for: state), font: model.font),
                    isEnabled: row.isEnabled
                )
            }
        )
    }
}

// MARK:- Body
public extension VSegmentedPicker {
    var body: some View {
        ZStack(alignment: .leading, content: {
            background
            indicator
            rows
            dividers
        })
            .frame(height: model.layout.height)
            .cornerRadius(model.layout.cornerRadius)
    }
    
    private var background: some View {
        model.colors.backgroundColor(for: state)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: model.layout.indicatorCornerRadius)
            .padding(model.layout.indicatorPadding)
            .frame(width: rowWidth)
            .scaleEffect(indicatorScale)
            .offset(x: rowWidth * .init(selection))
            .animation(model.behavior.selectionAnimation)
            
            .foregroundColor(model.colors.indicatorColor(for: state))
            .shadow(
                color: model.colors.indicatorShadowColor(for: state),
                radius: model.layout.indicatorShadowRadius,
                y: model.layout.indicatorShadowOffsetY
            )
    }
    
    private var rows: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                VBaseButton(
                    isDisabled: state.isDisabled || !data[i].isEnabled,
                    action: { selection = i },
                    onPress: { pressedIndex = $0 ? i : nil },
                    content: {
                        data[i].content
                            .padding(model.layout.actualRowContentPadding)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            .font(model.font)
                            .opacity(foregroundOpacity(for: i))
                            
                            .readSize(onChange: { rowWidth = $0.width })
                    }
                )
            })
        })
    }
    
    private var dividers: some View {
        HStack(spacing: 0, content: {
            ForEach(0..<data.count, content: { i in
                Spacer()
                
                if i <= data.count-2 {
                    Divider()
                        .opacity(dividerOpacity(for: i))
                        .frame(height: model.layout.dividerHeight)
                }
            })
        })
    }
}

// MARK:- State Indication
private extension VSegmentedPicker {
    var indicatorScale: CGFloat {
        switch selection {
        case pressedIndex: return model.layout.indicatorPressedScale
        case _: return 1
        }
    }
    
    func foregroundOpacity(for index: Int) -> Double {
        model.colors.foregroundOpacity(state: rowState(for: index))
    }
    
    func dividerOpacity(for index: Int) -> Double {
        let isBeforeIndicator: Bool = index < selection
        
        switch isBeforeIndicator {
        case false: return index - selection < 1 ? 0 : 1
        case true: return selection - index <= 1 ? 0 : 1
        }
    }
}

// MARK:- Preview
struct VSegmentedPicker_Previews: PreviewProvider {
    @State private static var selection: Int = 0
    
    static var previews: some View {
        VSegmentedPicker(selection: $selection, data: [
            .init(title: "One", isEnabled: true),
            .init(title: "Two", isEnabled: true),
            .init(title: "Three", isEnabled: false),
            .init(title: "Four", isEnabled: true),
        ])
            .padding(20)
    }
}
