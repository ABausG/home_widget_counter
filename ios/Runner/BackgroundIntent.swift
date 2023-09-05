//
//  BackgroundIntent.swift
//  Runner
//
//  Created by Anton Borries on 02.09.23.
//

import AppIntents
import Flutter
import Foundation
import home_widget

@available(iOS 16, *)
public struct BackgroundIntent: AppIntent {
  static public var title: LocalizedStringResource = "Increment Counter"

  @Parameter(title: "Method")
  var method: String

  public init() {
    method = "increment"
  }

  public init(method: String) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
    await HomeWidgetBackgroundWorker.run(
      url: URL(string: "homeWidgetCounter://\(method)"),
      appGroup: "group.es.antonborri.homeWidgetCounter")

    return .result()
  }
}

/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 16, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}
