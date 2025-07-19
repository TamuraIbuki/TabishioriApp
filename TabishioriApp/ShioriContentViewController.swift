//
//  ShioriContentViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/19.
//

import UIKit

/// しおりの中身の画面
final class ShioriContentViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: UILabel!
    /// 旅行期間ラベル
    @IBOutlet private weak var dateRangeLabel: UILabel!
    /// 日付タイトルラベル
    @IBOutlet private weak var dayTitleLabel: UILabel!
    /// 日数ラベル
    @IBOutlet private weak var dayLabel: UILabel!
    /// 合計費用ラベル
    @IBOutlet private weak var totalCostLabel: UILabel!
    
    // MARK: - Stored Properties
    
    private let shioriName: String
    private let dateRange: String
    private let dayTitle: String
    private let day: String
    private let totalCost: String
    
    // MARK: - Initializers
    
    init(shioriName: String, dateRange: String, dayTitle: String, day: String, totalCost: String) {
        self.shioriName = shioriName
        self.dateRange = dateRange
        self.dayTitle = dayTitle
        self.day = day
        self.totalCost = totalCost
        super.init(nibName: "ShioriContentViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    // MARK: - Other Methods
    
    private func setupLabels() {
        shioriNameLabel.text = shioriName
        dateRangeLabel.text = dateRange
        dayTitleLabel.text = dayTitle
        dayLabel.text = day
        totalCostLabel.text = totalCost
        view.backgroundColor = UIColor(hex: "#FF9D00", alpha: 0.4)
        
        // フォントを適用
        shioriNameLabel.font = .setFontZenMaruGothic(size: 32)
        dateRangeLabel.font = .setFontZenMaruGothic(size: 15)
        dayTitleLabel.font = .setFontZenMaruGothic(size: 24)
        dayLabel.font = .setFontZenMaruGothic(size: 18)
        totalCostLabel.font = .setFontZenMaruGothic(size: 13)
    }
}
