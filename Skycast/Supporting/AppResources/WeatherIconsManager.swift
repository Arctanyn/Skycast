//
//  WeatherIconsManager.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import Foundation

import UIKit
import Combine

//MARK: - DayTime

enum DayTime: Int {
    case day = 1
    case night = 0
}

//MARK: - WeatherIconManager

class WeatherIconManager {
    
    //MARK: Properties
    
    @Published private(set) var icon: UIImage?
    private let iconList = IconList()
    
    //MARK: - Methods
    
    func setIcon(code: Int, dayTime: DayTime) {
        let image = iconList.imageNames[code]?[dayTime]
        let renderedImage = image?.withRenderingMode(.alwaysOriginal)
        icon = renderedImage
    }
}

//MARK: - IconList

fileprivate struct IconList {
    private let weatherImages = Resources.Images.Weather.self
    
    var imageNames: [Int: [DayTime: UIImage]] {
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
