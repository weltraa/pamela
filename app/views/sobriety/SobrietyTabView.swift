//
//  SobrietyTabView.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftData
import SwiftUI

struct SobrietyTabView: View {
  @Query(sort: \Addiction.name) private var addictions: [Addiction]

  @State private var viewModel = SobrietyTabViewModel()
  @State private var addictionToEdit: Addiction?

  var body: some View {
    let deck = viewModel.deck(of: addictions)

    VStack(spacing: 0) {
      Text("My Sobriety").font(.title).bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom)

      if addictions.isEmpty {
        NoEntriesNotice(
          icon: "apple.meditate",
          title: "Nothing tracked yet",
          description: "Tap + to start counting your time free of something"
        )
      }
      else {
        ScrollView {
          // Negative spacing overlaps the cards like a deck.
          VStack(spacing: -16) {
            ForEach(deck) { addiction in
              AddictionCard(
                addiction: addiction,
                isFront: addiction == deck.last
              ) {
                withAnimation(.snappy) { viewModel.frontID = addiction.id }
              } onEdit: {
                addictionToEdit = addiction
              }
            }
          }
          .padding(.horizontal)
          // Room for the cards' shadows, so the scroll view doesn't cut them.
          .padding(.vertical, 8)
        }
        // Same backdrop as the lists in the other tabs.
        .background(Color(.systemGroupedBackground))
      }
    }
    .sheet(item: $addictionToEdit) { addiction in
      SobrietyFormView(addiction: addiction)
    }
  }
}

// MARK: - Subviews

private struct AddictionCard: View {
  let addiction: Addiction
  let isFront: Bool
  let onSelect: () -> Void
  let onEdit: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(addiction.name).font(.title3.bold())

        Spacer()

        if isFront {
          Button("Edit", systemImage: "pencil", action: onEdit)
            .labelStyle(.iconOnly)
            // VoiceOver says which addiction, not just "Edit".
            .accessibilityLabel("Edit \(addiction.name)")
        }
      }

      if isFront {
        Text("Since \(addiction.startDate, format: .dateTime)")
          .font(.caption)
          .foregroundStyle(.secondary)

        Text(addiction.headline)
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 8)

        // Only the front card ticks, once a second.
        TimelineView(.periodic(from: .now, by: 1)) { context in
          VStack(spacing: 8) {
            ForEach(addiction.elapsed(at: context.date), id: \.unit) { part in
              ElapsedTile(unit: part.unit, value: part.value)
            }
          }
        }
      }
    }
    .padding(20)
    .background(
      Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20)
    )
    .shadow(color: .black.opacity(0.1), radius: 6, y: 2)
    .contentShape(.rect)
    .onTapGesture(perform: onSelect)
    .accessibilityElement(children: isFront ? .contain : .combine)
    .accessibilityAddTraits(isFront ? [] : .isButton)
  }
}

private struct ElapsedTile: View {
  let unit: Calendar.Component
  let value: Int

  // Cool colors around the app's blue accent, from purple (years) to mint
  // (seconds), so the tiles read as one gradient.
  private var style: (name: String, color: Color) {
    switch unit {
      case .year:   ("year", .purple)
      case .month:  ("month", .indigo)
      case .day:    ("day", .blue)
      case .hour:   ("hour", .cyan)
      case .minute: ("minute", .teal)
      default:      ("second", .mint)
    }
  }

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 8) {
      Text(value, format: .number).bold()
      Text(value == 1 ? style.name : "\(style.name)s")
    }
    .font(.largeTitle.italic())
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 24)
    .padding(.vertical, 8)
    .background {
      TileShape()
        .fill(Color(.tertiarySystemFill))
        .overlay {
          AccentShape()
            .fill(style.color)
            .clipShape(TileShape())
        }
    }
  }
}

// A tile whose right edge leans like "/", with rounded corners.
private struct TileShape: Shape {
  // How far the slanted edge leans, as a share of the height.
  static let slant: CGFloat = 0.5

  func path(in rect: CGRect) -> Path {
    let corners = [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.minY),
      CGPoint(x: rect.maxX - rect.height * Self.slant, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY)
    ]
    var path = Path()

    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    for (index, corner) in corners.enumerated() {
      path.addArc(
        tangent1End: corner,
        tangent2End: corners[(index + 1) % corners.count],
        radius: 10
      )
    }
    path.closeSubpath()

    return path
  }
}

// The colored wedge on a tile's left, leaning like its right edge.
private struct AccentShape: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.minX, y: rect.minY))
      path.addLine(
        to: CGPoint(x: rect.minX + rect.height * TileShape.slant, y: rect.minY)
      )
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.closeSubpath()
    }
  }
}

#Preview {
  SobrietyTabView()
    .modelContainer(for: Addiction.self, inMemory: true)
}
