//
//  models/Book.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import SwiftData

@Model
final class Book {
  private static let maxAuthors = 2

  // One entry of the table of contents.
  struct Chapter: Codable, Identifiable {
    var id = UUID()
    var title: String
    var isRead = false
  }

  var title: String
  var authors: [String]
  var moreThan2Authors: Bool
  var year: UInt16
  var chapters: [Chapter] = []

  var authorsCredit: String {
    StringUtils.credit(for: authors, hasMore: moreThan2Authors)
  }

  // Share of chapters read, from 0 to 1; `nil` without a table of contents.
  var progress: Double? {
    guard !chapters.isEmpty
    else { return nil }

    return Double(chapters.count { $0.isRead }) / Double(chapters.count)
  }

  init(
    title: String,
    authors: [String],
    moreThan2Authors: Bool = false,
    year: UInt16,
    chapters: [Chapter] = []
  ) {
    self.title = title
    self.authors = Array(authors.prefix(Self.maxAuthors))
    self.moreThan2Authors = moreThan2Authors
    self.year = year
    self.chapters = chapters
  }
}
