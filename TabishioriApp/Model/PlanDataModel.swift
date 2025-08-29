//
//  PlanDataModel.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/21.
//

import Foundation
import RealmSwift

/// 予定のデータモデル
final class PlanDataModel: Object {
    @Persisted var planDate: Date
    @Persisted var startTime: Date
    @Persisted var endTime: Date?
    @Persisted var planContent: String = ""
    @Persisted var planReservation: Bool = false
    @Persisted var planCost: Int = 0
    @Persisted var planURL: String = ""
    @Persisted var planImage: String?
}
