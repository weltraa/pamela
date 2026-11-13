//
//  RootView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct RootView: View {
  @State private var viewModel = RootViewModel()
  @State private var showAddSheet = false

  var body: some View {
    NavigationStack {
      TabView(selection: $viewModel.selectedTab) {
        ForEach(RootViewModel.RootTab.allCases) { tab in
          Tab(value: tab) {
            switch tab {
              case .tasks:    TasksTabView()
              case .books:    BooksTabView()
              case .movies:   MoviesTabView()
              case .sobriety: SobrietyTabView()
            }
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
        ToolbarItem(placement: .topBarLeading){
          NavigationLink {
            SettingsView()
          } label: {
            Label("Settings", systemImage: "gearshape")
          }
        }

        ToolbarItem(placement: .topBarTrailing){
          Button("Add", systemImage: "plus.circle"){
            showAddSheet = true
          }
          .disabled(!viewModel.canAdd())
        }
      }
      .sheet(isPresented: $showAddSheet) {
        switch viewModel.selectedTab {
          case .tasks: TasksForm()
          default: EmptyView()
        }
      }
    }
  }
}

#Preview {
  RootView()
}
