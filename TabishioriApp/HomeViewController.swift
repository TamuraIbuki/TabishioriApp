//
//  HomeViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/01.
//

import UIKit

/// Home画面
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var homeTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
    }
    
    // MARK: - IBActions
    
    //新しいしおりを作成ボタンをタップ
    @IBAction func didTapCreateButton(_ sender: Any) {
    }
    
    // MARK: - Other Methods
    private func setupFont() {
        //タイトルのフォントを変更
        if let homeTitle = self.homeTitle {
            homeTitle.font = .zenMaruGothic(size: 32)
        } else {
            print("homeTitle is nil")
        }
        
        //新しいしおり作成ボタンのフォントを変更
        if let createButton = self.createButton {
            let title = "新しいしおりを作成"
            let font = UIFont.zenMaruGothic(size: 18)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            createButton.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            print("createButton is nil")
        }
    }
}
