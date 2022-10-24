//
//  CartViewModel.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 29/07/22.
//

import UIKit
import CoreData

class CartViewModel {
    
    var cartItems = [CartItems]()
    var currentUserCartItems = [CartItems]()
    var currentUser = User()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var totalLabelText = ""
    
    var hideCartEmptyLabel: Bool {
        !currentUserCartItems.isEmpty
    }
    func loadCartItems() {
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
        totalLabelText = "Total: ₹\(calculateTotal()/1000),000"
    }
    
    func saveCartItem() {
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func calculateTotal() -> Int {
        var sum = 0
        for item in currentUserCartItems {
            sum += Int(item.price!)! * Int(item.quantity!)!
        }
        return sum
    }
    
    func currentUserCartItemCount() -> Int {
        currentUserCartItems.count
    }
    
    
    func itemCellName(cellIndexRow: Int) -> String {
        currentUserCartItems[cellIndexRow].itemName!
    }
    func cellImgStr(cellIndexRow: Int) -> String {
        currentUserCartItems[cellIndexRow].imageName!
    }
    func cellPriceStr(cellIndexRow: Int) -> String {
        currentUserCartItems[cellIndexRow].price!
    }
    func quantityForCell(cellIndexRow: Int) -> String {
        currentUserCartItems[cellIndexRow].quantity!
    }
    
    func cellItemTotal(cellIndexRow: Int) -> String {
        String(Int(currentUserCartItems[cellIndexRow].price!)! * Int(currentUserCartItems[cellIndexRow].quantity!)!)
    }
    
    
    func didTapMinus(currentIndex: Int) {
        if Int(currentUserCartItems[currentIndex].quantity!)! > 1 {
            for item in cartItems {
                if  item.ownerUser == currentUser && item.itemName == currentUserCartItems[currentIndex].itemName  {
                    item.setValue(String(Int(item.quantity!)!
                                         - 1), forKey: "quantity")
                    self.saveCartItem()
                    self.loadCartItems()
                }
            }
        }
        else {
            context.delete(currentUserCartItems[currentIndex])
            currentUserCartItems.remove(at: currentIndex)
            do {
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
            self.loadCartItems()
        }
        totalLabelText = "Total: ₹\(calculateTotal()/1000),000"
    }
    
    func didTapPlus(currentIndex: Int) {
        
        for item in cartItems {
            if  item.ownerUser == currentUser && item.itemName == currentUserCartItems[currentIndex].itemName  {
                item.setValue(String(Int(item.quantity!)!
                                     + 1), forKey: "quantity")
                self.saveCartItem()
                self.loadCartItems()
                
            }
        }
        totalLabelText = "Total: ₹\(calculateTotal()/1000),000"
    }
    
}
