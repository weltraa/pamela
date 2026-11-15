//
//  MovieTabView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct MovieTabView: View {
  @Environment(\.modelContext) private var modelContext
  // By title, then by year so remakes ("Dune" 1984, 2021) keep a fixed order.
  @Query(sort: [SortDescriptor(\Movie.name), SortDescriptor(\Movie.year)])
  private var movies: [Movie]

  @State private var movieToEdit: Movie?
  @State private var viewModel = MovieTabViewModel()

  var body: some View {
    let filteredMovies = viewModel.filtered(movies)

    VStack(spacing: 0) {
      HStack {
        Text("My Movie List").font(.title).bold()

        Spacer()

        if !movies.isEmpty {
          MovieFilterMenu(viewModel: viewModel, movies: movies)
        }
      }
      .padding(.horizontal)
      .padding(.bottom)

      if movies.isEmpty {
        NoEntriesNotice(
          icon: "list.and.film",
          title: "No movies yet",
          description: "Tap + to add your first favorite movie"
        )
      }
      else if filteredMovies.isEmpty {
        NoEntriesNotice(
          icon: "line.3.horizontal.decrease.circle",
          title: "No matching movies",
          description: "Try another year or director, or clear the filters."
        )
      }
      else {
        List(filteredMovies) { movie in
          HStack {
            VStack(alignment: .leading) {
              Text("\(movie.name) (\(String(movie.year)))").bold()
              Text("Dir. \(movie.directorsCredit)")
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Edit", systemImage: "pencil") {
              movieToEdit = movie
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            // VoiceOver says which movie, not just "Edit".
            .accessibilityLabel("Edit \(movie.name)")
          }
          .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
              withAnimation { modelContext.delete(movie) }
              try? modelContext.save()
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
      }
    }
    .sheet(item: $movieToEdit) { movie in
      MovieForm(movie: movie)
    }
    .onChange(of: viewModel.years(in: movies)) {
      viewModel.dropStaleFilters(for: movies)
    }
    .onChange(of: viewModel.directors(in: movies)) {
      viewModel.dropStaleFilters(for: movies)
    }
  }
}

// MARK: - Subviews

private struct MovieFilterMenu: View {
  @Bindable var viewModel: MovieTabViewModel
  let movies: [Movie]

  var body: some View {
    Menu {
      Picker("Year", selection: $viewModel.selectedYear) {
        Text("Any Year").tag(UInt16?.none)

        ForEach(viewModel.years(in: movies), id: \.self) { year in
          Text(String(year)).tag(Optional(year))
        }
      }
      .pickerStyle(.menu)

      Picker("Director", selection: $viewModel.selectedDirector) {
        Text("Any Director").tag(String?.none)

        ForEach(viewModel.directors(in: movies), id: \.self) { director in
          Text(director).tag(Optional(director))
        }
      }
      .pickerStyle(.menu)

      if viewModel.isFiltering {
        Divider()

        Button("Clear Filters", systemImage: "xmark.circle") {
          viewModel.clearFilters()
        }
      }
    } label: {
      Label(
        "Filter",
        systemImage: viewModel.isFiltering
          ? "line.3.horizontal.decrease.circle.fill"
          : "line.3.horizontal.decrease.circle"
      )
      .labelStyle(.iconOnly)
      .font(.title2)
    }
  }
}

#Preview {
  MovieTabView()
    .modelContainer(for: Movie.self, inMemory: true)
}
