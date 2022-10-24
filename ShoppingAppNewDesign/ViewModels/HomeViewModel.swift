//
//  HomeViewModel.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 28/07/22.
//

import UIKit
import CoreData

class HomeViewModel {
    var currentUser = User()
    var cartItems = [CartItems]()
    var quantityArray = [Int]()
    var tappedCellRow = 0
    
    var itemsArray = [Item]()
    var filteredArray = [Item]()
    let apiHandler = APIHandler()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailImgStr: String {
        itemsArray[tappedCellRow].imageStr
    }
    var detailItemName: String {
        itemsArray[tappedCellRow].itemName
    }
    var detailPrice: String {
        itemsArray[tappedCellRow].price
    }
    
    init() {
        apiHandler.getDataFromJsonFile(with: "Items") { array in
            self.itemsArray = array
            self.filteredArray = self.itemsArray
        }
        
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        do {
            try cartItems = context.fetch(request)
            print(cartItems)
        }
        catch {
            print(error.localizedDescription)
        }
        
        createQuantityArray(itmsArray: itemsArray)
        
    }
    
    func totalQuantity() -> String {
        var totlalQuantity = 0
        for cartItem in cartItems {
            if cartItem.ownerUser == currentUser{
                totlalQuantity += Int(cartItem.quantity!)!
            }
        }
        return String(totlalQuantity)
    }
    
    func itemCellName(cellIndexRow: Int) -> String {
        filteredArray[cellIndexRow].itemName
    }
    func cellImgStr(cellIndexRow: Int) -> String {
        filteredArray[cellIndexRow].imageStr
    }
    func cellPriceStr(cellIndexRow: Int) -> String {
        filteredArray[cellIndexRow].price
    }
    func quantityForCell(cellIndexRow: Int) -> String {
        String(quantityArray[cellIndexRow])
    }
    
    
    
    func numberOfItems() -> Int {
        filteredArray.count
    }
    
    func addToCart() {
        self.loadCartItems()
        var isNewItem = true
        for item in cartItems {
            if item.itemName == itemsArray[tappedCellRow].itemName && item.ownerUser == currentUser {
                item.setValue(String(Int(item.quantity!)!
                                     + 1), forKey: "quantity")
                self.saveCartItem()
                isNewItem = false
                
            }
            
        }
        if cartItems.isEmpty {
            print("cartItems is empty")
            let newItem = CartItems(context: self.context)
            newItem.imageName = itemsArray[tappedCellRow].imageStr
            newItem.itemName = itemsArray[tappedCellRow].itemName
            newItem.price = itemsArray[tappedCellRow].price
            newItem.ownerUser = currentUser
            newItem.quantity = "1"
            saveCartItem()
        }
        else if isNewItem {
            
            let newItem = CartItems(context: self.context)
            newItem.imageName = itemsArray[tappedCellRow].imageStr
            newItem.itemName = itemsArray[tappedCellRow].itemName
            newItem.price = itemsArray[tappedCellRow].price
            newItem.ownerUser = currentUser
            newItem.quantity = "1"
            saveCartItem()
        }
        
        self.loadCartItems()
        self.createQuantityArray(itmsArray: itemsArray)
    }
    
    func saveCartItem() {
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCartItems() {
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        do {
            try cartItems = context.fetch(request)
            print(cartItems)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func createQuantityArray(itmsArray: [Item]) {
        quantityArray = [Int](repeating: 0, count: itmsArray.count)
        for (n, item) in itmsArray.enumerated() {
            for cartItem in cartItems {
                if item.itemName == cartItem.itemName && cartItem.ownerUser == currentUser{
                    quantityArray[n] = Int(cartItem.quantity!)!
                }
            }
        }
    }
}
