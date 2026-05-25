//
//  MainView.swift
//  basic_app_swiftui
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI
import AppsFlyerLib

struct MainView: View {
    @Environment(AppState.self) private var appState

    private let oneLinkBlue = Color(red: 0.0, green: 0.478, blue: 1.0)

    var body: some View {
        @Bindable var binding = appState

        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 40) {
                Image("appsflyerlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                Image("onelinklogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .padding(.top, 10)
            .padding(.horizontal, 30)

            VStack(alignment: .leading, spacing: 15) {
                Text("OneLink Simulator")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(oneLinkBlue)
                Text("Find the magic of deep link parameters")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(oneLinkBlue)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 25)
            .padding(.horizontal, 30)

            Spacer()

            VStack(spacing: 20) {
                FruitCard(name: "Apples",  imageName: "apples_hp",  route: .apples)
                FruitCard(name: "Bananas", imageName: "bananas_hp", route: .bananas)
                FruitCard(name: "Peaches", imageName: "peaches_hp", route: .peaches)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .sheet(item: $binding.currentRoute) { route in
            NavigationStack {
                destination(for: route)
            }
            .presentationDragIndicator(.visible)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        }
        .onOpenURL { url in
            AppsFlyerLib.shared().handleOpen(url, options: nil)
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .apples:         ApplesView()
        case .bananas:        BananasView()
        case .peaches:        PeachesView()
        case .deepLink:       DeepLinkView()
        case .conversionData: ConversionDataView()
        }
    }
}

private struct FruitCard: View {
    let name: String
    let imageName: String
    let route: Route

    @Environment(AppState.self) private var appState

    var body: some View {
        Button {
            @Bindable var binding = appState
            binding.currentRoute = route
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()

                Text(name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.leading, 13)
                    .padding(.bottom, 7)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(name) fruit screen")
    }
}
