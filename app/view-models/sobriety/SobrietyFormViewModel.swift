//
//  SobrietyFormViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class SobrietyFormViewModel {
  var name: String = ""
  var startDate: Date = .now

  var headline: String {
    Addiction.headline(for: StringUtils.trimmedTitle(for: name))
  }

  var canSave: Bool {
    !StringUtils.trimmedTitle(for: name).isEmpty
  }

  init() {}

  // Starts from an existing addiction, to edit it.
  init(addiction: Addiction) {
    name = addiction.name
    startDate = addiction.startDate
  }

  // Whether `addictions` already has one with this name.
  // The one being edited doesn't count as a duplicate of itself.
  func isDuplicate(
    among addictions: [Addiction],
    excluding editedAddiction: Addiction? = nil
  ) -> Bool {
    let nameKey = StringUtils.matchKey(for: name)

    return addictions.contains { addiction in
      addiction != editedAddiction
        && StringUtils.matchKey(for: addiction.name) == nameKey
    }
  }

  func makeAddiction() -> Addiction {
    Addiction(name: StringUtils.trimmedTitle(for: name), startDate: startDate)
  }

  // Copies the form's values onto an existing addiction.
  func apply(to addiction: Addiction) {
    addiction.name = StringUtils.trimmedTitle(for: name)
    addiction.startDate = startDate
  }
}
