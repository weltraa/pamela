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
  @Query(sort: \Movie.createdAt, order: .reverse) private var movies: [Movie]

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
          VStack(alignment: .leading) {
            Text("\(movie.name) (\(String(movie.year)))").bold()
            Text("Dir. \(movie.directorsCredit)")
              .font(.footnote)
              .foregroundStyle(.secondary)
          }
        }
      }
    }
  }
}

#Preview {
  MovieTabView()
    .modelContainer(for: Movie.self, inMemory: true)
}
