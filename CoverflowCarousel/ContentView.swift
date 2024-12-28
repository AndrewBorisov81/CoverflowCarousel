//
//  ContentView.swift
//  CoverflowCarousel
//  https://www.youtube.com/watch?v=xU5z4IJpVg4
//  Created by Andrew Borisov on 27.12.2024.
//
//

import SwiftUI

struct ContentView: View {
    /// Since my model ID type is UUID
    @State private var activeID: UUID?
    var body: some View {
        VStack {
            CustomCarousel(config: .init(hasOpacity: true, hasScale: true, cardWidth: 200, minimumCarWidth: 30), selection: $activeID, data: images) {
                item in Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 300)
        }
        .navigationTitle("Cover Carousel")
    }
}

#Preview {
    ContentView()
}

