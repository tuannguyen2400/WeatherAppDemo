//
//  City.swift
//  MyWeatherAppDemo
//
//  Created by MT on 3/17/22.
//

import Foundation

struct cityRespones {
    let latitude: Float
    let longitude: Float
    let current_condition: currently
    let weatherDesc: WeatherDescInformation
    let weather : weatherDate
    let astronomy : astronomyInformation
    let hourly : HourlyWeatherInformation
    let climateAverages : climateAveragesInformation
}

struct currently: Codable {
    let observation_time : Int
    let temp_C : Int
    let weatherCode : Int
}

struct WeatherDescInformation: Codable {
    let windspeedMiles : Int
    let windspeedKmph : Int
    let winddirDegree : Int
    let winddir16Point : String
    let precipMM : Float
    let precipInches : Float
    let humidity: Int
    let visibility : Int
    let visibilityMiles : Int
    let pressure : Int
    let pressureInches : Int
    let cloudcover : Int
    let HeatIndexC : Int
    let HeatIndexF : Int
    let DewPointC : Int
    let DewPointF : Int
    let WindChillC : Int
    let WindChillF : Int
    let WindGustMiles : Int
    let WindGustKmph : Int
    let FeelsLikeC : Int
    let FeelsLikeF : Int
    let chanceofrain : Int
    let chanceofremdry : Int
    let chanceofwindy : Int
    let chanceofovercast : Float
    let chanceofsunshine : Int
    let chanceoffrost : Float
    let chanceofhightemp : Float
    let chanceoffog : Float
    let chanceofsnow : Float
    let chanceofthunder : Float
    let uvIndex : Int
}

struct weatherDate: Codable {
    let weather : Int
}

struct astronomyInformation: Codable {
    let sunrise : String
    let sunset : String
    let moonrise : String
    let moonset : String
    let moon_phase : String
    let moon_illumination : String
    let maxtempC : Int
    let maxtempF : Int
    let mintempC : Int
    let mintempF : Int
    let avgtempC : Int
    let avgtempF : Int
    let totalSnow_cm : Float
    let sunHour : Double
    let uvIndex : Int
}

struct HourlyWeatherInformation: Codable {
    let time : Int
    let tempC : Int
    let tempF : Int
    let windspeedMiles : Int
    let windspeedKmph : Int
    let winddirDegree : Int
    let winddir16Point : String
    let weatherCode : Int
    
}
struct climateAveragesInformation: Codable {
    let index : Int
    let name : String
    let avgMinTemp : Double
    let avgMinTemp_F : Double
    let absMaxTemp: Double
    let absMaxTemp_F : Double
    let avgDailyRainfall : Double
}
