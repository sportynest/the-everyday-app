//
//  WeatherView.swift
//  Weather - Cal App
//
//  Created by Lekan Soyewo on 2023-10-21.
import SwiftUI
import EventKit

let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)

let backgroundGradient2 = LinearGradient(
    colors: [Color.white],
    startPoint: .top, endPoint: .bottom)

let backgroundGradient3 = LinearGradient(
    colors: [Color.clear],
    startPoint: .top, endPoint: .bottom)

let weatherlightbackground = LinearGradient(
    colors: [Color.blue, Color.white],
    startPoint: .top, endPoint: .bottom)

extension Double {
    var formattedTemperature: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0 // Adjust for desired decimal places
        if let formattedString = formatter.string(from: self as NSNumber) {
            return "\(formattedString)°"
        } else {
            return "-" // Return a default value in case of errors
        }
    }
}

extension Date {
    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}

struct WeatherView: View {
    var weather: ResponseBody // Updated to use WeatherData
    @EnvironmentObject var calendarmanager: CalendarManager
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var locationManager = LocationManager()
    @State private var calendarEvents: [EKEvent] = []
    @State private var dailyForecasts: [DailyForecast] = []
    
    var body: some View {
        ZStack {
              // Background Gradient
              LinearGradient(colors: [.teal.opacity(0.3), .cyan.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)

              VStack(alignment: .leading, spacing: 20) {
                  HStack(alignment: .top) {
                      // Custom Weather Icon
                      Image(systemName: "sun.max.fill")
                          .font(.system(size: 50))
                          .foregroundColor(.yellow)
                      
                      Spacer()
                      
                      VStack(alignment: .trailing) {
                          Text("Hello, Your Name")
                              .bold()
                              .font(.title2)
                          
                          Text(weather.current?.weather?.first?.description?.capitalized ?? "Weather data unavailable")
                              .foregroundColor(.gray)
                          
                          
                          ForEach(dailyForecasts, id: \.id) { forecast in
                              DailyWeatherCard(forecast: forecast) // Create a DailyWeatherCard view
                          }
                          
                          Spacer()
                          
                          NavigationLink {
                              CalendarView(events: calendarEvents) // Pass fetched events
                          } label: {
                              Text("Calendar")
                                  .bold()
                                  .foregroundColor(.white)
                                  .padding()
                                  .background(Color.blue)
                                  .cornerRadius(10)
                          }
                      }
                      .padding()
                      .foregroundColor(.white) // Text color contrast
                  }
                }

                
            }
        .task { // Use .task modifier for data fetching on view appearance
                        await fetchWeatherAndCalendarData()
                    }
        .onAppear {
            fetchCalendarEvents(value: 1) // Example: Fetch events for the next day
        }
    }
    
    private func fetchCalendarEvents(value: Int) {
        
        calendarmanager.requestAccessAndFetchEvents(value: value) { events in
                DispatchQueue.main.async {
                self.calendarEvents = events ?? []
            }
        }
    }
    
    private func fetchWeatherAndCalendarData() async{
        // ... your existing weather fetching logic ...

        do {
            let weatherResponse = try await weatherManager.getCurrentWeather(latitude: locationManager.location?.latitude ?? 0, longitude: locationManager.location?.longitude ?? 0) // Update here


            calendarmanager.requestAccessAndFetchEvents(value: 7) { events in
                let groupedEvents = Dictionary(grouping: events!) { $0.startDate.startOfDay } // Group by date

                        // Assuming you fetch daily weather data
                        var forecasts: [DailyForecast] = []
                        for dailyWeather in weatherResponse.daily ?? [] {
                            let date = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt ?? 0))
                            let eventsForDate = groupedEvents[date] ?? []
                            forecasts.append(DailyForecast(date: date, weather: dailyWeather, events: eventsForDate))
                        }

                        DispatchQueue.main.async {
                            self.dailyForecasts = forecasts
                        }
                    }
        } catch {
            // Handle fetching errors appropriately.
            print("Error fetching weather or calendar data: \(error)")
        }
    }

    
}

struct DailyWeatherCard: View {
    let forecast: DailyForecast

    var body: some View {
        VStack {
            Text(forecast.date.formatted(date: .abbreviated, time: .omitted))
            // Display weather: icon, temp ...
            
            if !forecast.events.isEmpty {
                Text("Events:")
                // Create neat views for each event
            }
        }
    }
}

struct DailyForecast: Identifiable {
  let id = UUID()
  let date: Date
  let weather: ResponseBody.DailyWeather // Use DailyWeather here
  let events: [EKEvent]
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock instance of WeatherData for preview
        let mockWeatherData = ResponseBody(lat: 0.0, lon: 0.0, timezone: "GMT", timezoneOffset: 0, current: ResponseBody.CurrentWeather(dt: 0, sunrise: 0, sunset: 0, temp: 0.0, feelsLike: 0.0, pressure: 0, humidity: 0, dewPoint: 0.0, uvi: 0.0, clouds: 0, visibility: 0, windSpeed: 0.0, windDeg: 0, windGust: 0.0, weather: [ResponseBody.Weather(id: 0, main: "", description: "", icon: "")]), minutely: [], hourly: [], daily: [], alerts: [])
        
        WeatherView(weather: mockWeatherData)
            .environmentObject(CalendarManager())
    }
}

