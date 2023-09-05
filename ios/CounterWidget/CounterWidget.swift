//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Anton Borries on 02.09.23.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> CounterEntry {
    CounterEntry(date: Date(), count: 0)
  }

  func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> Void) {
    let prefs = UserDefaults(suiteName: "group.es.antonborri.homeWidgetCounter")
    let entry = CounterEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    getSnapshot(in: context) { (entry) in
      let timeline = Timeline(entries: [entry], policy: .atEnd)
      completion(timeline)
    }
  }
}

struct CounterEntry: TimelineEntry {
  let date: Date
  let count: Int
}

struct CounterWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Text("You have pushed the button this many times:").font(.caption2).frame(
        maxWidth: .infinity, alignment: .center)
      Spacer()
      Text(entry.count.description).font(.title).frame(maxWidth: .infinity, alignment: .center)
      Spacer()
      HStack {
        Button(intent: BackgroundIntent(method: "clear")) {
          Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.red).frame(
            width: 24, height: 24)
        }.buttonStyle(.plain).frame(alignment: .leading)
        Spacer()
        Button(intent: BackgroundIntent(method: "increment")) {
          Image(systemName: "plus").font(.system(size: 16)).foregroundColor(.white)

        }.frame(width: 24, height: 24)
          .background(.blue)
          .cornerRadius(12).frame(alignment: .trailing)
      }
    }
  }
}

struct CounterWidget: Widget {
  let kind: String = "CounterWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        CounterWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        CounterWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall){
  CounterWidget()
} timeline: {
  CounterEntry(date: .now, count: 0)
  CounterEntry(date: .now, count: 0)
}
