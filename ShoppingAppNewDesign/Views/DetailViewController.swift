//
//  DetailViewController.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 24/07/22.
//

import UIKit

protocol DetailViewControllerDelegate {
    func didTapAddToCart()
}

class DetailViewController: UIViewController {
    
    var delegate: DetailViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addToCartOutlet: UIButton!
    
    @IBOutlet weak var itemCountAddedToCart: UILabel!
    
    
    
    var imageStr: String?
    var itemName: String?
    var price: String?
    var quantity: String?
    var currentUser = User()
    
    let detailVM = DetailViewModel()
    let cartButton = UIButton(type: .custom)
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
        detailVM.currentUser = self.currentUser
        self.loadCartItems()
        
        detailVM.itemName = self.itemName
        imageView.image = UIImage(named: imageStr! )
        itemNameLabel.text = itemName
        priceLabel.text = price
        imageView.layer.cornerRadius = 10
        addToCartOutlet.layer.cornerRadius = 10
    }
    
    
    func setUpBarButtons() {
        label = UILabel(frame: CGRect(x: 3, y: -8, width: 30, height: 20))
        label.font = UIFont(name: "Arial-BoldMT", size: 16)// add font and size of label
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.systemPink
        label.backgroundColor =   UIColor.clear
        
        let cartImg    = UIImage(named: "cartImage")?.withRenderingMode(.alwaysTemplate)
        
        cartButton.addSubview(label)
        
        let cartImgView = UIImageView(image: cartImg)
        
        cartImgView.frame = CGRect(x: 5, y: 5, width: 22, height: 22)
        
        cartImgView.tintColor = UIColor(named: "appGreen")
        
        cartButton.addSubview(cartImgView)
        
        let cartBarButon   = UIBarButtonItem(customView: cartButton)
        
        navigationItem.rightBarButtonItem = cartBarButon
        
        let cartGesture = UILongPressGestureRecognizer(target: self, action:  #selector (self.cartAction (_:)))
        cartGesture.minimumPressDuration = 0
        cartButton.addGestureRecognizer(cartGesture)
        
    }
    
    @objc func cartAction(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            cartButton.alpha = 0.5
            
        }
        if sender.state == .ended {
            cartButton.alpha = 1
            self.performSegue(withIdentifier: "toCartViewFromDetail", sender: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadCartItems()
        label.text = detailVM.totalQuantity()
    }
    
    func loadCartItems() {
        itemCountAddedToCart.text = detailVM.loadCartItemsAndReturnItemCount()
    }
    
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        
        delegate?.didTapAddToCart()
        self.loadCartItems()
        label.text = detailVM.totalQuantity()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCartViewFromDetail" {
            let destinationVC = segue.destination as! CartViewController
            destinationVC.currentUser = self.currentUser
        }
    }
    
    
}
