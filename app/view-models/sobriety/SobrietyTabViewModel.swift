//
//  SobrietyTabViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation
import SwiftData

@Observable
final class SobrietyTabViewModel {
  // The card in front of the deck; `nil` means the last one.
  var frontID: PersistentIdentifier?

  // Cards in stacking order. The front card goes last, so it's drawn on
  // top of the others and shown in full.
  func deck(of addictions: [Addiction]) -> [Addiction] {
    guard
      let front = addictions.first(where: { $0.id == frontID })
        ?? addictions.last
    else { return [] }

    return addictions.filter { $0 != front } + [front]
  }
}
