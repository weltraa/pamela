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

  // The non-empty names, trimmed and in order. A name repeated with
  // different case or accents is kept once.
  nonisolated static func uniqueNames(_ names: [String]) -> [String] {
    var seenKeys = Set<String>()

    return names
      .map(trimmedTitle(for:))
      .filter { !$0.isEmpty && seenKeys.insert(matchKey(for: $0)).inserted }
  }

  // Names joined for display, e.g. "David Fincher, Mel Gibson et al.".
  nonisolated static func credit(for names: [String], hasMore: Bool) -> String {
    let joined = names.joined(separator: ", ")

    return hasMore ? "\(joined) et al." : joined
  }
}
