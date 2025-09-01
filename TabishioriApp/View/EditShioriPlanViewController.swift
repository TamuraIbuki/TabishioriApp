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
    func didShioriupdate(_ updated: ShioriDataModel)
}

// MARK: - Main Type

/// しおり予定編集画面
final class EditShioriPlanViewController: UIViewController {
    
    // MARK: - Properties
    
    /// しおりのデータ
    private var dataModel: ShioriDataModel!
    
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
         totalCost: String) {
        self.dataModel = dataModel
        self.shioriName = shioriName
        self.dateRange = dateRange
        self.dayTitle = dayTitle
        self.pageDate = pageDate
        self.totalCost = totalCost
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
        let nextVC = EditShioriViewController(dataModel: dataModel)
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
        delegateToParent?.didShioriupdate(dataModel)
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
    }
    
    private func formatterDate(_ date: Date) -> String {
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
    
    /// 予定データを取得する
    private func fetchDailyPlans() {
        let results = realmManager.getObjects(PlanDataModel.self)
        self.dailyPlans = results.filter { Calendar.current.isDate($0.planDate, inSameDayAs: self.pageDate)}
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
    
    /// しおり情報の変更箇所の確認
    private func hasShioriMetaChanged(old: ShioriDataModel, new: ShioriDataModel) -> Bool {
        let calendar = Calendar.current
        let nameChanged = old.shioriName != new.shioriName
        let startChanged = !calendar.isDate(old.startDate, inSameDayAs: new.startDate)
        let endChanged   = !calendar.isDate(old.endDate, inSameDayAs: new.endDate)
        let colorChanged = old.backgroundColor != new.backgroundColor
        return nameChanged || startChanged || endChanged || colorChanged
    }
    
    /// しおりの情報を更新する
    private func updateShioriInformation(_ model: ShioriDataModel? = nil) {
        let current = model ?? dataModel
        guard let current else { return }
        
        shioriNameLabel.text = current.shioriName
        dateRangeLabel.text  = "\(formatterDate(current.startDate))〜\(formatterDate(current.endDate))"
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
        navigateToEditShioriPlanDetail()
        }
    
    private func navigateToEditShioriPlanDetail() {
        let nextVC = EditShioriPlanDetailViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension EditShioriPlanViewController: EditShioriViewControllerDelegate {
    func didSaveNewShiori(_ updated: ShioriDataModel) {
        if hasShioriMetaChanged(old: dataModel, new: updated) {
            // 何か1つでも変わっていたら更新処理
            self.dataModel = updated
            updateShioriInformation(updated)
        }
        navigationController?.popViewController(animated: true)
    }
}
