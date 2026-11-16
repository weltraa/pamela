//
//  BookFormView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct BookFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Query private var books: [Book]

  @State private var viewModel: BookFormViewModel
  @FocusState private var isAddingChapter: Bool

  // The book being edited, or `nil` when adding a new one.
  private let book: Book?

  var body: some View {
    let isDuplicate = viewModel.isDuplicate(among: books, excluding: book)

    NavigationStack {
      Form {
        Section {
          TextField("Type here...", text: $viewModel.title)
            .autocorrectionDisabled()
        } header: {
          Text("Title")
        } footer: {
          if isDuplicate {
            Text("This book is already in your list.")
              .foregroundStyle(.red)
          }
        }

        Section("Year") {
          YearPicker(
            selection: $viewModel.year,
            years: viewModel.selectableYears
          )
        }

        CreditSection(
          title: "Authors",
          role: "Author",
          first: $viewModel.firstAuthor,
          second: $viewModel.secondAuthor,
          hasMore: $viewModel.hasMoreAuthors,
          canMarkMore: viewModel.canMarkMoreAuthors,
          credit: viewModel.authorsCredit
        )

        Section("Table of Contents") {
          ForEach($viewModel.chapters) { $chapter in
            HStack {
              Button(
                chapter.isRead ? "Mark as unread" : "Mark as read",
                systemImage: chapter.isRead ? "checkmark.circle.fill" : "circle"
              ) {
                chapter.isRead.toggle()
              }
              .labelStyle(.iconOnly)
              .buttonStyle(.borderless)

              TextField("Chapter title", text: $chapter.title)
            }
          }
          .onDelete { viewModel.chapters.remove(atOffsets: $0) }

          TextField("Add chapter", text: $viewModel.newChapterTitle)
            .focused($isAddingChapter)
            .submitLabel(.next)
            .onSubmit {
              viewModel.addChapter()
              // Keeps the keyboard up to type the next chapter.
              isAddingChapter = true
            }
        }
      }
      .navigationTitle(book == nil ? "New Book" : "Edit Book")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            dismiss()
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(book == nil ? "Add" : "Save", role: .confirm) {
            if let book {
              viewModel.apply(to: book)
            }
            else {
              modelContext.insert(viewModel.makeBook())
            }
            try? modelContext.save()
            dismiss()
          }
          .disabled(!viewModel.canSave || isDuplicate)
        }
      }
    }
  }

  init(book: Book? = nil) {
    self.book = book
    _viewModel = State(
      initialValue:
        book.map {
          BookFormViewModel(book: $0)
        } ?? BookFormViewModel()
    )
  }
}

#Preview {
  BookFormView()
    .modelContainer(for: Book.self, inMemory: true)
}
