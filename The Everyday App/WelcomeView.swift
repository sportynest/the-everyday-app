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
    var body: some View {
        VStack{
            VStack(spacing: 10){
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.top, 20)
                
                Text("Welcome to the Everyday App")
                    .font(.title)
                    .bold()
                Text("Get started by sharing your location")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                Text("The Everyday App")
                    .bold()
            }
            .padding()
            .multilineTextAlignment(.center)
            
            Spacer()
            LocationButton(.shareCurrentLocation) {
                print("Location button tapped")
                print(locationmanager.authorizationStatus)
                if locationmanager.authorizationStatus == .notDetermined {
                    print("location is not determined")
                    locationmanager.requestLocation()
                    print("requested location")
                } else {
                    print("location is not not determined")
                    locationmanager.checkLocationAuthorization()
                }
            }

            .cornerRadius(30)
            .padding()
        }
        .onAppear {
            locationmanager.checkLocationAuthorization()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LocationManager())
        .environmentObject(CalendarManager())
}
