//
//  StrokeLabel.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/09/26.
//

import UIKit

final class StrokeLabel: UILabel {
    var strokeColor: UIColor = .white
    var strokeWidth: CGFloat = 6.0

    override func drawText(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            super.drawText(in: rect)
            return
        }

        // ストローク
        context.setLineWidth(strokeWidth)
        context.setLineJoin(.round)
        context.setTextDrawingMode(.stroke)
        let originalColor = textColor
        textColor = strokeColor
        super.drawText(in: rect)

        // 塗り
        context.setTextDrawingMode(.fill)
        textColor = originalColor
        super.drawText(in: rect)
    }
}
