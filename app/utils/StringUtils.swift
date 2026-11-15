//
//  StringUtils.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation

enum StringUtils {
  nonisolated static func trimmedTitle(for title: String) -> String {
    title.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // A version of `text` for comparing names: ignores case and accents,
  // so "Alfonso Cuarón" and "alfonso cuaron" match.
  nonisolated static func matchKey(for text: String) -> String {
    trimmedTitle(for: text).folding(
      options: [.caseInsensitive, .diacriticInsensitive], locale: .current
    )
  }
}
