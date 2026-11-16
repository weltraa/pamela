//
//  components/Backdrop.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// What lies behind lists and cards: the palette's background, under a
// faint speckle in themes that draw their own bars, for the linen look
// of iOS 6.
struct Backdrop: View {
  // Drawn once: a tile of sparse, faint light and dark dots.
  private static let speckle = UIGraphicsImageRenderer(
    size: CGSize(width: 64, height: 64)
  ).image { context in
    for x in 0..<64 {
      for y in 0..<64 where Bool.random() {
        UIColor(white: Bool.random() ? 1 : 0, alpha: .random(in: 0...0.1))
          .setFill()
        context.fill(CGRect(x: x, y: y, width: 1, height: 1))
      }
    }
  }

  @Environment(\.palette) private var palette

  var body: some View {
    palette.background
      .overlay {
        if palette.bars != nil {
          Image(uiImage: Self.speckle).resizable(resizingMode: .tile)
        }
      }
      .accessibilityHidden(true)
  }
}
