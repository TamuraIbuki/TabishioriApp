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
    
    // MARK: - Structs
    struct EditContext {
        let shioriName: String
        let dateRange: String
        let dayTitle: String
        let pageDate: Date
        let totalCost: String
        let backgroundHex: String
    }
    
    // MARK: - Stored Properties
    
    /// しおり名
    private let shioriName: String
    /// 旅行期間
    private let dateRange: String
    /// 日付タイトル
    private let dayTitle: String
    /// 日数
    let pageDate: Date
    /// 合計費用
    private let totalCost: String
    /// 背景色
    private var backgroundHex: String = ""
    /// 日毎の予定
    private var dailyPlans: [PlanDataModel] = []
    /// まだ保存されていない、追加途中の予定
    private var pendingPlans: [PlanDataModel]?
    /// 編集画面に渡す現ページ情報
    var editContext: EditContext {
        .init(shioriName: shioriName,
              dateRange: dateRange,
              dayTitle: dayTitle,
              pageDate: pageDate,
              totalCost: totalCost,
              backgroundHex: backgroundHex
        )
    }
    
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
    
    init(shioriName: String,
         dateRange: String,
         dayTitle: String,
         pageDate: Date,
         totalCost: String,
         backgroundHex: String) {
        self.shioriName = shioriName
        self.dateRange = dateRange
        self.dayTitle = dayTitle
        self.pageDate = pageDate
        self.totalCost = totalCost
        self.backgroundHex = backgroundHex
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
        
        // pendingPlans があれば反映
        if let plans = pendingPlans {
            updateUIWithPlans(plans)
            pendingPlans = nil
        }
    }
    
    // MARK: - Other Methods
    
    private func setupUI() {
        shioriNameLabel.text = shioriName
        dateRangeLabel.text = dateRange
        dayTitleLabel.text = dayTitle
        dayLabel.text = formattedDate(pageDate)
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
        
        // 背景色
        applyBackground(hex: backgroundHex)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
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
    
    private func updateUIWithPlans(_ plans: [PlanDataModel]) {
        self.dailyPlans = plans
        planTableView.reloadData()
    }
    
    private func normalizeHex(_ hex: String) -> String {
        var trimmedUppercasedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if !trimmedUppercasedHex.hasPrefix("#") { trimmedUppercasedHex = "#"+trimmedUppercasedHex }
        return trimmedUppercasedHex
    }
    
    private func applyBackground(hex: String) {
        let color = UIColor(hex: normalizeHex(hex))
        view.backgroundColor = color
    }
    
    // MARK: - Data Fetch
    
    func fetchAndDistributePlans() {
        guard isViewLoaded else {
            pendingPlans = fetchPlansForThisDay()
            return
        }
        updateUIWithPlans(fetchPlansForThisDay())
    }
    
    /// 予定を取得
    private func fetchPlansForThisDay() -> [PlanDataModel] {
        let results = RealmManager.shared.getObjects(PlanDataModel.self)
            .filter { Calendar.current.isDate($0.planDate, inSameDayAs: self.pageDate) }
        return Array(results)
    }
}

// MARK: - UITableViewDataSource

extension ShioriContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShioriPlanTableViewCellID",
            for: indexPath
        ) as? ShioriPlanTableViewCell else {
            return UITableViewCell()
        }
        
        let plan = dailyPlans[indexPath.row]
        let item = makeScheduleItem(from: plan)
        cell.configurePlan(with: item, isEditMode: false)
        cell.delegate = self
        return cell
    }
    
    private func makeScheduleItem(from plan: PlanDataModel) -> ShioriPlanTableViewCell.ScheduleItem {
        let trimmedURL = plan.planURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasURL = !trimmedURL.isEmpty
        let rawImage = plan.planImage?.trimmingCharacters(in: .whitespacesAndNewlines)
        let imageName: String? = (rawImage?.isEmpty == false) ? rawImage : nil
        
        return .init(
            startTime: plan.startTime,
            endTime: plan.endTime,
            plan: plan.planContent,
            isReserved: plan.planReservation,
            cost: plan.planCost,
            hasURL: hasURL,
            planImage: imageName
        )
    }
}

// MARK: - ShioriPlanTableViewCellDelegate

extension ShioriContentViewController: ShioriPlanTableViewCellDelegate {
    func didTapRightButton(in cell: ShioriPlanTableViewCell) {
        guard let indexPath = planTableView.indexPath(for: cell) else { return }
        
        let plan = dailyPlans[indexPath.row]
        let urlString = plan.planURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
    }
}
