//
//  models/AppTheme.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import SwiftUI

// The app's look, picked in Settings.
enum AppTheme: String, CaseIterable, Identifiable {
  case classicLight
  case classicDark
  case retro

  // Where the choice is saved, through @AppStorage.
  static let storageKey = "appTheme"
  static let defaultTheme = AppTheme.classicLight

  // The colors the app's screens draw with, by role.
  struct Palette {
    // Apple's own system colors, as in Apple's apps. They already have
    // light, dark and Increase Contrast versions, so one palette serves
    // both classic themes.
    static let classic = Palette(
      // The app's AccentColor asset; with no color set it's Apple's blue,
      // and it's what buttons and controls already use.
      accent: .accentColor,
      success: .green,
      destructive: .red,
      secondaryAction: .indigo,
      background: Color(.systemGroupedBackground),
      surface: Color(.secondarySystemGroupedBackground),
      fill: Color(.tertiarySystemFill),
      border: nil,
      cornerRadius: 20,
      gloss: 0,
      // The system colors in spectral order, as in the color pickers of
      // Reminders and Calendar.
      spectrum: [.red, .orange, .yellow, .green, .blue, .purple],
      bars: nil
    )

    // The iOS 6 look: glossy blue bars, a black tab bar and white cards
    // with gray edges on linen.
    static let retro = Palette(
      accent: Color(red: 0.25, green: 0.45, blue: 0.61),
      success: Color(red: 0.35, green: 0.63, blue: 0.17),
      destructive: Color(red: 0.75, green: 0.22, blue: 0.17),
      secondaryAction: Color(red: 0.42, green: 0.49, blue: 0.56),
      background: Color(white: 0.91),
      surface: .white,
      fill: Color(white: 0.84),
      border: Color(white: 0.72),
      cornerRadius: 5,
      gloss: 0.35,
      // Printed-looking colors of the time: brick, amber, olive, teal,
      // steel blue and plum.
      spectrum: [
        Color(red: 0.65, green: 0.29, blue: 0.24),
        Color(red: 0.79, green: 0.57, blue: 0.18),
        Color(red: 0.54, green: 0.60, blue: 0.23),
        Color(red: 0.24, green: 0.56, blue: 0.53),
        Color(red: 0.25, green: 0.45, blue: 0.61),
        Color(red: 0.48, green: 0.36, blue: 0.56)
      ],
      bars: Bars(
        navigation: [
          Color(red: 0.49, green: 0.63, blue: 0.80),
          Color(red: 0.25, green: 0.43, blue: 0.64)
        ],
        button: [
          Color(red: 0.40, green: 0.56, blue: 0.75),
          Color(red: 0.20, green: 0.37, blue: 0.57)
        ],
        tab: [Color(white: 0.30), Color(white: 0.09)],
        border: Color(red: 0.14, green: 0.27, blue: 0.43),
        textShadow: .black.opacity(0.5)
      )
    )

    // Opaque gradient bars the app draws itself, like iOS 6's. `nil`
    // keeps the system's bars and window background.
    struct Bars {
      // Gradient stops, top to bottom.
      let navigation: [Color]
      let button: [Color]
      let tab: [Color]
      // Edges of the bars and their buttons.
      let border: Color
      // Under the bars' white text, for the embossed look.
      let textShadow: Color

      // A bar's gradient, with a bright hairline along its top and a dark
      // one along its bottom.
      func gradient(_ colors: [Color]) -> LinearGradient {
        let highlight = Color.white.opacity(0.3)
        let shade = Color.black.opacity(0.5)

        return LinearGradient(
          stops: [
            .init(color: highlight, location: 0),
            .init(color: highlight, location: 0.02),
            .init(color: colors.first ?? shade, location: 0.02),
            .init(color: colors.last ?? shade, location: 0.98),
            .init(color: shade, location: 0.98),
            .init(color: shade, location: 1)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      }
    }

    let accent: Color
    let success: Color
    let destructive: Color
    let secondaryAction: Color
    // Behind lists and cards.
    let background: Color
    // Cards and rows on top of `background`.
    let surface: Color
    // Unselected controls and tiles.
    let fill: Color
    // Around cards and tiles; `nil` draws no edge.
    let border: Color?
    // Of cards.
    let cornerRadius: CGFloat
    // How strong the sheen over tiles is, from 0 (matte) to 1.
    let gloss: Double
    // Ordered colors for a sequence, e.g. years to seconds.
    let spectrum: [Color]
    let bars: Bars?
  }

  var id: Self { self }

  var title: String {
    switch self {
      case .classicLight: "Classic Light"
      case .classicDark:  "Classic Dark"
      case .retro:        "Retro"
    }
  }

  var colorScheme: ColorScheme {
    switch self {
      case .classicLight, .retro: .light
      case .classicDark:          .dark
    }
  }

  var palette: Palette {
    switch self {
      case .classicLight, .classicDark: .classic
      case .retro:                      .retro
    }
  }
}

extension EnvironmentValues {
  // The current theme's palette, set by `appTheme()`.
  @Entry var palette = AppTheme.Palette.classic
}

extension View {
  // Applies the theme picked in Settings: its light or dark mode, its
  // palette and its accent for the system's controls. Used at the app's
  // root and in previews, which don't go through the app's root.
  func appTheme() -> some View {
    modifier(AppThemeModifier())
  }

  // The current theme's navigation bar, with `title` and the given
  // buttons on it. Themes that keep the system's bars leave it as it is
  // and take their buttons from the view's own toolbar instead.
  func themedBars<Leading: View, Trailing: View>(
    title: String,
    @ViewBuilder leading: () -> Leading,
    @ViewBuilder trailing: () -> Trailing
  ) -> some View {
    modifier(
      ThemedBarsModifier(
        title: title, leading: leading(), trailing: trailing()
      )
    )
  }

  func themedBars<Leading: View>(
    title: String,
    @ViewBuilder leading: () -> Leading
  ) -> some View {
    themedBars(title: title, leading: leading) { EmptyView() }
  }

  // The current theme's backdrop behind lists. Themes that keep the
  // system's bars leave the screen as it is. Goes on each screen's
  // content, since a tab's content covers whatever is behind the tab view.
  func themedBackdrop() -> some View {
    modifier(ThemedBackdropModifier())
  }
}

private struct AppThemeModifier: ViewModifier {
  @AppStorage(AppTheme.storageKey) private var theme = AppTheme.defaultTheme

  func body(content: Content) -> some View {
    content
      .preferredColorScheme(theme.colorScheme)
      .tint(theme.palette.accent)
      .environment(\.palette, theme.palette)
  }
}

private struct ThemedBarsModifier<Leading: View, Trailing: View>: ViewModifier {
  @Environment(\.palette) private var palette

  let title: String
  let leading: Leading
  let trailing: Trailing

  func body(content: Content) -> some View {
    content
      // The system's bar can't take an opaque gradient, so the app's own
      // bar takes its place.
      .toolbarVisibility(
        palette.bars == nil ? .automatic : .hidden, for: .navigationBar
      )
      .safeAreaInset(edge: .top, spacing: 0) {
        if let bars = palette.bars {
          GradientNavigationBar(title: title, bars: bars) {
            leading
          } trailing: {
            trailing
          }
        }
      }
  }
}

private struct ThemedBackdropModifier: ViewModifier {
  @Environment(\.palette) private var palette

  func body(content: Content) -> some View {
    let hasOwnBars = palette.bars != nil

    content
      .scrollContentBackground(hasOwnBars ? .hidden : .automatic)
      .background {
        if hasOwnBars {
          Backdrop().ignoresSafeArea()
        }
      }
  }
}
