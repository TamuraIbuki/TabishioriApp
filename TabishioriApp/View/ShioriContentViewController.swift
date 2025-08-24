//
//  ShioriContentViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/19.
//

import UIKit
import RealmSwift

/// しおりの中身の画面
final class ShioriContentViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// しおり名ラベル
    private let shioriName: String
    /// 旅行期間ラベル
    private let dateRange: String
    /// 日付タイトルラベル
    private let dayTitle: String
    /// 日数ラベル
    private let day: String
    /// 合計費用ラベル
    private let totalCost: String
    /// RealmManagerのシングルトンインスタンスを取得
    private let realmManager = RealmManager.shared
    /// 取得したデータの格納先
    private var data: Results<PlanDataModel>?
    
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
    /// 合計費用ビュー
    @IBOutlet private weak var totalCostView: UIView!
    /// 予定一覧テーブルビュー
    @IBOutlet private weak var planTableView: UITableView!
    
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
        setupUI()
        configureTableView()
        fetchData()
    }
    
    // MARK: - Other Methods
    
    private func setupUI() {
        shioriNameLabel.text = shioriName
        dateRangeLabel.text = dateRange
        dayTitleLabel.text = dayTitle
        dayLabel.text = day
        totalCostLabel.text = totalCost
        
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
    
    func configureTableView() {
        planTableView.dataSource = self
        // カスタムセルを登録
        let nib = UINib(nibName: "ShioriPlanTableViewCell", bundle: nil)
        planTableView.register(nib, forCellReuseIdentifier: "ShioriPlanTableViewCellID")
        
        // テーブルビューの高さ設定
        planTableView.rowHeight = UITableView.automaticDimension
        planTableView.estimatedRowHeight = 100
    }
    
    /// 予定データを取得する
    func fetchData() {
        let results = realmManager.getObjects(PlanDataModel.self)
        data = results.sorted(byKeyPath: "startTime", ascending: true)
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
    
    extension ShioriContentViewController: UITableViewDataSource {
        /// セルの数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data?.count ?? 0
        }
        
        /// セルを設定
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // カスタムセルを指定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShioriPlanTableViewCellID",
                                                           for: indexPath) as? ShioriPlanTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            // セルに渡す処理
            if let item = data?[indexPath.row] {
                let item = makeScheduleItem(from: item)
                cell.configurePlan(with: item, isEditMode: false)
            }
            return cell
        }
    }
    
    extension ShioriContentViewController: ShioriPlanTableViewCellDelegate {
        func didTapRightButton(in cell: ShioriPlanTableViewCell) {
            if let indexPath = planTableView.indexPath(for: cell),
               let urlString = data?[indexPath.row].planURL,
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                UIApplication.shared.open(url)
                }
            }
        }
