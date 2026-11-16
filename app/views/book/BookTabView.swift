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
  @State private var viewModel = BookTabViewModel()

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
        List {
          ForEach(books) { book in
            BookRow(book: book) {
              withAnimation { viewModel.toggleChapters(of: book) }
            } onEdit: {
              bookToEdit = book
            }
            .swipeActions(edge: .trailing) {
              Button(role: .destructive) {
                withAnimation { modelContext.delete(book) }
                try? modelContext.save()
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }

            if viewModel.isExpanded(book) {
              ForEach(book.chapters) { chapter in
                ChapterRow(book: book, chapter: chapter)
              }
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

// MARK: - Subviews

private struct BookRow: View {
  let book: Book
  let onTap: () -> Void
  let onEdit: () -> Void

  var body: some View {
    HStack {
      Button(action: onTap) {
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
        }
        // The whole row opens the chapters, not just its text.
        .contentShape(.rect)
      }
      .buttonStyle(.plain)
      .accessibilityHint("Shows or hides the chapters")

      Button("Edit", systemImage: "pencil", action: onEdit)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderless)
        // VoiceOver says which book, not just "Edit".
        .accessibilityLabel("Edit \(book.title)")
    }
  }
}

private struct ChapterRow: View {
  @Environment(\.modelContext) private var modelContext

  let book: Book
  let chapter: Book.Chapter

  var body: some View {
    Button {
      book.toggleRead(chapter)
      try? modelContext.save()
    } label: {
      Label {
        Text(chapter.title)
          .foregroundStyle(.primary)
      } icon: {
        Image(systemName: chapter.isRead ? "checkmark.circle.fill" : "circle")
      }
    }
    .padding(.leading)
    .accessibilityValue(chapter.isRead ? "Read" : "Unread")
  }
}

#Preview {
  BookTabView()
    .modelContainer(for: Book.self, inMemory: true)
}
