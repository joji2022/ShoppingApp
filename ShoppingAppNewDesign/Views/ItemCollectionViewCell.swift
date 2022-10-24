//
//  ItemCollectionViewCell.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 24/07/22.
//

import UIKit

protocol ItemCollectionViewCellDelegate {
    func didTapOnCell(currentIndex: Int)
}

class ItemCollectionViewCell: UICollectionViewCell {
    
    var delegate: ItemCollectionViewCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var width : CGFloat { CGFloat(self.frame.width) }
    var currentIndexRow = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(labelText: String, itemImageStr: String, priceText: String, quantity: String) {
        itemNameLabel.text = labelText
        itemImageView.image = UIImage(named: itemImageStr)
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: width/13)
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: width/13)
        priceLabel.textColor = UIColor.darkGray
        
        
        priceLabel.text = "₹\(Int(priceText)!/1000),000"
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.contentView.addGestureRecognizer(gesture)
        
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer) {
        delegate?.didTapOnCell(currentIndex: currentIndexRow)
    }
    
}
