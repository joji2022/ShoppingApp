//
//  CartViewController.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 24/07/22.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartEmptyLabel: UILabel!
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    @IBOutlet weak var checkOutButtonLabel: UIButton!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var width : CGFloat { CGFloat(view.frame.width) }
    var height : CGFloat { CGFloat(view.frame.width) }
    var currentUser = User()
    let cartVM = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartVM.currentUser = self.currentUser
        cartVM.loadCartItems()
        cartEmptyLabel.isHidden = true
        checkOutButtonLabel.layer.cornerRadius = width/30
        self.totalLabel.text = cartVM.totalLabelText
        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        cartCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.view.layoutIfNeeded()
        cartEmptyLabel.isHidden = cartVM.hideCartEmptyLabel
        cartCollectionView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
}

extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartVM.currentUserCartItemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "cartCellId", for: indexPath) as! CartCollectionViewCell
        cell.configure(itemNameText: cartVM.itemCellName(cellIndexRow: indexPath.row), itemImageStr: cartVM.cellImgStr(cellIndexRow: indexPath.row), quantity: cartVM.quantityForCell(cellIndexRow: indexPath.row), price: cartVM.cellPriceStr(cellIndexRow: indexPath.row), itemTotal: cartVM.cellItemTotal(cellIndexRow: indexPath.row))
        cell.currentIndexRow = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width/1.05, height: width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: width/50, bottom: 10, right: width/50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        width/50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        width/50
    }
}

extension CartViewController: CartCollectionViewCellDelegate {
    func didTapMinus(currentIndex: Int) {
        
        cartVM.didTapMinus(currentIndex: currentIndex)
        self.totalLabel.text = cartVM.totalLabelText
        cartCollectionView.reloadData()
        self.view.layoutIfNeeded()
        cartEmptyLabel.isHidden = cartVM.hideCartEmptyLabel
        
    }
    func didTapPlus(currentIndex: Int) {
        cartVM.didTapPlus(currentIndex: currentIndex)
        self.totalLabel.text = cartVM.totalLabelText
        cartCollectionView.reloadData()
    }
    
}
