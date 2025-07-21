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
    
    private let pageViewController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll,
                                    navigationOrientation: .horizontal,
                                    options: nil)
    }()
    
    private var pages: [UIViewController] = []
    private var currentIndex = 0
    
    struct ShioriPageData {
        let dayTitle: String
        let day: String
    }
    
    // しおり仮データ
    let commonShioriName = "マレーシア旅行"
    let commonDateRange = "2025.6.23〜2025.6.28"
    let commonTotalCost = "合計費用：¥120,000"
   
    // MARK: - IBOutlets
    
    /// 中央のビュー
    @IBOutlet private weak var containerView: UIView!
    /// フッタービュー
    @IBOutlet private weak var footerView: UIStackView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePages()
        setupPageViewController()
        configureBarButtonItems()
    }
    
    // MARK: - IBActions
    
    /// 持ち物リストボタンをタップ
    @IBAction private func luggageButtonTapped(_ sender: UIButton) {
    }
    
    /// 予定追加ボタンをタップ
    @IBAction private func addPlanButtonTapped(_ sender: UIButton) {
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
        
        pageViewController.setViewControllers([pages[0]],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
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
        let editVC = EditShioriPlanViewController()
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true, completion: nil)
    }
    
    /// 戻るボタンをタップ
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 日付仮データ
    private func configurePages() {
        let pagesDataList: [ShioriPageData] = [
            ShioriPageData(dayTitle: "～1日目～", day: "6月23日"),
            ShioriPageData(dayTitle: "～2日目～", day: "6月24日"),
            ShioriPageData(dayTitle: "～3日目～", day: "6月25日")
        ]

        // データを格納
        self.pages = pagesDataList.map { data in
            makeContentVC(
                shioriName: commonShioriName,
                dateRange: commonDateRange,
                dayTitle: data.dayTitle,
                day: data.day,
                totalCost: commonTotalCost
            )
        }
    }
    
    private func makeContentVC(
        shioriName: String,
        dateRange: String,
        dayTitle: String,
        day: String,
        totalCost: String
    ) -> ShioriContentViewController {
        return ShioriContentViewController(
            shioriName: shioriName,
            dateRange: dateRange,
            dayTitle: dayTitle,
            day: day,
            totalCost: totalCost
        )
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
