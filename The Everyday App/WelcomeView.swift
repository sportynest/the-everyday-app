//
//  WelcomeView.swift
//  Weather - Cal App
//
//  Created by Lekan Soyewo on 2023-10-18.
//

import SwiftUI
import CoreLocationUI
import EventKit

struct WelcomeView: View {
    @EnvironmentObject var locationmanager: LocationManager
    @EnvironmentObject var calendarmanager: CalendarManager
    @State private var isRequestingLocation = false
    @State private var navigateToWeather = false
    var body: some View {
        NavigationStack{
            VStack{
                VStack(spacing: 15){
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.top, 20)
                    
                    Text("Welcome to the Everyday App")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 28 : 34))
                        .bold()
                    Text("Get started by sharing your location")
                        .font(.subheadline)
                }
                .padding()
                .multilineTextAlignment(.center)
                
                Spacer()
                LocationButton(.shareCurrentLocation) {
                    isRequestingLocation = true
                    locationmanager.requestLocationIfNecessary() // Refactored logic
                }
                .cornerRadius(30)
                .padding()
                .disabled(isRequestingLocation)
                
                if isRequestingLocation {
                    ProgressView() // Show loading indicator
                        .padding()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [.teal, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            .onAppear {
                locationmanager.checkLocationAuthorization()
            }
        }
        .onReceive(locationmanager.$authorizationStatus) { status in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                navigateToWeather = true

                // Start fetching weather data if needed
                if let location = locationmanager.location {
                    // Assuming you have a method to fetch weather (e.g., fetchWeather)
                    weathermanager.fetchWeather(latitude: location.latitude, longitude: location.longitude)
                }
            }
        }
        
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LocationManager())
        .environmentObject(CalendarManager())
}
