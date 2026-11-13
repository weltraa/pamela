//
//  TasksTabView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

struct TasksTabView: View {
  @State private var selectedDate = Date.now

  var body: some View {
    VStack {
      Text("My Tasks").font(.title).bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)

        WeekCalendarView(selectedDate: $selectedDate)

      Spacer()
    }
  }
}

#Preview {
  TasksTabView()
}
