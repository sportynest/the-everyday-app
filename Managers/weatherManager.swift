//
//  weatherManager.swift
//  Weather - Cal App
//
//  Created by Lekan Soyewo on 2023-10-20.
//

import Foundation
import CoreLocation

class WeatherManager: ObservableObject {

    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=c19d8461df8cd3289475772d35626c54") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.requestFailed
            }
            
            // Print the raw JSON response for review
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
            
            // Decode the JSON data
            return try JSONDecoder().decode(ResponseBody.self, from: data)
        }catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw decodingError
        }catch {
               if (error as NSError).code == NSURLErrorCancelled {
                   // Handle the cancellation explicitly
                   throw WeatherError.cancelled
               } else {
                   // Rethrow other errors
                   throw error
               }
           }
    }
    enum WeatherError: Error {
        case invalidURL
        case requestFailed
        case decodingError
        case cancelled
        
    }
}




struct ResponseBody: Decodable {
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var timezoneOffset: Int?
    var current: CurrentWeather?
    var minutely: [MinutelyWeather]?
    var hourly: [HourlyWeather]?
    var daily: [DailyWeather]?
    var alerts: [WeatherAlert]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone, current, minutely, hourly, daily, alerts
        case timezoneOffset = "timezone_offset"
    }

    struct CurrentWeather: Decodable {
        var dt: Int?
        var sunrise: Int?
        var sunset: Int?
        var temp: Double?
        var feelsLike: Double?
        var pressure: Int?
        var humidity: Int?
        var dewPoint: Double?
        var uvi: Double?
        var clouds: Int?
        var visibility: Int?
        var windSpeed: Double?
        var windDeg: Int?
        var windGust: Double?
        var weather: [Weather]?

        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, temp, pressure, humidity, dewPoint, uvi, clouds, visibility, weather
            case feelsLike = "feels_like"
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
        }
    }

    struct MinutelyWeather: Decodable {
        var dt: Int?
        var precipitation: Double?
    }

    struct HourlyWeather: Decodable {
        var dt: Int?
        var temp: Double?
        var feelsLike: Double?
        var pressure: Int?
        var humidity: Int?
        var dewPoint: Double?
        var uvi: Double?
        var clouds: Int?
        var visibility: Int?
        var windSpeed: Double?
        var windDeg: Int?
        var windGust: Double?
        var weather: [Weather]?
        var pop: Double?

        enum CodingKeys: String, CodingKey {
            case dt, temp, pressure, humidity, dewPoint, uvi, clouds, visibility, weather, pop
            case feelsLike = "feels_like"
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
        }
    }

    struct DailyWeather: Decodable {
        var dt: Int?
        var sunrise: Int?
        var sunset: Int?
        var moonrise: Int?
        var moonset: Int?
        var moonPhase: Double?
        var temp: Temperature?
        var feelsLike: FeelsLike?
        var pressure: Int?
        var humidity: Int?
        var dewPoint: Double?
        var windSpeed: Double?
        var windDeg: Int?
        var windGust: Double?
        var weather: [Weather]?
        var clouds: Int?
        var pop: Double?
        var rain: Double?
        var uvi: Double?
        var summary: String?

        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, moonrise, moonset, temp, feelsLike, pressure, humidity, dewPoint, windSpeed, windDeg, windGust, weather, clouds, pop, rain, uvi, summary
            case moonPhase = "moon_phase"
        }

        struct Temperature: Decodable {
            var day: Double?
            var min: Double?
            var max: Double?
            var night: Double?
            var eve: Double?
            var morn: Double?
        }

        struct FeelsLike: Decodable {
            var day: Double?
            var night: Double?
            var eve: Double?
            var morn: Double?
        }
    }

    struct WeatherAlert: Decodable {
        var senderName: String?
        var event: String?
        var start: Int?
        var end: Int?
        var description: String?
        var tags: [String]?

        enum CodingKeys: String, CodingKey {
            case senderName = "sender_name"
            case event, start, end, description, tags
        }
    }

    struct Weather: Decodable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
}
