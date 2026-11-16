//
//  BookFormViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class BookFormViewModel {
  // Around when Gutenberg's press started printing books.
  private static let minSelectableYear: UInt16 = 1450
  private static let currYear: UInt16 = UInt16(
    Calendar.current.component(.year, from: .now)
  )

  var title: String = ""
  var year: UInt16 = BookFormViewModel.currYear
  var firstAuthor: String = ""
  var secondAuthor: String = ""
  var hasMoreAuthors: Bool = false
  var chapters: [Book.Chapter] = []

  // Text in the "Add chapter" field, not added to `chapters` yet.
  var newChapterTitle: String = ""

  var selectableYears: ClosedRange<UInt16> {
    Self.minSelectableYear...Self.currYear
  }

  var authors: [String] {
    StringUtils.uniqueNames([firstAuthor, secondAuthor])
  }

  // "et al." is only available once both authors are filled in.
  var canMarkMoreAuthors: Bool {
    authors.count == 2
  }

  var authorsCredit: String {
    StringUtils.credit(for: authors, hasMore: keepsMoreAuthors)
  }

  var canSave: Bool {
    !StringUtils.trimmedTitle(for: title).isEmpty && !authors.isEmpty
  }

  private var keepsMoreAuthors: Bool {
    hasMoreAuthors && canMarkMoreAuthors
  }

  // Chapters as they get saved: titles trimmed, untitled ones dropped, and
  // a title left in the "Add chapter" field included, so it isn't lost.
  private var savedChapters: [Book.Chapter] {
    (chapters + [Book.Chapter(title: newChapterTitle)]).compactMap {
      var chapter = $0
      chapter.title = StringUtils.trimmedTitle(for: chapter.title)

      return chapter.title.isEmpty ? nil : chapter
    }
  }

  init() {}

  // Starts from an existing book, to edit it.
  init(book: Book) {
    title = book.title
    year = book.year
    firstAuthor = book.authors.first ?? ""
    secondAuthor = book.authors.dropFirst().first ?? ""
    hasMoreAuthors = book.moreThan2Authors
    chapters = book.chapters
  }

  func addChapter() {
    guard !StringUtils.trimmedTitle(for: newChapterTitle).isEmpty
    else { return }

    chapters.append(Book.Chapter(title: newChapterTitle))
    newChapterTitle = ""
  }

  // Whether `books` already has a book with this title and year.
  // The book being edited doesn't count as a duplicate of itself.
  func isDuplicate(
    among books: [Book],
    excluding editedBook: Book? = nil
  ) -> Bool {
    let titleKey = StringUtils.matchKey(for: title)

    return books.contains { book in
      book != editedBook
        && book.year == year
        && StringUtils.matchKey(for: book.title) == titleKey
    }
  }

  func makeBook() -> Book {
    Book(
      title: StringUtils.trimmedTitle(for: title),
      authors: authors,
      moreThan2Authors: keepsMoreAuthors,
      year: year,
      chapters: savedChapters
    )
  }

  // Copies the form's values onto an existing book.
  func apply(to book: Book) {
    book.title = StringUtils.trimmedTitle(for: title)
    book.authors = authors
    book.moreThan2Authors = keepsMoreAuthors
    book.year = year
    book.chapters = savedChapters
  }
}
