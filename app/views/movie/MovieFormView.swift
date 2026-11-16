//
//  MovieFormView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct MovieFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Query private var movies: [Movie]

  @State private var viewModel: MovieFormViewModel

  // The movie being edited, or `nil` when adding a new one.
  private let movie: Movie?

  var body: some View {
    let isDuplicate = viewModel.isDuplicate(among: movies, excluding: movie)

    NavigationStack {
      Form {
        Section {
          TextField("Type here...", text: $viewModel.name)
            .autocorrectionDisabled()
        } header: {
          Text("Title")
        } footer: {
          if isDuplicate {
            DuplicateNotice(message: "This movie is already in your list.")
          }
        }

        Section("Year") {
          YearPicker(
            selection: $viewModel.year,
            years: viewModel.selectableYears
          )
        }

        CreditSection(
          title: "Directors",
          role: "Director",
          first: $viewModel.firstDirector,
          second: $viewModel.secondDirector,
          hasMore: $viewModel.hasMoreDirectors,
          canMarkMore: viewModel.canMarkMoreDirectors,
          credit: viewModel.directorsCredit
        )
      }
      .navigationTitle(movie == nil ? "New Movie Entry" : "Edit Movie")
      .navigationBarTitleDisplayMode(.inline)
      .formToolbar(
        isEditing: movie != nil,
        canSave: viewModel.canSave && !isDuplicate
      ) {
        dismiss()
      } onConfirm: {
        if let movie {
          viewModel.apply(to: movie)
        }
        else {
          modelContext.insert(viewModel.makeMovie())
        }
        try? modelContext.save()
        dismiss()
      }
    }
  }

  init(movie: Movie? = nil) {
    self.movie = movie
    _viewModel = State(
      initialValue:
        movie.map {
          MovieFormViewModel(movie: $0)
        } ?? MovieFormViewModel()
    )
  }
}

#Preview {
  MovieFormView()
    .appTheme()
    .modelContainer(for: Movie.self, inMemory: true)
}
