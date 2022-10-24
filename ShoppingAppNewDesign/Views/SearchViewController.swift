//
//  SearchViewController.swift
//  ShoppingAppNewDesign
//
//  Created by JOJI SAMUEL on 27/07/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    var width : CGFloat { CGFloat(view.frame.width) }
    var height : CGFloat { CGFloat(view.frame.width) }
    
    var currentUser = User()
    let searchVM = SearchViewModel()
    
    let cartButton = UIButton(type: .custom)
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
        searchVM.currentUser = self.currentUser
        searchBar.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
        searchCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.searchCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = searchVM.totalQuantity()
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
            self.performSegue(withIdentifier: "toCartView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.imageStr = searchVM.detailImgStr
            destinationVC.itemName = searchVM.detailItemName
            destinationVC.price = searchVM.detailPrice
            destinationVC.currentUser = searchVM.currentUser
            destinationVC.delegate = self
            
        }
        
        if segue.identifier == "toCartView" {
            let destinationVC = segue.destination as! CartViewController
            destinationVC.currentUser = searchVM.currentUser
        }
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}



extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchVM.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ItemCollectionViewCell
        cell.backgroundColor = UIColor(named: "itemCellbg")
        cell.configure(labelText: searchVM.itemCellName(cellIndexRow: indexPath.row), itemImageStr: searchVM.cellImgStr(cellIndexRow: indexPath.row), priceText: searchVM.cellPriceStr(cellIndexRow: indexPath.row), quantity: searchVM.quantityForCell(cellIndexRow: indexPath.row))
        cell.layer.cornerRadius = 5
        cell.currentIndexRow = indexPath.row
        cell.delegate = self
        return cell
        
    }
    
}




extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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


extension SearchViewController: ItemCollectionViewCellDelegate {
    func didTapOnCell(currentIndex: Int) {
        searchVM.tappedCellRow = currentIndex
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
}

extension SearchViewController: DetailViewControllerDelegate {
    func didTapAddToCart() {
        searchVM.addToCart()
        self.searchCollectionView.reloadData()
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchVM.searchButtonClicked(searchText: searchBar.text!)
        self.searchCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            searchVM.textDidChange()
            searchCollectionView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
