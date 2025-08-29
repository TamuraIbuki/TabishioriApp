//
//  ShioriDataModel.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/15.
//

import Foundation
import RealmSwift

/// しおりデータのモデル
final class ShioriDataModel: Object {
    @Persisted var shioriName: String = UUID().uuidString
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var backgroundColor: String = ""
    @Persisted var dailyPlans = List<PlanDataModel>()
}
