//
//  EditShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/20.
//

import UIKit

/// しおり予定編集画面
final class EditShioriPlanViewController: UIViewController {

    // MARK: - IBOutlets
    
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: UILabel!
    /// 旅行期間ラベル
    @IBOutlet private weak var dateRangeLabel: UILabel!
    /// 日数タイトルラベル
    @IBOutlet private weak var dayTitleLabel: UILabel!
    /// 日付ラベル
    @IBOutlet private weak var dayLabel: UILabel!
    /// 合計費用ラベル
    @IBOutlet private weak var totalCostLabel: UILabel!
    /// 合計費用ビュー
    @IBOutlet private weak var totalCostView: UIView!
    /// 予定一覧テーブルビュー
    @IBOutlet private weak var planTableView: UITableView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtonItems()
        setupLabels()
    }
    
    // MARK: - IBActions
    
    /// しおり編集ボタンをタップ
    @IBAction private func shioriEditButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Other Methods
    
    private func configureBarButtonItems() {
        // 閉じるボタン
        let closeButton = UIBarButtonItem(title: "×",
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        closeButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = closeButton
        
        // ナビゲーションバーの設定
        self.title = "しおりを編集"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 透過を無効
        appearance.backgroundColor = .white        // 背景色を白に
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.setFontZenMaruGothic(size: 15)]
        appearance.shadowColor = .black //バー下に黒ライン
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }
    
    /// 編集画面の閉じるボタンをタップ
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupLabels() {
        // 背景色
        view.backgroundColor = UIColor(hex: "F9D293")
        planTableView.backgroundColor = .clear
        totalCostView.layer.borderColor = UIColor.black.cgColor
        totalCostView.layer.borderWidth = 1.0
        
        // フォントを適用
        shioriNameLabel.font = .setFontZenMaruGothic(size: 32)
        dateRangeLabel.font = .setFontZenMaruGothic(size: 15)
        dayTitleLabel.font = .setFontZenMaruGothic(size: 24)
        dayLabel.font = .setFontZenMaruGothic(size: 18)
        totalCostLabel.font = .setFontZenMaruGothic(size: 13)
    }
}
