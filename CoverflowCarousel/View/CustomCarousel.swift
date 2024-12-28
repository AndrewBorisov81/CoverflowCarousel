//
//  CustomCarousel.swift
//  CoverflowCarousel
//
//  Created by Andrew Borisov on 27.12.2024.
//

import SwiftUI

/// Custom View
struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            // Make it to start and end at the center
            .safeAreaPadding(.horizontal, max((size.width - config.cardWidth) / 2, 0))
            .scrollPosition(id: $selection)
            // Making it a carousel
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
        }
    }
    /// Item View
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress =  minX / (config.cardWidth + config.spacing)
            let minimumCarWidth = config.minimumCarWidth
            
            let diffWidth = config.cardWidth - minimumCarWidth
            let reducingWidth = progress * diffWidth
            /// Limiting diffWidth as the Max Value
            let cappedWidth = min(reducingWidth, diffWidth)
        
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth: min(-cappedWidth, diffWidth))
            
            let negativeProgress = max(-progress, 0)
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            content(item)
                .frame(width: size.width, height: size.height)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1)
                .mask{
                    let hasScale = config.hasScale
                    let scaledHeight = (1-scaleValue) * size.height
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? max(scaledHeight, 0): size.height)
                }
                .clipShape(.rect(cornerRadius: config.cornerRadius))
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: config.cardWidth)
    }
    
    /// Configuration for the CustomCarousel
    struct Config {
        var hasOpacity: Bool = false
        var opacityValue: CGFloat = 0.4
        var hasScale: Bool = false
        var scaleValue: CGFloat = 0.2
        
        var spacing: CGFloat = 10
        var cardWidth: CGFloat = 150
        var cornerRadius: CGFloat = 15
        var minimumCarWidth: CGFloat = 40
    }
}

#Preview {
    ContentView()
}
