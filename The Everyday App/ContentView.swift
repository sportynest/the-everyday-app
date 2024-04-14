//
//  ContentView.swift
//  Emoji Lover
//
//  Created by Lekan Soyewo on 2023-10-18.
//

import SwiftUI

enum fates: String, CaseIterable{
    case good, bad, meh
}

enum middaypics: String, CaseIterable{
    case niagarafalls
}
struct ContentView: View {
    @StateObject var locationmanager = LocationManager()
    @StateObject var weathermanager = WeatherManager()
    @State var weather: ResponseBody?
    @State var isLoading = false
    @State var errorOccurred = false
    @State private var isLocationAuthorized = false
    @State private var shouldShowWeatherView = false
    @State private var currentError: Error?

    var body: some View {
        if let error = currentError {
            ErrorView(error: error, retryAction: retryWeatherFetch)  // Pass the error to ErrorView
        } else
        {
            Group {
                if isLocationAuthorized && shouldShowWeatherView, let weatherData = weather {
                    WeatherView(weather: weatherData)
                        .transition(.move(edge: .trailing))
                } else {
                    WelcomeView()
                        .transition(.move(edge: .leading))
                        .environmentObject(locationmanager)
                        .onAppear {
                            locationmanager.checkLocationAuthorization()
                        }
                        .onChange(of: locationmanager.isAuthorized) { _, newValue in
                            isLocationAuthorized = newValue
                            if newValue {
                                fetchWeather()
                            }
                        }
                }
            }
            .animation(.easeInOut, value: locationmanager.isAuthorized)
        }
        
    }
    
    private func retryWeatherFetch() {
            currentError = nil // Clear existing error
            fetchWeather()
    }

    private func requestLocation() {
        locationmanager.requestLocation()
    }

    private func fetchWeather() {
        guard let location = locationmanager.location else {
            return
        }
        isLoading = true
        Task {
            do {
                weather = try await weathermanager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                isLoading = false
                shouldShowWeatherView = true
            } catch {
                isLoading = false
                currentError = error
            }
        }
    }

    private func handleWeatherFetchError(_ error: Error) {
        print("Error getting weather: \(error.localizedDescription)")
        isLoading = false
        errorOccurred = true
    }

    struct ErrorView: View {
        let error: Error
        let retryAction: () -> Void

          var body: some View {
            VStack {
              Text("⚠️ Error Occurred")
              
              // Enhanced Handling
                if let weatherError = error as? WeatherError {
                    switch weatherError {
                        case .networkError: Text("Network Error. Check your connection.")
                        case .locationAccessDenied: Text("Enable location access in Settings.")
                        case .invalidWeatherData: Text("Unexpected weather data received.")
                        case .decodingError: Text("Error decoding weather data.")
                    }
                }   
                else {
                    Text("An unexpected error occurred.")
                }
                Button("Retry") {
                retryAction()
                }
                .padding()
            }
          }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

