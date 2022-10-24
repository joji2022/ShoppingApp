//
//  DetailViewModel.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 29/07/22.
//

import UIKit
import CoreData

class DetailViewModel {
    
    var imageStr: String?
    var itemName: String?
    var price: String?
    var quantity: String?
    
    var cartItems = [CartItems]()
    var currentUserCartItems = [CartItems]()
    var currentUser = User()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func totalQuantity() -> String {
        var totlalQuantity = 0
        for cartItem in cartItems {
            if cartItem.ownerUser == currentUser{
                totlalQuantity += Int(cartItem.quantity!)!
            }
        }
        return String(totlalQuantity)
    }
    
    func loadCartItemsAndReturnItemCount() -> String {
        
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        do {
            try cartItems = context.fetch(request)
            currentUserCartItems = []
            for item in cartItems {
                if item.ownerUser?.email == currentUser.email {
                    currentUserCartItems.append(item)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        var itemDeleted = true
        
        for item in currentUserCartItems {
            if item.itemName == itemName {
                quantity = item.quantity
                itemDeleted = false
            }
        }
        
        if itemDeleted {
            quantity = nil
        }
        
        if let quantity = quantity {
            return "\(quantity) item added to Cart"
        }
        
        else {
            return  ""
        }
        
    }
    
    
    
    
}
