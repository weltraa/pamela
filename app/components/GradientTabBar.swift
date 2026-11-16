//
//  components/GradientTabBar.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// An iOS 6-style tab bar: an opaque black gradient with embossed glyphs
// and a lit-up block behind the current tab. Stands in for the system's
// tab bar in themes that draw their own bars.
struct GradientTabBar: View {
  @Binding var selection: RootViewModel.RootTab
  let bars: AppTheme.Palette.Bars

  var body: some View {
    HStack(spacing: 2) {
      ForEach(RootViewModel.RootTab.allCases) { tab in
        let isSelected = tab == selection

        Button {
          selection = tab
        } label: {
          Image(systemName: tab.icon)
            .symbolVariant(.fill)
            .font(.title2)
            .foregroundStyle(isSelected ? Color.white : Color(white: 0.62))
            .shadow(color: .black.opacity(0.8), radius: 0, y: -1)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background {
              if isSelected {
                RoundedRectangle(cornerRadius: 4)
                  .fill(.white.opacity(0.12))
                  .overlay {
                    RoundedRectangle(cornerRadius: 4)
                      .strokeBorder(.black.opacity(0.5))
                  }
              }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
      }
    }
    .padding(.horizontal, 4)
    .padding(.vertical, 2)
    .background {
      bars.gradient(bars.tab).ignoresSafeArea(edges: .bottom)
    }
  }
}
