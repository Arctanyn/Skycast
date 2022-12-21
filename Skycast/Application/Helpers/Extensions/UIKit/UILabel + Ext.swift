//
//  UILabel + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import UIKit

extension UILabel {
    enum TextSide {
        case left
        case right
    }
    
    convenience init(text: String? = nil,
                     textColor: UIColor? = .label,
                     font: UIFont? = .systemFont(ofSize: 17),
                     alignment: NSTextAlignment = .natural, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    func addImage(_ image: UIImage, size imageSize: CGFloat, to side: TextSide) {
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        let text = ""
        
        switch side {
        case .left:
            let attachmentString = NSMutableAttributedString(attachment: attachment)
            let string = NSMutableAttributedString(string: text, attributes: [:])
            attachmentString.append(string)
            self.attributedText = attachmentString
        case .right:
            let attachmentString = NSAttributedString(attachment: attachment)
            let string = NSMutableAttributedString(string: text, attributes: [:])
            string.append(attachmentString)
            self.attributedText = string
        }
    }
}
