import WidgetKit
import SwiftUI

struct Lesson: Decodable {
    let start: String
    let end: String
    let abbr: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), lessons: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(Entry(date: Date(), lessons: HomeWidgetProvider.shared.loadLessons()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = Entry(date: Date(), lessons: HomeWidgetProvider.shared.loadLessons())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let lessons: [Lesson]
}

struct TimetableWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(entry.lessons.prefix(3), id: \.start) { lesson in
                HStack {
                    Text(lesson.start)
                        .font(.system(size: 14))
                    Text(lesson.abbr)
                        .font(.system(size: 14))
                        .bold()
                }
            }
        }.padding()
    }
}

@main
struct TimetableWidget: Widget {
    let kind: String = "TimetableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimetableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Timetable")
        .description("Shows your timetable for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

class HomeWidgetProvider {
    static let shared = HomeWidgetProvider()
    let appGroupId = "group.de.codingbrain.sharezone.widget"

    func loadLessons() -> [Lesson] {
        guard let defaults = UserDefaults(suiteName: appGroupId),
              let dataString = defaults.string(forKey: "timetable"),
              let data = dataString.data(using: .utf8),
              let lessons = try? JSONDecoder().decode([Lesson].self, from: data) else {
            return []
        }
        return lessons
    }
}
