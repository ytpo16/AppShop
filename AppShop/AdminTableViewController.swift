//
//  AdminTableViewController.swift
//  AppShop
//
//  Created by Admin on 11/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class AdminTableViewController: UITableViewController, ProductVCProtocol {

    var goods:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchProducts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.goods.count
    }

    func fetchProducts()
    {
        let fetchRequest:NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [Product]
            
            //            for res in searchResults{
            //                print("name is \(res.name!) and price is \(res.price) and amount is \(res.amount)")
            //                DatabaseController.getContext().delete(res)
            //            }
            //            DatabaseController.saveContext()
            
            self.goods = searchResults
        }
        catch{
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let cellIdintifier = "AdminCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! AdminCustomTableViewCell
        
        cell.productNameLabel.text = goods[indexPath.row].name
        cell.priceLabel.text = "\(String(goods[indexPath.row].price))"
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doFullscreenImage))
//        cell.imageLabel.isUserInteractionEnabled = true
//        tap.delegate = self
//        cell.imageLabel.addGestureRecognizer(tap)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let pRowData = goods[indexPath.row]
        self.performSegue(withIdentifier: "MoveToProductView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToProductView"
        {
            let indPath = sender as? IndexPath
            let prodObj = goods[(indPath?.row)!]
            
            if let detViewController = segue.destination as? ProductViewController{
                detViewController.myProtocol = self
                detViewController.productData = prodObj
                detViewController.indexPath = indPath
            }
        }
    }
    
    func updateProductInViewTable(prodObj: Product, indexPath: IndexPath){
        let cellIdintifier = "AdminCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! AdminCustomTableViewCell
        
        cell.productNameLabel.text = prodObj.name
        cell.priceLabel.text = "\(prodObj.price)"
        
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
