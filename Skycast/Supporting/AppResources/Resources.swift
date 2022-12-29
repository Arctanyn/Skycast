//
//  Resources.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

enum Resources {
    
    //MARK: Colors
    
    enum Colors {
        static var secondaryBackground: UIColor { UIColor(named: "secondary_background")! }
        static var background: UIColor { UIColor(named: "background")! }
        static var title: UIColor { .tertiaryLabel.withAlphaComponent(0.8) }
        static var darkText: UIColor { .tertiaryLabel.withAlphaComponent(1) }
        static var blue: UIColor { .systemBlue }
    }
    
    //MARK: - Images
    
    enum Images {
        static var location: UIImage {
            UIImage(systemName: "location.fill")!
        }
        
        //MARK: - Weather
        
        enum Weather {
            static var sun: UIImage {
                UIImage(systemName: "sun.max.fill")!
            }
            static var moon: UIImage {
                UIImage(systemName: "moon.fill")!
            }
            
            static var cloudSun: UIImage {
                UIImage(systemName: "cloud.sun.fill")!
            }
            
            static var cloudMoon: UIImage {
                UIImage(systemName: "cloud.moon.fill")!
            }
            
            static var cloud: UIImage {
                UIImage(systemName: "cloud.fill")!
            }
            
            static var fog: UIImage {
                UIImage(systemName: "cloud.fog.fill")!
            }
            
            static var cloudSunRain: UIImage {
                UIImage(systemName: "cloud.sun.rain.fill")!
            }
            
            static var cloudMoonRain: UIImage {
                UIImage(systemName: "cloud.moon.rain.fill")!
            }
            
            static var cloudSnow: UIImage {
                UIImage(systemName: "cloud.snow.fill")!
            }
            
            static var cloudSleet: UIImage {
                UIImage(systemName: "cloud.sleet.fill")!
            }
            
            static var cloudDrizzle: UIImage {
                UIImage(systemName: "cloud.drizzle.fill")!
            }
            
            static var cloudSunBolt: UIImage {
                UIImage(systemName: "cloud.sun.bolt.fill")!
            }
            
            static var cloudMoonBolt: UIImage {
                UIImage(systemName: "cloud.moon.bolt.fill")!
            }
            
            static var windSnow: UIImage {
                UIImage(systemName: "wind.snow")!
            }
            
            static var cloudHeavyRain: UIImage {
                UIImage(systemName: "cloud.heavyrain.fill")!
            }
            
            static var snowflake: UIImage {
                UIImage(systemName: "snowflake")!
            }
            
            static var cloudHail: UIImage {
                UIImage(systemName: "cloud.hail.fill")!
            }
            
            static var cloudBoldRain: UIImage {
                UIImage(systemName: "cloud.bolt.rain.fill")!
            }
            
            static var wind: UIImage {
                UIImage(systemName: "wind")!
            }
            
            static var drop: UIImage {
                UIImage(systemName: "drop.fill")!
            }
            
            static var dropDegreesign: UIImage {
                UIImage(systemName: "drop.degreesign.fill")!
            }
            
            static var arrowDownUp: UIImage {
                UIImage(systemName: "arrow.down.and.line.horizontal.and.arrow.up")!
            }
            
            static var eye: UIImage {
                UIImage(systemName: "eye")!
            }
            
            static func weatherIcon(code: Int, dayPriod: DayPeriod) -> UIImage? {
                let weatherIconManger = WeatherIconManager()
                return weatherIconManger.getIcon(code: code, dayPeriod: dayPriod)
            }
        }
        
        //MARK: - TabBar
        
        enum TabBar {
            case forecast
            case myLocations
            
            var icon: UIImage {
                switch self {
                case .forecast:
                    return UIImage(systemName: "cloud.sun")!
                case .myLocations:
                    return UIImage(systemName: "list.bullet.indent")!
                }
            }
            
            var selectedIcon: UIImage {
                switch self {
                case .forecast:
                    return UIImage(systemName: "cloud.sun.fill")!
                case .myLocations:
                    return icon
                }
            }
        }
    }
    
    //MARK: - Strings
    
    enum Strings {
        
        static var appName: String { "Skycast" }
        static var currentWeatherTitle: String { "RIGHT NOW" }
        
        //MARK: - TabBar
        
        enum TabBar {
            static var forecast: String { "Forecast" }
            static var myLocations: String { "My Locations" }
        }
    }
    
    //MARK: - Fonts
    
    enum Fonts {
        static func system(size: CGFloat = 17, weight: UIFont.Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }
    }
}

//MARK: - WeatherIconManager

fileprivate struct WeatherIconManager {
    
    //MARK: Properties
    
    private let iconList = IconList()
    
    //MARK: - Methods
    
    func getIcon(code: Int, dayPeriod: DayPeriod) -> UIImage? {
        let image = iconList.imageNames[code]?[dayPeriod]
        let renderedImage = image?.withRenderingMode(.alwaysOriginal)
        return renderedImage
    }
}

//MARK: - IconList

fileprivate struct IconList {
    private let weatherImages = Resources.Images.Weather.self
    
    var imageNames: [Int: [DayPeriod: UIImage]] {
        [
            1000: [.day: weatherImages.sun, .night: weatherImages.moon],
            1003: [.day: weatherImages.cloudSun, .night: weatherImages.cloudMoon],
            1006: [.day: weatherImages.cloud, .night: weatherImages.cloud],
            1009: [.day: weatherImages.cloud, .night: weatherImages.cloud],
            1030: [.day: weatherImages.fog, .night: weatherImages.fog],
            1063: [.day: weatherImages.cloudSunRain, .night: weatherImages.cloudMoonRain],
            1066: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1069: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1072: [ .day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1087: [.day: weatherImages.cloudSunBolt, .night: weatherImages.cloudMoonBolt],
            1114: [.day: weatherImages.windSnow, .night: weatherImages.windSnow],
            1117: [.day: weatherImages.windSnow, .night: weatherImages.windSnow],
            1135: [.day: weatherImages.fog, .night: weatherImages.fog],
            1147: [.day: weatherImages.fog, .night: weatherImages.fog],
            1150: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1153: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1168: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1171: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1180: [.day: weatherImages.cloudSunRain, .night: weatherImages.cloudMoonRain],
            1183: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1186: [.day: weatherImages.cloudDrizzle, .night: weatherImages.cloudDrizzle],
            1189: [.day: weatherImages.cloudHeavyRain, .night: weatherImages.cloudHeavyRain],
            1192: [.day: weatherImages.cloudHeavyRain, .night: weatherImages.cloudHeavyRain],
            1195: [.day: weatherImages.cloudHeavyRain, .night: weatherImages.cloudHeavyRain],
            1198: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1201: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1204: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1207: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1210: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1213: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1216: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1219: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1222: [.day: weatherImages.snowflake, .night: weatherImages.snowflake],
            1225: [.day: weatherImages.snowflake, .night: weatherImages.snowflake],
            1237: [.day: weatherImages.cloudHail, .night: weatherImages.cloudHail],
            1240: [.day: weatherImages.cloudSunRain, .night: weatherImages.cloudMoonRain],
            1243: [.day: weatherImages.cloudHeavyRain, .night: weatherImages.cloudHeavyRain],
            1246: [.day: weatherImages.cloudHeavyRain, .night: weatherImages.cloudHeavyRain],
            1249: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1252: [.day: weatherImages.cloudSleet, .night: weatherImages.cloudSleet],
            1255: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1258: [.day: weatherImages.snowflake, .night: weatherImages.snowflake],
            1261: [.day: weatherImages.cloudHail, .night: weatherImages.cloudHail],
            1264: [.day: weatherImages.cloudHail, .night: weatherImages.cloudHail],
            1273: [.day: weatherImages.cloudBoldRain, .night: weatherImages.cloudBoldRain],
            1276: [.day: weatherImages.cloudBoldRain, .night: weatherImages.cloudBoldRain],
            1279: [.day: weatherImages.cloudSnow, .night: weatherImages.cloudSnow],
            1282: [.day: weatherImages.snowflake, .night: weatherImages.snowflake]
        ]
    }
}
