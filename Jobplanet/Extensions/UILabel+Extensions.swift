//
//  UILabel+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = text else {
            return
        }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        attributedText = attrString
    }
}
