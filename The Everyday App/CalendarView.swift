//
//  CalendarView.swift
//  The Everyday App
//
//  Created by Lekan Soyewo on 2024-04-13.
//

import SwiftUI
import EventKit

struct CalendarView: View {
    let events: [EKEvent]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Events")
                .font(.title2).bold()
                .padding(.bottom)

            if events.isEmpty {
                Text("No events scheduled for today.")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(events, id: \.eventIdentifier) { event in
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.accentColor)
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                Text(event.formattedTimeRange) // Helper function for nice time formatting
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// Helper function to format event time range (you can customize this)
extension EKEvent {
    var formattedTimeRange: String {
        let startFormatter = DateFormatter()
        startFormatter.timeStyle = .short
        let endFormatter = DateFormatter()
        endFormatter.timeStyle = .short
        return "\(startFormatter.string(from: startDate)) - \(endFormatter.string(from: endDate))"
    }
}

