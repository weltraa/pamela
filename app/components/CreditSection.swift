//
//  components/CreditSection.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// Form section for up to two people plus "et al.", e.g. a movie's
// directors or a book's authors.
struct CreditSection: View {
  let title: String
  let role: String
  @Binding var first: String
  @Binding var second: String
  @Binding var hasMore: Bool
  let canMarkMore: Bool
  let credit: String

  var body: some View {
    Section {
      Group {
        TextField(role, text: $first)
        TextField("Second \(role.lowercased()) (optional)", text: $second)
      }
      .textInputAutocapitalization(.words)
      .autocorrectionDisabled()

      if canMarkMore {
        Toggle("More than two \(title.lowercased())", isOn: $hasMore)
      }
    } header: {
      Text(title)
    } footer: {
      if !credit.isEmpty {
        Text("Shown as: \(credit)")
      }
    }
  }
}
