//
//  components/View+FormToolbar.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

extension View {
  // The Cancel / Add-or-Save pair every entry form shows. `isEditing`
  // picks the confirm button's wording, and `canSave` enables it.
  func formToolbar(
    isEditing: Bool,
    canSave: Bool,
    onCancel: @escaping () -> Void,
    onConfirm: @escaping () -> Void
  ) -> some View {
    toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel", role: .cancel, action: onCancel)
      }

      ToolbarItem(placement: .confirmationAction) {
        Button(isEditing ? "Save" : "Add", role: .confirm, action: onConfirm)
          .disabled(!canSave)
      }
    }
  }
}
