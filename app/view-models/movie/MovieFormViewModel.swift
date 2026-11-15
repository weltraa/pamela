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
  private static let minSelectableYear: UInt16 = 1888
  private static let currYear: UInt16 = UInt16(
    Calendar.current.component(.year, from: .now)
  )

  var name: String = ""
  var year: UInt16 = UInt16(Calendar.current.component(.year, from: .now))
  var firstDirector: String = ""
  var secondDirector: String = ""
  // When a movie has more than two directors, only two are kept
  // and the rest show up as "et al."
  var hasMoreDirectors: Bool = false

  var selectableYears: ClosedRange<UInt16> {
    Self.minSelectableYear...Self.currYear
  }

  // The filled-in director names, in order (empty fields skipped).
  var directors: [String] {
    [firstDirector, secondDirector]
      .map(StringUtils.trimmedTitle(for:))
      .filter { !$0.isEmpty }
  }

  // "et al." is only available once both directors are filled in.
  var canMarkMoreDirectors: Bool {
    directors.count == 2
  }

  // How the directors read, e.g. "David Fincher, Mel Gibson et al.".
  var directorsCredit: String {
    Movie.credit(
      for: directors,
      hasMoreDirectors: hasMoreDirectors && canMarkMoreDirectors
    )
  }
  
  var canSave: Bool {
    !StringUtils.trimmedTitle(for: name).isEmpty && !directors.isEmpty
  }
  
  func makeMovie() -> Movie {
    Movie(
      name: StringUtils.trimmedTitle(for: name),
      year: year,
      directors: directors,
      hasMoreDirectors: hasMoreDirectors && canMarkMoreDirectors
    )
  }
}
