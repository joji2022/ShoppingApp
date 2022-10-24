//
//  APIManager.swift
//  APIContactCall
//
//  Created by Naveeth's on 04/07/22.
//

import Foundation

class APIHandler {
    func getDataFromJsonFile( with resource: String, completionBlock: @escaping ([Item]) -> Void) {
            if let path = Bundle.main.path(forResource: resource, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ItemsData.self, from: data)
                            completionBlock(decodedData.items)
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                } catch {
                    // handle error
                    print(error.localizedDescription)
                }
            }
        }
}
