//
//  FruitDetailView.swift
//  basic_app_swiftui
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI
import AppsFlyerLib

struct FruitDetailView: View {
    let fruitName: String
    let coverImage: String

    @Environment(AppState.self) private var appState
    @State private var shareURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image(coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()

                if let amount = fruitAmount {
                    Text(amount)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: Color(.systemGray2), radius: 2, x: 0, y: 1)
                }
            }
            .frame(height: 220)
            .frame(maxWidth: .infinity)

            Text("Deep Link parameters")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .padding(.top, 30)
                .padding(.leading, 30)

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    if let data = appState.deepLinkData, !data.isEmpty {
                        ForEach(sortedKeys(of: data), id: \.self) { key in
                            HStack(alignment: .top) {
                                Text(key)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text(stringify(data[key]))
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    } else {
                        Text("No Deep Linking happened")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 8)
            }

            VStack(spacing: 12) {
                Button(action: generateAndShare) {
                    Image("copy link button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 133, height: 43)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Share invite link")

                NavigationLink {
                    ConversionDataView()
                } label: {
                    Text("Show conversion data")
                        .font(.system(size: 19))
                        .foregroundStyle(Color(red: 0.0, green: 0.478, blue: 1.0))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 11)
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.container, edges: .top)
        .sheet(isPresented: Binding(
            get: { shareURL != nil },
            set: { if !$0 { shareURL = nil } }
        )) {
            if let url = shareURL {
                ActivityView(items: [url])
                    .presentationDetents([.medium])
            }
        }
    }

    private var fruitAmount: String? {
        guard let data = appState.deepLinkData else { return nil }
        if let raw = data["deep_link_sub1"] {
            return String(describing: raw)
        }
        return nil
    }

    // MARK: - Helpers

    private func sortedKeys(of dict: [AnyHashable: Any]) -> [String] {
        dict.keys.compactMap { $0 as? String }.sorted()
    }

    private func stringify(_ value: Any?) -> String {
        switch value {
        case let s as String:    return s
        case let b as Bool:      return b.description
        case let n as NSNumber:  return n.stringValue
        case .some(let v):       return String(describing: v)
        case .none:              return "null"
        }
    }

    private func generateAndShare() {
        AppsFlyerShareInviteHelper.generateInviteLink(linkGenerator: { generator in
            generator.setCampaign("share_invite")
            generator.setChannel("mobile_share")
            generator.addParameterValue(fruitName.lowercased(), forKey: "deep_link_value")
            generator.addParameterValue("THIS_USER_ID", forKey: "deep_link_sub2")
            return generator
        }) { url, error in
            DispatchQueue.main.async {
                if let error {
                    NSLog("[AFSDK-SwiftUI] generateInviteLink failed: \(error)")
                    return
                }
                guard let url else { return }
                AppsFlyerShareInviteHelper.logInvite("mobile_share", eventParameters: [
                    "referrerId": "THIS_USER_ID",
                    "campaign": "share_invite",
                    "af_channel": "mobile_share"
                ])
                shareURL = url
            }
        }
    }
}

private struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
