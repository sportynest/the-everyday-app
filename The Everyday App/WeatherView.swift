//
//  WeatherView.swift
//  Weather - Cal App
//
//  Created by Lekan Soyewo on 2023-10-21.
//
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

struct WeatherView: View {
    var weather: ResponseBody // Updated to use WeatherData
    @EnvironmentObject var calendarmanager: CalendarManager
    @State private var calendarEvents: [EKEvent] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Hello, Your Name")
                        .bold()
                    // Accessing the first weather condition's description
                    if let weatherDescription = weather.current!.weather?.first?.description {
                        Text("Weather: \(weatherDescription)")
                            .bold()
                    }
                    else {
                        Text("Weather data unavailable")
                            .foregroundColor(.gray)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 15, trailing: 10))
                .preferredColorScheme(.dark)
                Spacer()
            }
            .background(backgroundGradient)
            .cornerRadius(20)
            .frame(maxWidth: .infinity)
            
            LazyVStack(alignment: .leading, spacing: 15) {
                Text("dv sd")
                ForEach(calendarEvents, id: \.eventIdentifier) { event in
                    Text(event.title)
                }
                Spacer()
            }
            .preferredColorScheme(.dark)
            .background(Color.black)
            .cornerRadius(0)
            .navigationTitle("Calendar")
            .onAppear() {
                fetchCalendarEvents(value: 1)
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Spacer()
        }
        .padding(EdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20))
        .frame(maxHeight: .infinity)
        .background(weatherlightbackground)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        .onAppear(){
            fetchCalendarEvents(value: 1)
        }
    }
    
    private func fetchCalendarEvents(value: Int) {
        
        calendarmanager.requestAccessAndFetchEvents(value: value) { events in
                DispatchQueue.main.async {
                self.calendarEvents = events ?? []
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock instance of WeatherData for preview
        let mockWeatherData = ResponseBody(lat: 0.0, lon: 0.0, timezone: "GMT", timezoneOffset: 0, current: ResponseBody.CurrentWeather(dt: 0, sunrise: 0, sunset: 0, temp: 0.0, feelsLike: 0.0, pressure: 0, humidity: 0, dewPoint: 0.0, uvi: 0.0, clouds: 0, visibility: 0, windSpeed: 0.0, windDeg: 0, windGust: 0.0, weather: [ResponseBody.Weather(id: 0, main: "", description: "", icon: "")]), minutely: [], hourly: [], daily: [], alerts: [])
        
        WeatherView(weather: mockWeatherData)
            .environmentObject(CalendarManager())
    }
}
