//
//  components/YearPicker.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// Wheel picker for a year, trimmed to a compact height.
struct YearPicker: View {
  // The year the app is being used in, the newest any entry can be.
  static let currentYear = UInt16(Calendar.current.component(.year, from: .now))

  @Binding var selection: UInt16
  let years: ClosedRange<UInt16>

  var body: some View {
    Picker("Year", selection: $selection) {
      ForEach(years, id: \.self) { year in
        Text(String(year)).tag(year)
      }
    }
    .pickerStyle(.wheel)
    .labelsHidden()
    .frame(height: 170)
    .frame(height: 110, alignment: .top)
    .clipped()
  }
}
