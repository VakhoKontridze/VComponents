//
//  DemoViewSettingsSectionBuilder.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/23/21.
//

import SwiftUI

// MARK: - Demo View Setting Section
struct DemoViewSettingsSection<Content>: View where Content: View {
    // MARK: Properties
    private let content: () -> Content

    // MARK: Initializers
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    // MARK: Body
    var body: some View {
        VStack(spacing: DemoViewSettingsSectionModel.rowSpacing, content: content)
    }
}

// MARK: - DemoViewSettingsSectionModel
private struct DemoViewSettingsSectionModel {
    static let sectionSpacing: CGFloat = 25
    static let rowSpacing: CGFloat = 15
    
    private init() {}
}

// MARK: - Demo View Settings Section Builder
@resultBuilder struct DemoViewSettingsSectionBuilder {
    private static let spacing: CGFloat = DemoViewSettingsSectionModel.sectionSpacing

    static func buildBlock<C0>(
        _ c0: DemoViewSettingsSection<C0>
    ) -> some View
        where C0: View
    {
        VStack(spacing: spacing, content: { c0 })
    }
    
    static func buildBlock<C0, C1>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>
    ) -> some View
        where C0: View, C1: View
    {
        VStack(spacing: spacing, content: { c0; c1 })
    }
    
    static func buildBlock<C0, C1, C2>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>
    ) -> some View
        where C0: View, C1: View, C2: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2 })
    }
    
    static func buildBlock<C0, C1, C2, C3>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3 })
    }
    
    static func buildBlock<C0, C1, C2, C3, C4>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4 })
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>,
        _ c5: DemoViewSettingsSection<C5>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5 })
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>,
        _ c5: DemoViewSettingsSection<C5>,
        _ c6: DemoViewSettingsSection<C6>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6 })
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>,
        _ c5: DemoViewSettingsSection<C5>,
        _ c6: DemoViewSettingsSection<C6>,
        _ c7: DemoViewSettingsSection<C7>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7 })
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>,
        _ c5: DemoViewSettingsSection<C5>,
        _ c6: DemoViewSettingsSection<C6>,
        _ c7: DemoViewSettingsSection<C7>,
        _ c8: DemoViewSettingsSection<C8>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7; c8 })
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(
        _ c0: DemoViewSettingsSection<C0>,
        _ c1: DemoViewSettingsSection<C1>,
        _ c2: DemoViewSettingsSection<C2>,
        _ c3: DemoViewSettingsSection<C3>,
        _ c4: DemoViewSettingsSection<C4>,
        _ c5: DemoViewSettingsSection<C5>,
        _ c6: DemoViewSettingsSection<C6>,
        _ c7: DemoViewSettingsSection<C7>,
        _ c8: DemoViewSettingsSection<C8>,
        _ c9: DemoViewSettingsSection<C9>
    ) -> some View
        where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View
    {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7; c8; c9 })
    }
}
