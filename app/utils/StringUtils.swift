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
}
