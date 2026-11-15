//
//  TaskItemForm.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct TaskItemForm: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  @State private var viewModel = TaskItemFormViewModel()

  var body: some View {
    NavigationStack {
      Form {
        Section ("Title") {
          TextField("Type here...", text: $viewModel.title)
        }

        Section("Frequency") {
          Picker("Repeat", selection: $viewModel.frequency){
            ForEach(TaskItemFormViewModel.Frequency.allCases){ option in
              Text(option.str).tag(option)
            }
          }

          if viewModel.frequency == .weekly {
            WeekdaySelector(viewModel: viewModel)
          }
        }
      }
      .navigationTitle("New Task")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            dismiss()
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Button("Add", role: .confirm) {
            modelContext.insert(viewModel.makeTask())
            try? modelContext.save()
            dismiss()
          }
          .disabled(!viewModel.canSave)
        }
      }
    }
  }
}

#Preview {
  TaskItemForm()
    .modelContainer(for: TaskItem.self, inMemory: true)
}
