//
//  TaskItemFrequencyForm.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

/// Small sheet to change how often an existing task repeats.
/// Changes apply as soon as they are made, so there is no Save button.
struct TaskItemFrequencyForm: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var viewModel: TaskItemFormViewModel

  let task: TaskItem

  init(task: TaskItem) {
    self.task = task
    _viewModel = State(
      initialValue: TaskItemFormViewModel(frequency: task.frequency)
    )
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          Picker("Repeat", selection: $viewModel.frequency) {
            ForEach(TaskItemFormViewModel.Frequency.allCases) { option in
              Text(option.str).tag(option)
            }
          }
          .pickerStyle(.segmented)

          if viewModel.frequency == .weekly {
            WeekdaySelector(viewModel: viewModel)
          }
        }
      }
      .navigationTitle(task.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done", role: .confirm) {
            dismiss()
          }
        }
      }
    }
    .presentationDetents([.medium])
    .onChange(of: viewModel.taskFrequency) { _, newFrequency in
      if let newFrequency {
        task.frequency = newFrequency
        try? modelContext.save()
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: TaskItem.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  let task = TaskItem(title: "Read 20 pages", frequency: .daily, isCompleted: false)
  let _ = container.mainContext.insert(task)

  TaskItemFrequencyForm(task: task)
    .modelContainer(container)
}
