//
//  ApplesView.swift
//  basic_app_swiftui
//
//  Apples deep-link target. Renders FruitDetailView with the apples_cover
//  asset (same layout as the UIKit ApplesViewController storyboard scene).
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI

struct ApplesView: View {
    var body: some View {
        FruitDetailView(fruitName: "Apples", coverImage: "apples_cover")
    }
}
