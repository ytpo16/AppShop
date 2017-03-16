//
//  TableViewController.swift
//  AppShop
//
//  Created by Admin on 13/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData


class StoreTableViewController: UITableViewController, UIGestureRecognizerDelegate, DetailVCProtocol, AdminVCProtocol, ProductObjProtocol {
    
    var goods:[Product] = []
    var myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = myRefreshControl
        self.refreshControl?.addTarget(self, action: #selector(StoreTableViewController.didRefreshList), for: .valueChanged)
        
        fetchProducts()
    }
    
    func didRefreshList(){
        fetchProducts()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func fetchProducts()
    {
        let fetchRequest:NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [Product]
            
            self.goods = searchResults
        }
        catch{
            
        }
    }
    
//    func toInt(s: String?) -> Int {
//        var result = 0
//        if let str: String = s,
//            let i = Int(str) {
//            result = i
//        }
//        return result
//    }
//    
//    func toDouble(s: String?) -> Double {
//        var result = 0.0
//        if let str: String = s,
//            let i = Double(str) {
//            result = i
//        }
//        return result
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func doFullscreenImage(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.imageData = imageView.image!
        self.present(imageVC, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.goods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cellIdintifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! CustomTableViewCell
        
        cell.productNameLabel.text = goods[indexPath.row].name
        cell.priceLabel.text = "Price: \(String(goods[indexPath.row].price))"
        cell.amountLabel.text = "Amount: \(String(goods[indexPath.row].amount))"
        cell.imageLabel.image = UIImage(data: goods[indexPath.row].image! as Data)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doFullscreenImage))
        cell.imageLabel.isUserInteractionEnabled = true
        tap.delegate = self
        cell.imageLabel.addGestureRecognizer(tap)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let pRowData = goods[indexPath.row]
        self.performSegue(withIdentifier: "MoveToDetailView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToDetailView"
        {
            let indPath = sender as? IndexPath
            let prodObj = goods[(indPath?.row)!]
            
            if let detViewController = segue.destination as? DetailViewController{
                detViewController.myProtocol = self
                detViewController.productData = prodObj
                detViewController.indexPath = indPath
            }
        }
    }
    
    func updateProductInStoreVC(prodObj: Product, indexPath: IndexPath){
        let cellIdintifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! CustomTableViewCell
        
        cell.productNameLabel.text = prodObj.name
        cell.priceLabel.text = "\(prodObj.price)"
        cell.amountLabel.text = "\(prodObj.amount)"
        cell.imageLabel.image = UIImage(data: prodObj.image! as Data)
        tableView.reloadData()
    }
    
    func updateProductAmountInViewTable(amount: Int16, indexPath: IndexPath){
        let cellIdintifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! CustomTableViewCell
        
        goods[indexPath.row].amount = amount
        
        cell.amountLabel.text = "Amount: \(String(goods[indexPath.row].amount))"
        tableView.reloadData()
    }
    
    func refreshListOfGoods(){
        fetchProducts()
        tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
