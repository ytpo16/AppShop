//
//  TableViewController.swift
//  AppShop
//
//  Created by Admin on 13/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CSVImporter

class Product
{
    public var name: String?
    public var price: Double = 0
    public var amount: Int = 0
    
    init(name: String, price: Double, amount: Int) {
        self.name = name
        self.price = price
        self.amount = amount
    }
}

class StoreTableViewController: UITableViewController {
    
    let namesGoods = ["Iphone", "Ipad", "Mac"]
    
    var goods:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let path = Bundle.main.path(forResource: "data", ofType: "csv")
        //        if let path = Bundle.main.path(forResource: "data.csv", ofType: "csv"){
        //            let imgName = "data"
        //        let url = Bundle.main.url(forResource: "second", withExtension: "pdf")
        //        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        let path = "/Users/admin/Desktop/data.csv"
        
        let importer = CSVImporter<[String]>(path: path)
        
        let importedRecords = importer.importRecords { $0 }
        
        
        for i in (0...importedRecords.count - 1) {
            self.goods.append(Product(name: importedRecords[i][0], price: self.toDouble(s: importedRecords[i][1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), amount: self.toInt(s: importedRecords[i][2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))))
        }
        
        //                importer.startImportingRecords { $0 }.onFinish { importedRecords in
        //                    for record in importedRecords {
        //                        // record is of type [String] and contains all data in a line
        //                        self.goods[0].name = record[0]
        //                        }
//                    }
//        let importer = CSVImporter<Product>(path: path)
//        importer.startImportingRecords { recordValues -> Product in
//            
//            return Product(name: recordValues[0], price: self.toInt(s: recordValues[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), amount: self.toInt(s: recordValues[2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)))
//            
//            }.onFinish { importedRecords in
//                
////                for student in importedRecords {
////                    // Now importedRecords is an array of Students
////                    self.goods[0] = student
////                }
//                self.goods = importedRecords
//                
//        }
        
        
        //        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func toInt(s: String?) -> Int {
        var result = 0
        if let str: String = s,
            let i = Int(str) {
            result = i
        }  
        return result  
    }
    
    func toDouble(s: String?) -> Double {
        var result = 0.0
        if let str: String = s,
            let i = Double(str) {
            result = i
        }
        return result
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cellIdintifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! CustomTableViewCell
        
        cell.productNameLabel.text = goods[indexPath.row].name
        cell.priceLabel.text = "Price: \(String(goods[indexPath.row].price))"
        cell.amountLabel.text = "Amount: \(String(goods[indexPath.row].amount))"
        //...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pRowData = goods[indexPath.row]
        self.performSegue(withIdentifier: "MoveToDetailView", sender: pRowData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MoveToDetailView"
        {
            if let detViewController = segue.destination as? DetailViewController{
                detViewController.productData = sender as? Product
            }
        }
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
