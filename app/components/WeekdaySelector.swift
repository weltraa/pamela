//
//  components/WeekdaySelector.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct WeekdaySelector: View {
  let viewModel: TaskItemFormViewModel

  var body: some View {
    HStack(spacing: 0) {
      ForEach(viewModel.orderedWeekdays, id: \.self) { dayIndex in
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
        .accessibilityLabel(viewModel.weekdayFullName(forWeekdayNum: dayIndex))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
      }
    }
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
  }
}
