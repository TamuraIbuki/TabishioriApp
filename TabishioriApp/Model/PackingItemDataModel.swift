//
//  PackingItemDataModel.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/09/09.
//

import Foundation
import RealmSwift

/// 持ち物アイテムのデータモデル
final class PackingItemDataModel: Object {
    @Persisted var name: String = ""
    @Persisted var isChecked: Bool = false
}
