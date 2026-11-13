//
//  components/NoEntriesNotice.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct NoEntriesNotice: View {
  let icon: String
  let title: String
  let description: String

  var body: some View {
    ContentUnavailableView {
      Label(title, systemImage: icon)
    } description: { Text(description) }
  }
}

#Preview {
  NoEntriesNotice(
    icon: "checklist",
    title: "No tasks yet",
    description: "Tap + to add your first task."
  )
}
