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
  var createdAt: Date
  
  init(
    name: String,
    year: UInt16,
    directors: [String],
    hasMoreDirectors: Bool = false,
    createdAt: Date = .now
  ){
    self.name = name
    self.year = year
    self.directors = Array(directors.prefix(Self.maxDirectors))
    self.hasMoreDirectors = hasMoreDirectors
    self.createdAt = createdAt
  }
  
  static func credit(
    for directors: [String], hasMoreDirectors: Bool
  ) -> String {
    let names = directors.joined(separator: ", ")
    return hasMoreDirectors ? "\(names) et al." : names
  }
  
  var directorsCredit: String {
    Self.credit(for: directors, hasMoreDirectors: hasMoreDirectors)
  }
}
