//
//  View.swift
//  CoverflowCarousel
//
//  Created by Andrew Borisov on 27.12.2024.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: UUID = .init()
    var image: String
}

var images: [ImageModel] = (1...8).compactMap({ ImageModel(image: "Profile \($0)" ) })
