//
//  HomeTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/10.
//

import UIKit

/// Home画面のしおりセル
final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var shioriNameStrokeLabel: UILabel!
    @IBOutlet private weak var shioriNameFillLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(shioriName: String, shioriDate: String) {
        //dateLabel.text = shioridate
        let font = UIFont.setFontKiwiMaru(size: 24)
        
        // 日付ラベル処理
        let wrappedDate = shioriDate.replacingOccurrences(of: "~", with: "\n~")
        dateLabel.text = wrappedDate
        
        // 背景色
        contentView.backgroundColor = UIColor(hex: "#FF9D00", alpha: 0.3)
        
        // ストローク用
        let strokeAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .strokeColor: UIColor.white,
            .strokeWidth: 24.0,
            .foregroundColor: UIColor.clear
        ]
        shioriNameStrokeLabel.attributedText = NSAttributedString(string: shioriName, attributes: strokeAttributes)
        
        /// 塗り用（通常表示）
        shioriNameFillLabel.font = font
        shioriNameFillLabel.textColor = UIColor(hex: "#FF9D00")
        shioriNameFillLabel.text = shioriName
    }
}
