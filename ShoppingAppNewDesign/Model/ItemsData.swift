//
//  ItemsData.swift
//  ShoppingAppCoreDataFinal
//
//  Created by Arun Kumar on 15/07/22.
//  Copyright © 2022 Arun Kumar. All rights reserved.
//

import Foundation

struct ItemsData: Codable {
    let items: [Item]
}

struct Item: Codable {
    let itemName: String
    let price: String
    let imageStr: String
}



