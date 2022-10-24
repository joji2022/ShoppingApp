//
//  HomeViewController.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 24/07/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var width : CGFloat { CGFloat(view.frame.width) }
    var height : CGFloat { CGFloat(view.frame.width) }
    
    var currentUser = User()
    let homeVM = HomeViewModel()
    
    let cartButton = UIButton(type: .custom)
    let searchButton = UIButton(type: .custom)
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
        homeVM.currentUser = self.currentUser
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
        homeCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.homeCollectionView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeVM.loadCartItems()
        label.text = homeVM.totalQuantity()
    }
    
    func setUpBarButtons() {
        label = UILabel(frame: CGRect(x: 3, y: -8, width: 30, height: 20))
        label.font = UIFont(name: "Arial-BoldMT", size: 16)// add font and size of label
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.systemPink
        label.backgroundColor =   UIColor.clear
        
        let cartImg    = UIImage(named: "cartImage")?.withRenderingMode(.alwaysTemplate)
        let searchImg  = UIImage(named: "searchImage")?.withRenderingMode(.alwaysTemplate)
        
        cartButton.addSubview(label)
        
        let cartImgView = UIImageView(image: cartImg)
        let searchImgView = UIImageView(image: searchImg)
        
        cartImgView.frame = CGRect(x: 5, y: 5, width: 22, height: 22)
        searchImgView.frame = CGRect(x: 0, y: 5, width: 22, height: 22)
        
        cartImgView.tintColor = UIColor(named: "appGreen")
        searchImgView.tintColor = UIColor(named: "appGreen")
        
        cartButton.addSubview(cartImgView)
        searchButton.addSubview(searchImgView)
        
        let cartBarButon   = UIBarButtonItem(customView: cartButton)
        let searchBarButton   = UIBarButtonItem(customView: searchButton)
        
        navigationItem.rightBarButtonItems = [cartBarButon, searchBarButton]
        
        let cartGesture = UILongPressGestureRecognizer(target: self, action:  #selector (self.cartAction (_:)))
        cartGesture.minimumPressDuration = 0
        cartButton.addGestureRecognizer(cartGesture)
        let searchGesture = UILongPressGestureRecognizer(target: self, action:  #selector (self.searchAction (_:)))
        searchGesture.minimumPressDuration = 0
        searchButton.addGestureRecognizer(searchGesture)
        
    }
    
    @objc func cartAction(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            cartButton.alpha = 0.5
            
        }
        if sender.state == .ended {
            cartButton.alpha = 1
            self.performSegue(withIdentifier: "toCartView", sender: self)
        }
    }
    
    @objc func searchAction(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            searchButton.alpha = 0.5
            
        }
        if sender.state == .ended {
            searchButton.alpha = 1
            self.performSegue(withIdentifier: "toSearchView", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.imageStr = homeVM.detailImgStr
            destinationVC.itemName = homeVM.detailItemName
            destinationVC.price = homeVM.detailPrice
            destinationVC.currentUser = homeVM.currentUser
            destinationVC.delegate = self
            
        }
        
        if segue.identifier == "toCartView" {
            let destinationVC = segue.destination as! CartViewController
            destinationVC.currentUser = homeVM.currentUser
        }
        
        if segue.identifier == "toSearchView" {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.currentUser = homeVM.currentUser
        }
        
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ItemCollectionViewCell
        cell.backgroundColor = UIColor(named: "itemCellbg")
        cell.configure(labelText: homeVM.itemCellName(cellIndexRow: indexPath.row), itemImageStr: homeVM.cellImgStr(cellIndexRow: indexPath.row), priceText: homeVM.cellPriceStr(cellIndexRow: indexPath.row), quantity: homeVM.quantityForCell(cellIndexRow: indexPath.row))
        cell.layer.cornerRadius = 5
        cell.currentIndexRow = indexPath.row
        cell.delegate = self
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width/2.135, height: width/1.5)
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


extension HomeViewController: ItemCollectionViewCellDelegate {
    
    func didTapOnCell(currentIndex: Int) {
        homeVM.tappedCellRow = currentIndex
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
}

extension HomeViewController: DetailViewControllerDelegate {
    func didTapAddToCart() {
        homeVM.addToCart()
        self.homeCollectionView.reloadData()
    }
}
