//
//  PreviewCheckeredBackgroundView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

#if DEBUG

import SwiftUI

struct PreviewCheckeredBackgroundView: View {
    // MARK: Properties
    private let columns: Int = 10

    // MARK: Body
    var body: some View {
        GeometryReader { geometryProxy in
            let dimension: CGFloat = geometryProxy.size.width / CGFloat(columns)
            let rows: Int = Int((geometryProxy.size.height / dimension).rounded(.up))

            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            Rectangle()
                                .foregroundStyle((row + column).isMultiple(of: 2) ? Color.black : Color.white)
                                .frame(width: dimension, height: dimension)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .clipped()
    }
}

#Preview {
    PreviewCheckeredBackgroundView()
        .ignoresSafeArea()
}

#endif
