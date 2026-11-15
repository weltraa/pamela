//
//  MovieForm.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI
import SwiftData

struct MovieForm: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  @State private var viewModel: MovieFormViewModel

  // The movie being edited, or `nil` when adding a new one.
  private let movie: Movie?

  init(movie: Movie? = nil) {
    self.movie = movie
    _viewModel = State(
      initialValue: movie.map { MovieFormViewModel(movie: $0) } ?? MovieFormViewModel()
    )
  }

  var body: some View {
    NavigationStack {
      Form {
        Section("Title"){
          TextField("Type here...", text: $viewModel.name)
            .autocorrectionDisabled()
        }

        Section("Year"){
          Picker("placeholder", selection: $viewModel.year){
            ForEach(viewModel.selectableYears, id: \.self){ year in
              Text(String(year)).tag(year)
            }
          }
          .pickerStyle(.wheel)
          .labelsHidden()
          .frame(height: 170)
          .frame(height: 110, alignment: .top)
          .clipped()
        }

        Section {
          Group {
            TextField("Director", text: $viewModel.firstDirector)
            TextField("Second director (optional)", text: $viewModel.secondDirector)
          }
          .textInputAutocapitalization(.words)
          .autocorrectionDisabled()

          if viewModel.canMarkMoreDirectors {
            Toggle("More than two directors", isOn: $viewModel.hasMoreDirectors)
          }
        } header: {
          Text("Directors")
        } footer: {
          if !viewModel.directorsCredit.isEmpty {
            Text("Shown as: \(viewModel.directorsCredit)")
          }
        }
      }
      .navigationTitle(movie == nil ? "New Movie Entry" : "Edit Movie")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .confirmationAction) {
          Button(movie == nil ? "Add" : "Save", role: .confirm) {
            if let movie {
              viewModel.apply(to: movie)
            } else {
              modelContext.insert(viewModel.makeMovie())
            }
            try? modelContext.save()
            dismiss()
          }
          .disabled(!viewModel.canSave)
        }
      }
    }
  }
}

#Preview {
  MovieForm()
    .modelContainer(for: Movie.self, inMemory: true)
}
