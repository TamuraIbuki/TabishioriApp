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
        return UIPageViewController(transitionStyle: .scroll,navigationOrientation: .horizontal,
                                    options: nil)
    }()
    
    private let pages: [UIViewController] = {
        let VC = UIViewController()
        VC.view.backgroundColor = UIColor(hex: "#FF9D00", alpha: 0.4)
        return [VC]
    }()
    
    private var currentIndex = 0
    
    // MARK: - IBOutlets
    
    /// 中央のビュー
    @IBOutlet private weak var containerView: UIView!
    /// フッタービュー
    @IBOutlet private weak var footerView: UIStackView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
    }
    
    private func configureBarButtonItems() {
        // 編集ボタン
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_edit"),style: .plain,target: self,action: #selector(editButtonTapped))
        editButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = editButton
        
        // 戻るボタン
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
            }
    
    /// 編集ボタンをタップ
    @objc func editButtonTapped() {
            }
    /// 戻るボタンをタップ
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension ShioriViewController: UIPageViewControllerDataSource {
    /// 右にスワイプ（戻る）した場合のメソッド
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    /// 左にスワイプ（進む）した場合のメソッド
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}
