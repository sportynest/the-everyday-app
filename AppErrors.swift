//
//  AppErrors.swift
//  The Everyday App
//
//  Created by Lekan Soyewo on 2024-04-13.
//

import Foundation


// In a dedicated file, maybe called 'AppErrors.swift'
enum WeatherError: Error {
    case networkError(Error) // Wrap underlying network errors
    case locationAccessDenied
    case invalidWeatherData
    case decodingError(DecodingError)
}

enum CalendarError: Error {
    case accessDenied
    case eventFetchFailed
}
