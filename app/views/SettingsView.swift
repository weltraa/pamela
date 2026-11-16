//
//  SettingsView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @AppStorage(AppTheme.storageKey) private var theme = AppTheme.defaultTheme

  @State private var viewModel = SettingsViewModel()

  var body: some View {
    Form {
      Section("Appearance") {
        Picker("Theme", selection: $theme) {
          ForEach(AppTheme.allCases) { theme in
            Text(theme.title).tag(theme)
          }
        }
      }
    }
    // Pinned to the bottom of the screen, below the menu.
    .safeAreaInset(edge: .bottom) {
      VStack(spacing: 4) {
        Text(viewModel.appName).font(.headline)
        Text("Version \(viewModel.version)")
        Text(viewModel.copyright)
      }
      .font(.footnote)
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity)
      .padding(.bottom)
    }
    .themedBackdrop()
    .themedBars(title: "Settings") {
      // Themes with their own bars have no system back button.
      Button {
        dismiss()
      } label: {
        BarButtonLabel(title: "Back", systemImage: "chevron.left")
      }
    }
    .navigationTitle("Settings")
  }
}

#Preview {
  NavigationStack {
    SettingsView()
  }
  .appTheme()
}
