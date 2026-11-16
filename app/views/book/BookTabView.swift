//
//  BookTabView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct BookTabView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: [SortDescriptor(\Book.title), SortDescriptor(\Book.year)])
  private var books: [Book]

  @State private var bookToEdit: Book?

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("My Book List").font(.title).bold()
        Spacer()
      }
      .padding(.horizontal)
      .padding(.bottom)

      if books.isEmpty {
        NoEntriesNotice(
          icon: "book.closed",
          title: "No books yet",
          description: "Tap + to add your first book entry"
        )
      }
      else {
        List(books) { book in
          HStack {
            VStack(alignment: .leading) {
              Text("\(book.title) (\(String(book.year)))").bold()
              Text("by \(book.authorsCredit)")
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if let progress = book.progress {
              Text(progress, format: .percent.precision(.fractionLength(0)))
                .monospacedDigit()
                .foregroundStyle(.secondary)
            }

            Button("Edit", systemImage: "pencil") {
              bookToEdit = book
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            // VoiceOver says which book, not just "Edit".
            .accessibilityLabel("Edit \(book.title)")
          }
          .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
              withAnimation { modelContext.delete(book) }
              try? modelContext.save()
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
      }
    }
    .sheet(item: $bookToEdit) { book in
      BookFormView(book: book)
    }
  }
}

#Preview {
  BookTabView()
    .modelContainer(for: Book.self, inMemory: true)
}
