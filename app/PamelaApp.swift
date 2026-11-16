//
//  PamelaApp.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

@main
struct PamelaApp: App {
  var body: some Scene {
    WindowGroup {
      RootView()
    }
    .modelContainer(for: [TaskItem.self, Book.self, Movie.self])
  }
}
