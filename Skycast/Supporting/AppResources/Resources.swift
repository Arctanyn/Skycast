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
        }

    }
    
    //MARK: - Strings
    
    enum Strings {
        static var appName: String { "Skycast" }
        static var currentWeatherTitle: String { "RIGHT NOW" }
        
    }
    
    //MARK: - Fonts
    
    enum Fonts {
        static func system(size: CGFloat = 17, weight: UIFont.Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }
    }
}

