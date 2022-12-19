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
        static var background: UIColor { .tertiarySystemBackground }
        static var secondaryBackground: UIColor { .secondarySystemBackground }
        static var title: UIColor { .tertiaryLabel.withAlphaComponent(0.8) }
        static var darkText: UIColor { .tertiaryLabel.withAlphaComponent(1) }
        static var blue: UIColor { .systemBlue }
    }
    
    //MARK: - Images
    
    enum Images {
        static var wind: UIImage { UIImage(systemName: "wind")! }
        static var drop: UIImage { UIImage(systemName: "drop.fill")! }
        static var dropDegreesign: UIImage { UIImage(systemName: "drop.degreesign.fill")! }
        static var arrowDownUp: UIImage { UIImage(systemName: "arrow.down.and.line.horizontal.and.arrow.up")! }
        static var eye: UIImage { UIImage(systemName: "eye")! }
    }
    
    //MARK: - Strings
    
    enum Strings {
        static var appName: String { "Skycast" }
        static var currentWeatherTitle: String { "RIGHT NOW" }
        
    }
    
    //MARK: - Fonts
    
    enum Fonts {
        static func system(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }
    }
}

