//
//  CartCollectionViewCell.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 26/07/22.
//

import UIKit

protocol CartCollectionViewCellDelegate {
    func didTapMinus(currentIndex: Int)
    func didTapPlus(currentIndex: Int)
}

class CartCollectionViewCell: UICollectionViewCell {
    
    var delegate: CartCollectionViewCellDelegate?
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var centreView: UIView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var itemCountLabel: UILabel!
    
    @IBOutlet weak var itemTotalLabel: UILabel!
    
    var currentIndexRow = 0
    
    var width : CGFloat { CGFloat(self.frame.width) }
    
    func configure(itemNameText: String, itemImageStr: String, quantity: String, price: String, itemTotal: String) {
        leftView.layer.shadowOpacity = 1
        leftView.layer.shadowOffset = CGSize(width: 0, height: 3)
        leftView.layer.shadowRadius = 4
        leftView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        leftView.layer.cornerRadius = 10
        centreView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        plusButton.layer.cornerRadius = width/30
        minusButton.layer.cornerRadius = width/30
        itemNameLabel.text = itemNameText
        imageView.image = UIImage(named: itemImageStr)
        itemCountLabel.text = quantity
        priceLabel.text = price
        itemTotalLabel.text = itemTotal
        
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        
        delegate?.didTapPlus(currentIndex: currentIndexRow)
        
        
    }
    
    
    @IBAction func didTapMinusButton(_ sender: UIButton) {
        
        delegate?.didTapMinus(currentIndex: currentIndexRow)
    }
    
    
    
    
}
