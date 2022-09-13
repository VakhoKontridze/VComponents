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
        VStack(spacing: DemoViewSettingsSectionUIModel.rowSpacing, content: content)
    }
}

// MARK: - Demo View Settings Section UI Model
private struct DemoViewSettingsSectionUIModel {
    static var sectionSpacing: CGFloat { 25 }
    static var rowSpacing: CGFloat { 15 }
    
    private init() {}
}

// MARK: - Demo View Settings Section Builder
@resultBuilder struct DemoViewSettingsSectionBuilder {
    private static var spacing: CGFloat { DemoViewSettingsSectionUIModel.sectionSpacing }

    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>,
        _ c5: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>,
        _ c5: DemoViewSettingsSection<some View>,
        _ c6: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6 })
    }

    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>,
        _ c5: DemoViewSettingsSection<some View>,
        _ c6: DemoViewSettingsSection<some View>,
        _ c7: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>,
        _ c5: DemoViewSettingsSection<some View>,
        _ c6: DemoViewSettingsSection<some View>,
        _ c7: DemoViewSettingsSection<some View>,
        _ c8: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7; c8 })
    }
    
    static func buildBlock(
        _ c0: DemoViewSettingsSection<some View>,
        _ c1: DemoViewSettingsSection<some View>,
        _ c2: DemoViewSettingsSection<some View>,
        _ c3: DemoViewSettingsSection<some View>,
        _ c4: DemoViewSettingsSection<some View>,
        _ c5: DemoViewSettingsSection<some View>,
        _ c6: DemoViewSettingsSection<some View>,
        _ c7: DemoViewSettingsSection<some View>,
        _ c8: DemoViewSettingsSection<some View>,
        _ c9: DemoViewSettingsSection<some View>
    ) -> some View {
        VStack(spacing: spacing, content: { c0; c1; c2; c3; c4; c5; c6; c7; c8; c9 })
    }
}
