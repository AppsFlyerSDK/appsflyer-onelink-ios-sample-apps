//
//  PeachesView.swift
//  basic_app_swiftui
//
//  Peaches deep-link target. Renders FruitDetailView with the peaches_cover
//  asset (same layout as the UIKit PeachesViewController storyboard scene).
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI

struct PeachesView: View {
    var body: some View {
        FruitDetailView(fruitName: "Peaches", coverImage: "peaches_cover")
    }
}
