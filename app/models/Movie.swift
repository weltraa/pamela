//
//  models/Movie.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import SwiftData

@Model
final class Movie {
  private static let maxDirectors = 2

  var name: String
  var year: UInt16
  var directors: [String]
  var hasMoreDirectors: Bool
  var directorsCredit: String {
    StringUtils.credit(for: directors, hasMore: hasMoreDirectors)
  }

  init(
    name: String,
    year: UInt16,
    directors: [String],
    hasMoreDirectors: Bool = false
  ) {
    self.name = name
    self.year = year
    self.directors = Array(directors.prefix(Self.maxDirectors))
    self.hasMoreDirectors = hasMoreDirectors
  }
}
