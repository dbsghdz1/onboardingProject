//
//  Untitled.swift
//  onboardingProject
//
//  Created by 김윤홍 on 1/17/25.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func createUser(name: String, email: String, password: String, nickName: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Users", in: context) else { return }

        let user = Users(entity: entity, insertInto: context)
        user.name = name
        user.email = email
        user.password = password
        user.nickName = nickName

        saveContext()
        print("유저 생성\(name), email: \(email)")
    }
    
    func readUserByEmail(email: String) -> Users? {
            let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            do {
                let users = try context.fetch(fetchRequest)
                return users.first
            } catch {
                print("이메일로 유저 검색 실패: \(error)")
                return nil
            }
        }

    func fetchAllUsers() -> [Users] {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            print("유저 수: \(users.count)")
            return users
        } catch {
            print("유저 불러오기 실패: \(error)")
            return []
        }
    }

    func deleteUser(email: String) {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            if let user = try context.fetch(fetchRequest).first {
                context.delete(user)
                saveContext()
                print("유저 삭제: \(email)")
            } else {
                print("찾을 수 없는 유저")
            }
        } catch {
            print("유저 지우기 실패: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("saveContext error \(error)")
            }
        }
    }
}
