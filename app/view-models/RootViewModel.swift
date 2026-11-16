//
//  RootViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Observation
import Foundation

@Observable
final class RootViewModel {
  public enum RootTab: CaseIterable, Identifiable {
    case tasks
    case books
    case movies
    case sobriety

    var id: Self { self }

    var title: String {
      switch self {
        case .tasks:    "Tasks"
        case .books:    "Books"
        case .movies:   "Movies"
        case .sobriety: "Sobriety"
      }
    }

    var icon: String {
      switch self {
        case .tasks:    "list.bullet"
        case .books:    "books.vertical"
        case .movies:   "movieclapper"
        case .sobriety: "apple.meditate"
      }
    }
  }

  var selectedTab: RootTab = .tasks

  func isSelected(_ tab: RootTab) -> Bool {
    selectedTab == tab
  }

  func canAdd() -> Bool {
    switch selectedTab {
      case .tasks, .books, .movies: true
      default: false
    }
  }
}
