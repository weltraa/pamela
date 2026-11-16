//
//  models/Addiction.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import SwiftData

@Model
final class Addiction {
  // Units of the time sober, largest first.
  static let units: [Calendar.Component] = [
    .year, .month, .day, .hour, .minute, .second
  ]

  var name: String
  var startDate: Date

  var headline: String {
    Self.headline(for: name)
  }

  init(name: String, startDate: Date) {
    self.name = name
    self.startDate = startDate
  }

  // How the card introduces the time, e.g. "I've been booze free for".
  static func headline(for name: String) -> String {
    "I've been \(name.localizedLowercase) free for"
  }

  // Time sober at `date`, as its non-zero units, largest first:
  // 1 minute, 2 seconds. Right at the start it's 0 seconds.
  func elapsed(at date: Date) -> [(unit: Calendar.Component, value: Int)] {
    let parts = Calendar.current.dateComponents(
      Set(Self.units), from: startDate, to: date
    )
    let shown = Self.units
      .map { (unit: $0, value: parts.value(for: $0) ?? 0) }
      .filter { $0.value > 0 }

    return shown.isEmpty ? [(unit: .second, value: 0)] : shown
  }
}
