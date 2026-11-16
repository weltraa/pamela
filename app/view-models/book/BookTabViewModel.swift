//
//  BookTabViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation
import SwiftData

@Observable
final class BookTabViewModel {
  // Books whose chapters are shown in the list (accordion open).
  private var expandedBookIDs: Set<PersistentIdentifier> = []

  func isExpanded(_ book: Book) -> Bool {
    expandedBookIDs.contains(book.id)
  }

  func toggleChapters(of book: Book) {
    expandedBookIDs.formSymmetricDifference([book.id])
  }
}
