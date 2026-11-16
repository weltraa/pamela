//
//  SobrietyFormView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct SobrietyFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Environment(\.palette) private var palette
  @Query private var addictions: [Addiction]

  @State private var viewModel: SobrietyFormViewModel
  @State private var isConfirmingDelete = false

  // The addiction being edited, or `nil` when adding a new one.
  private let addiction: Addiction?

  var body: some View {
    let isDuplicate = viewModel.isDuplicate(
      among: addictions, excluding: addiction
    )

    NavigationStack {
      Form {
        Section {
          TextField("e.g. Booze", text: $viewModel.name)
            .autocorrectionDisabled()
        } header: {
          Text("Addiction")
        } footer: {
          if isDuplicate {
            Text("You're already tracking this one.")
              .foregroundStyle(palette.destructive)
          }
          else if viewModel.canSave {
            Text("Shown as: \(viewModel.headline)…")
          }
        }

        Section("Counting Since") {
          DatePicker(
            "Start",
            selection: $viewModel.startDate,
            in: ...Date.now,
            displayedComponents: [.date, .hourAndMinute]
          )
        }

        if addiction != nil {
          Section {
            Button("Delete", role: .destructive) {
              isConfirmingDelete = true
            }
          }
        }
      }
      .navigationTitle(addiction == nil ? "New Addiction" : "Edit Addiction")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            dismiss()
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(addiction == nil ? "Add" : "Save", role: .confirm) {
            if let addiction {
              viewModel.apply(to: addiction)
            }
            else {
              modelContext.insert(viewModel.makeAddiction())
            }
            try? modelContext.save()
            dismiss()
          }
          .disabled(!viewModel.canSave || isDuplicate)
        }
      }
      .confirmationDialog(
        "Delete this addiction?",
        isPresented: $isConfirmingDelete,
        titleVisibility: .visible
      ) {
        Button("Delete", role: .destructive) {
          if let addiction {
            modelContext.delete(addiction)
            try? modelContext.save()
          }
          dismiss()
        }
      } message: {
        Text("The time you've counted so far will be lost.")
      }
    }
  }

  init(addiction: Addiction? = nil) {
    self.addiction = addiction
    _viewModel = State(
      initialValue:
        addiction.map {
          SobrietyFormViewModel(addiction: $0)
        } ?? SobrietyFormViewModel()
    )
  }
}

#Preview {
  SobrietyFormView()
    .modelContainer(for: Addiction.self, inMemory: true)
}
