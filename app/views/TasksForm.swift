//
//  TasksForm.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct TasksForm: View {
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
            dismiss()
          }
          .disabled(!viewModel.canSave)
        }
      }
    }
  }
}

// MARK: - Subviews

private struct WeekdaySelector: View {
  let viewModel: TaskItemFormViewModel

  var body: some View {
    HStack {
      ForEach(0..<7, id: \.self) { dayIndex in
        let isSelected = viewModel.isSelected(weekday: dayIndex)

        Button {
          viewModel.toggle(weekday: dayIndex)
        } label: {
          Text(viewModel.weekdayName(forWeekdayNum: dayIndex))
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .frame(width: 36, height: 36)
            .background {
              Circle().fill(
                isSelected ? Color.accentColor : Color(.tertiarySystemFill)
              )
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
      }
    }
  }
}

#Preview {
  TasksForm()
}
