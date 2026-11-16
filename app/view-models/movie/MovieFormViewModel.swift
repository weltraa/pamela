//
//  MovieFormViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class MovieFormViewModel {
  // Roughly when the first films were shot.
  private static let minSelectableYear: UInt16 = 1888

  var name: String = ""
  var year: UInt16 = YearPicker.currentYear
  var firstDirector: String = ""
  var secondDirector: String = ""

  // When a movie has more than two directors, only two are kept
  // and the rest show up as "et al."
  var hasMoreDirectors: Bool = false

  var selectableYears: ClosedRange<UInt16> {
    Self.minSelectableYear...YearPicker.currentYear
  }

  // The filled-in director names, in order.
  // Empty fields are skipped, and the same name typed twice (even with
  // different case or accents) counts once.
  var directors: [String] {
    StringUtils.uniqueNames([firstDirector, secondDirector])
  }

  // "et al." is only available once both directors are filled in.
  var canMarkMoreDirectors: Bool {
    directors.count == 2
  }

  // How the directors read, e.g. "David Fincher, Mel Gibson et al.".
  var directorsCredit: String {
    StringUtils.credit(
      for: directors,
      hasMore: hasMoreDirectors && canMarkMoreDirectors
    )
  }

  var canSave: Bool {
    !StringUtils.trimmedTitle(for: name).isEmpty && !directors.isEmpty
  }

  init() {}

  // Starts from an existing movie, to edit it.
  init(movie: Movie) {
    name = movie.name
    year = movie.year
    firstDirector = movie.directors.first ?? ""
    secondDirector = movie.directors.dropFirst().first ?? ""
    hasMoreDirectors = movie.hasMoreDirectors
  }

  // Whether `movies` already has a movie with this title and year.
  // The movie being edited doesn't count as a duplicate of itself.
  // Same title with a different year is allowed (remakes).
  func isDuplicate(
    among movies: [Movie],
    excluding editedMovie: Movie? = nil
  ) -> Bool {
    let nameKey = StringUtils.matchKey(for: name)

    return movies.contains { movie in
      movie != editedMovie
        && movie.year == year
        && StringUtils.matchKey(for: movie.name) == nameKey
    }
  }

  func makeMovie() -> Movie {
    Movie(
      name: StringUtils.trimmedTitle(for: name),
      year: year,
      directors: directors,
      hasMoreDirectors: hasMoreDirectors && canMarkMoreDirectors
    )
  }

  // Copies the form's values onto an existing movie.
  func apply(to movie: Movie) {
    movie.name = StringUtils.trimmedTitle(for: name)
    movie.year = year
    movie.directors = directors
    movie.hasMoreDirectors = hasMoreDirectors && canMarkMoreDirectors
  }
}
