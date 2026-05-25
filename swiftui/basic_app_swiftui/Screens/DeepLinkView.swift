//
//  DeepLinkView.swift
//  basic_app_swiftui
//
//  Shows the resolved deep-link payload and a Share Invite button that
//  uses `AppsFlyerShareInviteHelper.generateInviteLink` and iOS 16+
//  `ShareLink` for system share sheet presentation.
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI
import AppsFlyerLib

/// Identifiable wrapper so `.sheet(item:)` can present a `ShareLink`-backed sheet.
private struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}

struct DeepLinkView: View {
    @Environment(AppState.self) private var appState

    @State private var shareItem: ShareItem?
    @State private var isGenerating = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            if let payload = appState.deepLinkData, !payload.isEmpty {
                Section("Payload") {
                    KeyValueList(payload: payload)
                }
            } else {
                Section {
                    Text("No deep link received yet.")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button {
                    generateInvite()
                } label: {
                    HStack {
                        Label("Share Invite Link", systemImage: "square.and.arrow.up")
                        if isGenerating {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                .disabled(isGenerating)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Deep Link Details")
        .sheet(item: $shareItem) { item in
            // iOS 16+ system share sheet via ShareLink, wrapped in a sheet
            // because we only have the URL after the async callback resolves.
            ShareSheet(url: item.url)
        }
    }

    private func generateInvite() {
        isGenerating = true
        errorMessage = nil

        AppsFlyerShareInviteHelper.generateInviteLink(linkGenerator: { generator in
            generator.setCampaign("share_invite")
            generator.setChannel("mobile_share")
            generator.addParameterValue("apples", forKey: "deep_link_value")
            generator.addParameterValue("THIS_USER_ID", forKey: "deep_link_sub2")
            return generator
        }, completionHandler: { url, error in
            DispatchQueue.main.async {
                isGenerating = false
                if let error {
                    NSLog("[AFSDK-SwiftUI] generateInviteLink failed: \(error)")
                    errorMessage = "Failed to generate invite link."
                    return
                }
                guard let url else {
                    errorMessage = "Invite link was empty."
                    return
                }
                shareItem = ShareItem(url: url)
                AppsFlyerShareInviteHelper.logInvite("mobile_share", eventParameters: [
                    "referrerId": "THIS_USER_ID",
                    "campaign": "share_invite",
                    "af_channel": "mobile_share"
                ])
            }
        })
    }
}

/// Renders a `[AnyHashable: Any]` dictionary as sorted key/value rows.
/// Kept here (the most key-value-heavy view) instead of a shared file.
struct KeyValueList: View {
    let payload: [AnyHashable: Any]

    var body: some View {
        let keys = payload.keys
            .compactMap { $0 as? String }
            .sorted()

        ForEach(keys, id: \.self) { key in
            HStack(alignment: .top) {
                Text(key)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(stringify(payload[key as AnyHashable]))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    private func stringify(_ value: Any?) -> String {
        switch value {
        case let s as String: return s
        case let b as Bool:   return b.description
        case let n as NSNumber: return n.stringValue
        case .some(let v):    return String(describing: v)
        case .none:           return "null"
        }
    }
}

/// Thin wrapper presenting a `ShareLink` inside a sheet so it can be
/// triggered programmatically after the SDK's async callback returns.
private struct ShareSheet: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)

                Text("Invite link ready")
                    .font(.headline)

                Text(url.absoluteString)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
                    .padding(.horizontal)

                ShareLink(item: url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("Share Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
