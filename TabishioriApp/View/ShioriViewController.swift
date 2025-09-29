//
//  ShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/16.
//

import UIKit
import PhotosUI

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
    /// 選択した画像
    private var selectedImages: [UIImage] = []

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
        let hex = normalizeHex(selectedShiori?.backgroundColor ?? "#FFFFFF")
        let nextVC = PackingListViewController(backgroundHex: hex)
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
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0 // 複数可
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
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
              let shiori = selectedShiori else {
            return
        }
        
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
    
    /// 色コードをそろえる
    private func normalizeHex(_ hex: String) -> String {
        var trimmedUppercasedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if !trimmedUppercasedHex.hasPrefix("#") { trimmedUppercasedHex = "#"+trimmedUppercasedHex }
        return trimmedUppercasedHex
    }

    /// PDFを作成
    private func createPDF(from images: [UIImage]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "MyApp",
            kCGPDFContextAuthor: "Me"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageSize = images.first?.size ?? CGSize(width: 595, height: 842) // A4 fallback
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)

        let data = renderer.pdfData { ctx in
            for image in images {
                ctx.beginPage()
                let aspectWidth = pageSize.width / image.size.width
                let aspectHeight = pageSize.height / image.size.height
                let aspectRatio = min(aspectWidth, aspectHeight)
                let scaledSize = CGSize(width: image.size.width * aspectRatio,
                                        height: image.size.height * aspectRatio)
                let origin = CGPoint(x: (pageSize.width - scaledSize.width) / 2,
                                     y: (pageSize.height - scaledSize.height) / 2)
                image.draw(in: CGRect(origin: origin, size: scaledSize))
            }
        }
        return data
    }

    private func saveToFiles(data: Data) {
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent("images.pdf")
        do {
            try data.write(to: tmpURL)

            // ファイルアプリに保存できるように Document Picker を開く
            let picker = UIDocumentPickerViewController(forExporting: [tmpURL])
            picker.delegate = self
            present(picker, animated: true)

        } catch {
            print("PDF保存エラー: \(error)")
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

// MARK: - EditShioriPlanViewControllerDelegate

extension ShioriViewController: EditShioriPlanViewControllerDelegate {
    /// しおりの情報を更新
    func didShioriUpdate(_ updated: ShioriDataModel) {
        let currentDisplayedDate
        = (pageViewController.viewControllers?.first as? ShioriContentViewController)?.pageDate
        
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
    
    /// 予定の情報を更新
    func didPlanUpdate(_ updated: PlanDataModel) {
        let targetDate = updated.planDate
        let cal = Calendar.current
        for page in pages {
            if let content = page as? ShioriContentViewController,
               cal.isDate(content.pageDate, inSameDayAs: targetDate) {
                content.fetchAndDistributePlans()
                break
            }
        }
    }

    /// 予定の削除後更新
    func didPlanDelete(_ vc: EditShioriPlanViewController, for date: Date?) {
        guard let date else { return updateAllPagesWithPlans() }
        let cal = Calendar.current
            (pages.first {
                guard let p = $0 as? ShioriContentViewController else { return false }
                return cal.isDate(p.pageDate, inSameDayAs: date)
            } as? ShioriContentViewController)?
                .fetchAndDistributePlans()
}
}


// MARK: - PHPicker Delegate

extension ShioriViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            // 画像が選択されていなかったら何もしない
            guard !results.isEmpty else {
                return
            }
            
            // 選択した画像をまとめてPDF化する
            let itemProviders = results.map(\.itemProvider)
            var loadedImages: [UIImage] = []
            let group = DispatchGroup()
            
            for item in itemProviders {
                if item.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    item.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let image = object as? UIImage {
                            loadedImages.append(image)
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                let pdfData = self.createPDF(from: loadedImages)
                self.saveToFiles(data: pdfData)
            }
        }
    }
}

// MARK: - UIDocumentPicker Delegate

extension ShioriViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("キャンセルされました")
    }
}
