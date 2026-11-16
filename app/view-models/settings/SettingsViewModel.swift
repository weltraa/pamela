//
//  SettingsViewModel.swift
//  Pamela
//
//  Copyright © 2026 weltraa. All rights reserved.
//  Licensed under the PolyForm Strict License 1.0.0. See LICENSE.
//

import Foundation
import Observation

@Observable
final class SettingsViewModel {
  // Values from the app's Info.plist, which Xcode builds from the target's
  // settings (product name, version, copyright).
  private let info = Bundle.main.infoDictionary ?? [:]

  var appName: String {
    info["CFBundleName"] as? String ?? ""
  }

  var version: String {
    info["CFBundleShortVersionString"] as? String ?? ""
  }

  var copyright: String {
    info["NSHumanReadableCopyright"] as? String ?? ""
  }
}
