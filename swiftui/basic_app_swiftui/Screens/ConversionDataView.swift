//
//  ConversionDataView.swift
//  basic_app_swiftui
//
//  Mirrors the UIKit ConversionDataViewController storyboard scene:
//  a gray "Conversion data parameters" header label at the top and a
//  scrollable list of the attribution payload below it.
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI

struct ConversionDataView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Conversion data parameters")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .padding(.leading, 57)
                .padding(.top, 47)

            if let data = appState.conversionData, !data.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(data.keys.sorted(), id: \.self) { key in
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
                    }
                    .padding(.horizontal, 47)
                    .padding(.top, 20)
                }
            } else {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "hourglass")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Conversion data not available at the moment")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.systemBackground))
        .navigationTitle("Conversion Data")
        .navigationBarTitleDisplayMode(.inline)
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
}
