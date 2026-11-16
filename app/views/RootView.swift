//
//  RootView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct RootView: View {
  @Environment(\.palette) private var palette

  @State private var viewModel = RootViewModel()
  @State private var showAddSheet = false

  private var settingsButton: some View {
    NavigationLink {
      SettingsView()
    } label: {
      BarButtonLabel(title: "Settings", systemImage: "gearshape")
    }
  }

  private var addButton: some View {
    Button {
      showAddSheet = true
    } label: {
      BarButtonLabel(title: "Add", systemImage: "plus.circle")
    }
  }

  var body: some View {
    NavigationStack {
      TabView(selection: $viewModel.selectedTab) {
        ForEach(RootViewModel.RootTab.allCases) { tab in
          Tab(value: tab) {
            Group {
              switch tab {
                case .tasks:    TaskItemTabView()
                case .books:    BookTabView()
                case .movies:   MovieTabView()
                case .sobriety: SobrietyTabView()
              }
            }
            // The bars go inside each tab: a tab's content doesn't inherit
            // insets set on the tab view itself.
            .themedBackdrop()
            .themedBars(title: "Pamela") {
              settingsButton
            } trailing: {
              addButton
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
              if let bars = palette.bars {
                GradientTabBar(selection: $viewModel.selectedTab, bars: bars)
              }
            }
            // With the app's own tab bar, the system's stays hidden.
            .toolbarVisibility(
              palette.bars == nil ? .automatic : .hidden, for: .tabBar
            )
          } label: {
            Label(tab.title, systemImage: tab.icon)
              .environment(
                \.symbolVariants,
                viewModel.isSelected(tab) ? .fill : .none
              )
          }
        }
      }
      .toolbar {
        // Themes with their own bars put these buttons on them instead.
        if palette.bars == nil {
          ToolbarItem(placement: .topBarLeading) { settingsButton }
          ToolbarItem(placement: .topBarTrailing) { addButton }
        }
      }
      .sheet(isPresented: $showAddSheet) {
        switch viewModel.selectedTab {
          case .tasks: TaskItemFormView()
          case .books: BookFormView()
          case .movies: MovieFormView()
          case .sobriety: SobrietyFormView()
        }
      }
    }
  }
}

#Preview {
  RootView()
    .appTheme()
    .modelContainer(
      for: [TaskItem.self, Book.self, Movie.self, Addiction.self],
      inMemory: true
    )
}
