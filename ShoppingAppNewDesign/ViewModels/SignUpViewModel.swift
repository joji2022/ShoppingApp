

import UIKit
import CoreData

class SignUpViewModel {
    
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
    
    func saveNewUser(name: String, email: String, pass: String) {
        let newUser = User(context: self.context)
        newUser.name = name
        newUser.email = email
        newUser.password = pass
        saveUser()
    }
    
    func assignCurrent(email: String) {
        self.loadUsers()
        for user in users {
            if user.email == email {
                self.currentUser = user
            }
        }
    }
    
    func saveUser() {
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func isNewUser(email: String) -> Bool {
        var isNewUser = true
        for user in users {
            if user.email == email {
                isNewUser = false
            }
        }
        return isNewUser
    }
    
    
}
