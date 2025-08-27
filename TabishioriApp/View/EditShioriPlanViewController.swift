//
//  EditShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/20.
//

import UIKit
import RealmSwift

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
    /// RealmManagerのシングルトンインスタンスを取得
    private let realmManager = RealmManager.shared
    /// 取得したデータの格納先
    private var data: Results<PlanDataModel>?
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        configureTableView()
        fetchData()
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
    
    /// 予定データを取得する
    private func fetchData() {
        let results = realmManager.getObjects(PlanDataModel.self)
        data = results
        planTableView.reloadData()
    }
    
    /// データモデルをCellに渡せる形にする
    private func makeScheduleItem(from plan: PlanDataModel) -> ShioriPlanTableViewCell.ScheduleItem {
        let trimmedURL = plan.planURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasURL = !trimmedURL.isEmpty
        let rawImage = plan.planImage?.trimmingCharacters(in: .whitespacesAndNewlines)
        let imageName: String? = (rawImage?.isEmpty == false) ? rawImage : nil

        
        return .init(startTime: plan.startTime,
                     endTime: plan.endTime,
                     plan: plan.planContent,
                     isReserved: plan.planReservation,
                     cost: plan.planCost,
                     hasURL: hasURL,
                     planImage: imageName)
    }
}

// MARK: - Extentions

extension EditShioriPlanViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    /// セルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを指定
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShioriPlanTableViewCellID",
                                                       for: indexPath)as? ShioriPlanTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        // セルに渡す処理
        if let item = data?[indexPath.row] {
            let item = makeScheduleItem(from: item)
            cell.configurePlan(with: item, isEditMode: true)
        }
        return cell
    }
}

/// セル横の編集ボタンをタップ
extension EditShioriPlanViewController: ShioriPlanTableViewCellDelegate {
    func didTapRightButton(in cell: ShioriPlanTableViewCell) {
        navigateToEditShioriPlanDetail()
        }
    
    private func navigateToEditShioriPlanDetail() {
        let nextVC = EditShioriPlanDetailViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
