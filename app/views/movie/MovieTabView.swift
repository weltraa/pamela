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
  @Query(sort: \Movie.name, order: .forward) private var movies: [Movie]

  @State private var movieToEdit: Movie?

  var body: some View {
    VStack(spacing: 0) {
      Text("My Movie List").font(.title).bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom)
      
      if movies.isEmpty {
        NoEntriesNotice(
          icon: "list.and.film",
          title: "No movies yet",
          description: "Tap + to add your first favorite movie"
        )
      }
      else {
        List(movies) { movie in
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
  }
}

#Preview {
  MovieTabView()
    .modelContainer(for: Movie.self, inMemory: true)
}
