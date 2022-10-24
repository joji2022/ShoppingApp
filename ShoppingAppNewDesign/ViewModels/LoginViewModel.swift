//
//  LoginViewModel.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 28/07/22.
//

import UIKit
import CoreData

class LoginViewModel {
    
    var users = [User]()
    var currentUser = User()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        
        loadUsers()
        
    }
    
    func loadUsers() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            try users = context.fetch(request)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func validEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    
    func verifiedUser(email: String, password: String) -> Bool? {
        var userExists = false
        var returnBool: Bool?
        for user in users {
            if user.email == email {
                if user.password == password {
                    self.currentUser = user
                    userExists = true
                    returnBool = true
                }
                else {
                    returnBool = false
                    break
                }
                if userExists {
                    break
                }
            }
            if userExists {
                break
            }
            else {
                returnBool = nil
            }
        }
//        if userExists {
            return returnBool
//        }
//        else {
//            return userExists
//        }
    }
}
