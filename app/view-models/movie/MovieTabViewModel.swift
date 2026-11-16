//
//  MovieTabViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class MovieTabViewModel {
  // `nil` means "any year" / "any director".
  var selectedYear: UInt16?
  var selectedDirector: String?

  var isFiltering: Bool {
    selectedYear != nil || selectedDirector != nil
  }

  func clearFilters() {
    selectedYear = nil
    selectedDirector = nil
  }

  // Years that have at least one movie, newest first.
  func years(in movies: [Movie]) -> [UInt16] {
    Set(movies.map(\.year)).sorted(by: >)
  }

  // Every recorded director once, alphabetically. Names that only differ
  // in case or accents ("Alfonso Cuarón" / "alfonso cuaron") count as one.
  func directors(in movies: [Movie]) -> [String] {
    StringUtils.uniqueNames(movies.flatMap(\.directors))
      .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
  }

  func filtered(_ movies: [Movie]) -> [Movie] {
    movies.filter { movie in
      let matchesYear = selectedYear.map { movie.year == $0 } ?? true
      let matchesDirector = selectedDirector.map { director in
        movie.directors.contains {
          StringUtils.matchKey(for: $0) == StringUtils.matchKey(for: director)
        }
      } ?? true

      return matchesYear && matchesDirector
    }
  }

  // Forgets a filter whose year or director no longer has any movie,
  // e.g. after deleting or editing the last movie that matched it.
  func dropStaleFilters(for movies: [Movie]) {
    if let selectedYear, !years(in: movies).contains(selectedYear) {
      self.selectedYear = nil
    }

    if let selectedDirector, !directors(in: movies).contains(selectedDirector) {
      self.selectedDirector = nil
    }
  }
}
