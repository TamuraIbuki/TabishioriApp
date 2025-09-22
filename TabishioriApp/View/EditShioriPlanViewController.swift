//
//  EditShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/20.
//

import UIKit
import RealmSwift

// MARK: - Protocols

protocol EditShioriPlanViewControllerDelegate: AnyObject {
    func didShioriUpdate(_ updated: ShioriDataModel)
    func didPlanUpdate(_ plan: PlanDataModel)
}

// MARK: - Main Type

/// しおり予定編集画面
final class EditShioriPlanViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// しおり名
    private let shioriName: String
    /// 旅行期間
    private let dateRange: String
    /// 日付タイトル
    private let dayTitle: String
    /// 日数
    private let pageDate: Date
    /// 合計費用
    private let totalCost: String
    /// 背景色
    private var backgroundHex: String = ""
    /// しおりのデータ
    private var dataModel: ShioriDataModel?
    /// 予定のデータ
    private var planDataModel: PlanDataModel?
    /// 日毎の予定
    private var dailyPlans: [PlanDataModel] = []
    /// RealmManagerのシングルトンインスタンスを取得
    private let realmManager = RealmManager.shared
    /// デリゲートのプロパティ
    weak var delegateToParent: EditShioriPlanViewControllerDelegate?
    
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
    
    // MARK: - Initializers
    
    init(dataModel: ShioriDataModel,
         shioriName: String,
         dateRange: String,
         dayTitle: String,
         pageDate: Date,
         totalCost: String,
         backgroundHex: String,
         planDataModel: PlanDataModel? = nil
    ) {
        self.dataModel = dataModel
        self.shioriName = shioriName
        self.dateRange = dateRange
        self.dayTitle = dayTitle
        self.pageDate = pageDate
        self.totalCost = totalCost
        self.backgroundHex = backgroundHex
        self.planDataModel = planDataModel
        super.init(nibName: "EditShioriPlanViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        configureTableView()
        fetchDailyPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShioriInformation()
        planTableView.reloadData()
    }
    
    // MARK: - IBActions
    
    /// しおり編集ボタンをタップ
    @IBAction private func shioriEditButtonTapped(_ sender: Any) {
        guard let model = dataModel else {
            return
        }
        let nextVC = EditShioriViewController(dataModel: model)
        nextVC.delegate = self
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
        
        shioriNameLabel.text = shioriName
        dateRangeLabel.text = dateRange
        dayTitleLabel.text = dayTitle
        dayLabel.text = formatterDate(pageDate)
        totalCostLabel.text = totalCost
        
        // 背景色
        view.backgroundColor = UIColor(hex: backgroundHex)
    }
    
    private func formatterDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }
    
    private func configureTableView() {
        planTableView.dataSource = self
        planTableView.delegate = self
        
        // カスタムセルを登録
        let nib = UINib(nibName: "ShioriPlanTableViewCell", bundle: nil)
        planTableView.register(nib, forCellReuseIdentifier: "ShioriPlanTableViewCellID")
        
        // テーブルビューの高さ設定
        planTableView.rowHeight = UITableView.automaticDimension
        planTableView.estimatedRowHeight = 100
    }
    
    /// 予定データを取得する
    private func fetchDailyPlans() {
        let results = realmManager.getObjects(PlanDataModel.self)
        self.dailyPlans = results
            .filter { Calendar.current.isDate($0.planDate, inSameDayAs: self.pageDate)}
            .sorted{ $0.startTime < $1.startTime }
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
                     planImage: imageName,
                     isChecked: plan.reservationIsChecked)
    }
    
    /// しおりの情報を更新する
    private func updateShioriInformation(_ model: ShioriDataModel? = nil) {
        let current = model ?? dataModel
        guard let current else { return }
        
        shioriNameLabel.text = current.shioriName
        dateRangeLabel.text  = "\(formatterDate(current.startDate))〜\(formatterDate(current.endDate))"
        totalCostLabel.text = "合計費用：¥\(dailyPlans.reduce(0) { $0 + $1.planCost })"
        view.backgroundColor = UIColor(hex: current.backgroundColor )
    }
}

// MARK: - Extentions

extension EditShioriPlanViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyPlans.count
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
        let plan = dailyPlans[indexPath.row]
        let item = makeScheduleItem(from: plan)
        cell.configurePlan(with: item, isEditMode: true)
        cell.delegate = self
        return cell
    }
}

/// セル横の編集ボタンをタップ
extension EditShioriPlanViewController: ShioriPlanTableViewCellDelegate {
    func didTapRightButton(in cell: ShioriPlanTableViewCell) {
        guard let indexPath = planTableView.indexPath(for: cell) else {
            return
        }
        let plan = dailyPlans[indexPath.row]
        navigateToEditShioriPlanDetail(plan: plan)
    }
    
    private func navigateToEditShioriPlanDetail(plan: PlanDataModel) {
        let nextVC = EditShioriPlanDetailViewController(planDataModel: plan)
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func planCell(_ cell: ShioriPlanTableViewCell, didToggleCheck isChecked: Bool) {
        // 編集画面ではチェックボックスボタンを表示しない
    }
}

extension EditShioriPlanViewController: EditShioriViewControllerDelegate {
    func didSaveNewShiori(_ updated: ShioriDataModel) {
        delegateToParent?.didShioriUpdate(updated)
    }
}

extension EditShioriPlanViewController: EditShioriPlanDetailViewControllerDelegate {
    func didSavePlan(_ plan: PlanDataModel) {
        fetchDailyPlans()
        planTableView.reloadData()
        
        delegateToParent?.didPlanUpdate(plan)
        
    }
}

extension EditShioriPlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [weak self] _, _, done in
            guard let self = self else { return }
            let plan = self.dailyPlans[indexPath.row]
            
            // Realm から削除
            self.realmManager.delete(
                plan,
                onSuccess: { [weak self] in
                    guard let self = self else { return }
                    // ローカル配列からも除去してテーブル更新
                    self.dailyPlans.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    if let visible = tableView.indexPathsForVisibleRows {
                        tableView.reloadRows(at: visible, with: .none)
                    }
                    done(true)
                    
                }, onFailure: { error in
                    print("Delete failed: \(error)")
                    done(false)
                })
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
