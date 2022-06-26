//
//  View.SafeAreaMarginInsets.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import SwiftUI

// MARK: - Safe Area Margin Insets
extension View {
    func safeAreaMarginInsets(edges: Edge.Set) -> some View {
        self
            .if(edges.contains(.leading), transform: {
                $0.safeAreaMarginInset(edge: .leading, width: UIDevice.safeAreaInsetLeft)
            })
            
            .if(edges.contains(.trailing), transform: {
                $0.safeAreaMarginInset(edge: .trailing, width: UIDevice.safeAreaInsetRight)
            })
            
            .if(edges.contains(.top), transform: {
                $0.safeAreaMarginInset(edge: .top, height: UIDevice.safeAreaInsetTop)
            })
            
            .if(edges.contains(.bottom), transform: {
                $0.safeAreaMarginInset(edge: .bottom, height: UIDevice.safeAreaInsetBottom)
            })
    }
    
    @ViewBuilder func safeAreaMarginInset(edge: HorizontalEdge, width: CGFloat) -> some View {
        if width == 0 {
            self
        } else {
            self
                .safeAreaInset(edge: edge, content: {
                    Spacer()
                        .frame(width: width)
                })
        }
    }
    
    @ViewBuilder func safeAreaMarginInset(edge: VerticalEdge, height: CGFloat) -> some View {
        if height == 0 {
            self
        } else {
            self
                .safeAreaInset(edge: edge, content: {
                    Spacer()
                        .frame(height: height)
                })
        }
    }
}
