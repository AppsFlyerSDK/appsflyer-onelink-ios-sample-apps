//
//  BananasView.swift
//  basic_app_swiftui
//
//  Bananas deep-link target. Renders FruitDetailView with the bananas_cover
//  asset (same layout as the UIKit BananasViewController storyboard scene).
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI

struct BananasView: View {
    var body: some View {
        FruitDetailView(fruitName: "Bananas", coverImage: "bananas_cover")
    }
}
