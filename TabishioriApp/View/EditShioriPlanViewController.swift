//
//  EditShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/20.
//

import UIKit

/// しおり予定編集画面
final class EditShioriPlanViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// しおり仮データ
    private var scheduleItem = ShioriDummyData.scheduleItems
    /// 編集モード
    private var isEditMode: Bool = true

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
        configureNavigationBar()
        setupUI()
        configureTableView()
    }
    
    // MARK: - IBActions
    
    /// しおり編集ボタンをタップ
    @IBAction private func shioriEditButtonTapped(_ sender: Any) {
        let nextVC = EditShioriViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Other Methods
    
    private func configureNavigationBar() {
        // 閉じるボタン
        let closeButton = UIBarButtonItem(image: UIImage(named: "ic_close"),
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
    
    private func setupUI() {
        // 枠線
        totalCostView.layer.borderColor = UIColor.black.cgColor
        totalCostView.layer.borderWidth = 1.0
        
        // フォントを適用
        shioriNameLabel.font = .setFontZenMaruGothic(size: 32)
        dateRangeLabel.font = .setFontZenMaruGothic(size: 15)
        dayTitleLabel.font = .setFontZenMaruGothic(size: 24)
        dayLabel.font = .setFontZenMaruGothic(size: 18)
        totalCostLabel.font = .setFontZenMaruGothic(size: 13)
    }
    
    private func configureTableView() {
        planTableView.dataSource = self
        // カスタムセルを登録
        let nib = UINib(nibName: "ShioriPlanTableViewCell", bundle: nil)
        planTableView.register(nib, forCellReuseIdentifier: "ShioriPlanTableViewCellID")
        
        // テーブルビューの高さ設定
        planTableView.rowHeight = UITableView.automaticDimension
        planTableView.estimatedRowHeight = 100
        }
}

// MARK: - Extentions

extension EditShioriPlanViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleItem.count
    }
    
    /// セルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを指定
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShioriPlanTableViewCellID",
                                                       for: indexPath)as? ShioriPlanTableViewCell
        else {
            return UITableViewCell()
        }
        
        // セルに渡す処理
        let item = scheduleItem[indexPath.row]
        cell.configurePlan(with: item, isEditMode: isEditMode)
        return cell
    }
}
