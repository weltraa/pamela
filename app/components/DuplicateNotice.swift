//
//  components/DuplicateNotice.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// A form section's footer warning that the entry already exists.
struct DuplicateNotice: View {
  @Environment(\.palette) private var palette

  let message: String

  var body: some View {
    Text(message).foregroundStyle(palette.destructive)
  }
}
