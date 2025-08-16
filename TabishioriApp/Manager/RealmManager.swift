//
//  RealmManager.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/15.
//

import Foundation
import RealmSwift

/// Rrealmの管理クラス
final class RealmManager {
    
    // MARK: - Type Properties
    
    /// シングルトンインスタンス
    static let shared = RealmManager()
    
    // MARK: - Properties
    
    /// プライベートなRealmインスタンス
    private let realm: Realm
    
    // MARK: - Initializers
    
    /// プライベート初期化子
    private init() {
        // Realmのデフォルトコンフィギュレーションを使用してインスタンスを作成
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm: \(error)")
        }
    }
    
    // MARK: - Other Methods
    
    /// Create: オブジェクトをRealmに追加
    func add<T: Object>(_ object: T,
                                   onSuccess: (() -> Void)? = nil,
                                   onFailure: ((Error) -> Void)? = nil) {
        do {
            try realm.write {
                realm.add(object)
            }
            onSuccess?()
        } catch {
            onFailure?(error)
        }
    }
    
    /// Read: オブジェクトを取得
    func getObjects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func update(onSuccess: (() -> Void)? = nil,
                      onFailure: ((Error) -> Void)? = nil,
                      _ block: () -> Void) {
        do {
            try realm.write {
                block()
            }
            onSuccess?()
        } catch {
            onFailure?(error)
        }
    }
    
    /// Delete: オブジェクトを削除
    func delete<T: Object>(_ object: T,
                                      onSuccess: (() -> Void)? = nil,
                                      onFailure: ((Error) -> Void)? = nil) {
        do {
            try realm.write {
                realm.delete(object)
            }
            onSuccess?()
        } catch {
            onFailure?(error)
        }
    }
}
