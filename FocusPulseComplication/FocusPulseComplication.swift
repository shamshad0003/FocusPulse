import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), mode: "Focus", timeRemaining: "25:00", cycle: 1, goalProgress: 0.25)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), mode: "Focus", timeRemaining: "25:00", cycle: 1, goalProgress: 0.25)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entries = [SimpleEntry(date: Date(), mode: "Focus", timeRemaining: "25:00", cycle: 1, goalProgress: 0.25)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mode: String
    let timeRemaining: String
    let cycle: Int
    let goalProgress: Double
}

struct FocusPulseComplicationEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Text("\(entry.cycle)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.blue)
                    Divider().frame(width: 20)
                    Text(entry.mode.prefix(1).uppercased())
                        .font(.system(size: 12, weight: .black))
                }
                
                Circle()
                    .trim(from: 0, to: entry.goalProgress)
                    .stroke(Color.green, lineWidth: 2)
                    .rotationEffect(.degrees(-90))
            }
            .containerBackground(.fill.tertiary, for: .widget)
            
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Text("FocusPulse")
                        .font(.system(size: 10, weight: .bold))
                    Spacer()
                    Text("C\(entry.cycle)")
                        .font(.system(size: 10))
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: entry.goalProgress)
                    .tint(.green)
                
                HStack {
                    Text("\(entry.mode): \(entry.timeRemaining)")
                        .font(.system(size: 10))
                    Spacer()
                    Text("\(Int(entry.goalProgress * 100))%")
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                }
            }
            .containerBackground(.fill.tertiary, for: .widget)
            
        default:
            Text(entry.timeRemaining)
        }
    }
}

struct FocusPulseComplication: Widget {
    let kind: String = "FocusPulseComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FocusPulseComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("FocusPulse Pro")
        .description("Automated cycles and goal tracking.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}
