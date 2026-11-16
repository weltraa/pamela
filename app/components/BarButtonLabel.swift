//
//  components/BarButtonLabel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// A bar button's label: the system's glyph, or an iOS 6-style glossy,
// bordered button in themes that draw their own bars.
struct BarButtonLabel: View {
  @Environment(\.palette) private var palette

  let title: String
  let systemImage: String

  var body: some View {
    if let bars = palette.bars {
      Image(systemName: systemImage)
        .font(.body.bold())
        .foregroundStyle(.white)
        .shadow(color: bars.textShadow, radius: 0, y: -1)
        .frame(width: 22, height: 18)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
          LinearGradient(
            colors: bars.button, startPoint: .top, endPoint: .bottom
          ),
          in: .rect(cornerRadius: 5)
        )
        .overlay {
          // Its dark edge, and a bright inner edge fading downwards.
          RoundedRectangle(cornerRadius: 5).strokeBorder(bars.border)
          RoundedRectangle(cornerRadius: 4)
            .strokeBorder(
              LinearGradient(
                colors: [.white.opacity(0.4), .white.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .padding(1)
        }
        .accessibilityLabel(title)
    }
    else {
      Label(title, systemImage: systemImage)
    }
  }
}
