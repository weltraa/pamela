//
//  components/GradientNavigationBar.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// An iOS 6-style navigation bar: an opaque glossy gradient with an
// embossed title and the given buttons at its ends. Stands in for the
// system's navigation bar in themes that draw their own bars.
struct GradientNavigationBar<Leading: View, Trailing: View>: View {
  let title: String
  let bars: AppTheme.Palette.Bars
  let leading: Leading
  let trailing: Trailing

  var body: some View {
    ZStack {
      Text(title)
        .textCase(.uppercase)
        .font(.custom("HelveticaNeue-Bold", size: 20, relativeTo: .headline))
        .foregroundStyle(.white)
        .shadow(color: bars.textShadow, radius: 0, y: -1)
        .accessibilityAddTraits(.isHeader)

      HStack {
        leading
        Spacer()
        trailing
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 44)
    .background {
      bars.gradient(bars.navigation).ignoresSafeArea(edges: .top)
    }
  }

  init(
    title: String,
    bars: AppTheme.Palette.Bars,
    @ViewBuilder leading: () -> Leading,
    @ViewBuilder trailing: () -> Trailing
  ) {
    self.title = title
    self.bars = bars
    self.leading = leading()
    self.trailing = trailing()
  }
}
