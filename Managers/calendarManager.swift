//
//  calendarManager.swift
//  Weather - Cal App
//
//  Created by Lekan Soyewo on 2023-11-19.
//

import EventKit
import Combine



class CalendarManager: ObservableObject{
    let eventStore = EKEventStore()
    
    func requestAccessAndFetchEvents(value: Int, completion: @escaping ([EKEvent]?) -> Void) {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted && error == nil {
                let startDate = Date()
                if let endDate = Calendar.current.date(byAdding: .weekOfYear, value: value, to: startDate) {
                    let events = self.fetchEvents(from: startDate, to: endDate)
                    completion(events)
                } else {
                    completion(nil)
                }
            } else {
                print("Error or access not granted: \(String(describing: error))")
                completion(nil)
            }
        }
    }

    
    
    
    private func fetchEvents(from startDate: Date, to endDate: Date) ->[EKEvent]? {
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        return events
    }
}
