//
//  ShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/16.
//

import UIKit

/// しおり画面
final class ShioriViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// 表示するページ一覧
    private var pages: [UIViewController] = []
    /// 現在表示しているページのインデックス
    private var currentIndex = 0
    /// 取得したデータの格納先
    private var dailyPlans: [PlanDataModel] = []
    /// 選択したしおりデータ
    var selectedShiori: ShioriDataModel?
    
    // MARK: - Computed Properties
    
    /// ページ管理用の UIPageViewController
    private let pageViewController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll,
                                    navigationOrientation: .horizontal,
                                    options: nil)
    }()
    
    // MARK: - IBOutlets
    
    /// 中央のビュー
    @IBOutlet private weak var containerView: UIView!
    /// フッタービュー
    @IBOutlet private weak var footerView: UIStackView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let shiori = selectedShiori else { return }
        configurePages(shiori: shiori)
        setupPageViewController()
        configureBarButtonItems()
        updateAllPagesWithPlans()
    }
    
    // MARK: - IBActions
    
    /// 持ち物リストボタンをタップ
    @IBAction private func luggageButtonTapped(_ sender: UIButton) {
        let nextVC = PackingListViewController()
        let navi = UINavigationController(rootViewController: nextVC)
        navigationController?.present(navi, animated: true)
    }
    
    /// 予定追加ボタンをタップ
    @IBAction private func addPlanButtonTapped(_ sender: UIButton) {
        // 現在のページ
        guard let currentVC = pageViewController.viewControllers?.first as? ShioriContentViewController else {
            return
        }
        // 新しい予定作成画面へ遷移
        let nextVC = CreateShioriPlanViewController()
        nextVC.delegate = self
        nextVC.preselectedDate = currentVC.pageDate
        let navi = UINavigationController(rootViewController: nextVC)
        self.present(navi, animated: true)
    }
    
    /// PDFボタンをタップ
    @IBAction private func pdfButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Other Methods
    
    private func setupPageViewController() {
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)
        
        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
        }
        pageViewController.dataSource = self
    }
    
    private func configureBarButtonItems() {
        // 編集ボタン
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_edit"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(editButtonTapped))
        editButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = editButton
        
        // 戻るボタン
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_left_arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    /// 編集ボタンをタップ
    @objc func editButtonTapped() {
        guard let currentVC = pageViewController.viewControllers?.first as? ShioriContentViewController,
              let shiori = selectedShiori
        else { return }
        
        let currentContext = currentVC.editContext
        let editVC = EditShioriPlanViewController(
            dataModel: shiori,
            shioriName: currentContext.shioriName,
            dateRange: currentContext.dateRange,
            dayTitle: currentContext.dayTitle,
            pageDate: currentContext.pageDate,
            totalCost: currentContext.totalCost,
            backgroundHex: currentContext.backgroundHex
        )
        editVC.delegateToParent = self
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true, completion: nil)
    }
    
    /// 戻るボタンをタップ
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 日毎のページを作成
    private func configurePages(shiori: ShioriDataModel) {
        pages = []
        let calendar = Calendar.current
        var date = shiori.startDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        
        let backgroundHex = shiori.backgroundColor
        
        while date <= shiori.endDate {
            let dayNumber = calendar.dateComponents([.day], from: shiori.startDate, to: date).day! + 1
            let dayTitle = "〜\(dayNumber)日目〜"
            
            let dailyPlans = shiori.dailyPlans.filter { plan in
                calendar.isDate(plan.planDate, inSameDayAs: date)
            }
            let totalCost = "合計費用：¥\(dailyPlans.reduce(0) { $0 + $1.planCost })"
            
            let page = ShioriContentViewController(
                shioriName: shiori.shioriName,
                dateRange: "\(formatter.string(from: shiori.startDate))〜\(formatter.string(from: shiori.endDate))",
                dayTitle: dayTitle,
                pageDate: date,
                totalCost: totalCost,
                backgroundHex: backgroundHex
            )
            
            pages.append(page)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }
    
    /// 各ページに日付ごとの予定を取得して更新させる
    private func updateAllPagesWithPlans() {
        for page in pages {
            if let contentVC = page as? ShioriContentViewController {
                contentVC.fetchAndDistributePlans()
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ShioriViewController: UIPageViewControllerDataSource {
    /// 右にスワイプ（戻る）した場合のメソッド
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    /// 左にスワイプ（進む）した場合のメソッド
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: - CreateShioriPlanViewControllerDelegate

extension ShioriViewController: CreateShioriPlanViewControllerDelegate {
    /// 予定追加画面で登録後に画面を更新
    func didSaveNewPlan(for date: Date) {
        let calendar = Calendar.current
        for page in pages {
            if let contentVC = page as? ShioriContentViewController,
               calendar.isDate(contentVC.pageDate, inSameDayAs: date) {
                contentVC.fetchAndDistributePlans()
                break
            }
        }
    }
}

extension ShioriViewController: EditShioriPlanViewControllerDelegate {
    /// しおりの情報を更新
    func didShioriupdate(_ updated: ShioriDataModel) {
        let currentDisplayedDate = (pageViewController.viewControllers?.first as? ShioriContentViewController)?.pageDate
        
        selectedShiori = updated
        configurePages(shiori: updated)
        let targetIndex: Int = {
            guard let currentDate = currentDisplayedDate else { return 0 }
            let calendar = Calendar.current
            return pages.firstIndex {
                guard let contentViewController = $0 as? ShioriContentViewController else { return false }
                return calendar.isDate(contentViewController.pageDate, inSameDayAs: currentDate)
            } ?? 0
        }()
        
        pageViewController.setViewControllers([pages[targetIndex]], direction: .forward, animated: false)
        updateAllPagesWithPlans()
    }
}
