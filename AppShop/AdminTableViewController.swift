//
//  AdminTableViewController.swift
//  AppShop
//
//  Created by Admin on 11/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData
import CSVImporter

protocol AdminVCProtocol{
    
    func refreshListOfGoods()
}

protocol ProductObjProtocol{
    
    func updateProductInStoreVC(prodObj: Product, indexPath: IndexPath)
}

class AdminTableViewController: UITableViewController, ProductVCProtocol {
    
    var alterAction = UIAlertAction()
    var pathToCsvFile = ""
    
    var goods:[Product] = []
    var myProtocol: AdminVCProtocol?
    var myProductObjProtocol: ProductObjProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProducts()
    }
    @IBAction func uploadCSVData(_ sender: Any) {
        let altMessage = UIAlertController(title: "Upload data", message: "Please input path to csv file data", preferredStyle: .alert)
        
        altMessage.addTextField(configurationHandler: {(textField) -> Void in
            textField.addTarget(self, action: #selector(self.csvTextFieldDidChange(_:)), for: .editingChanged)
        })
        
        alterAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in
            if self.pathToCsvFile != ""{
                self.uploadCSVdata(path: self.pathToCsvFile)
            }
        })
        
        altMessage.addAction(alterAction)
        self.present(altMessage, animated: true, completion: nil)
    }
    
    func uploadCSVdata(path: String){
        
        let fetchRequest:NSFetchRequest<Product> = Product.fetchRequest()
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [Product]
            
            for res in searchResults{
                //                            print("name is \(res.name!) and price is \(res.price) and amount is \(res.amount)")
                DatabaseController.getContext().delete(res)
            }
            DatabaseController.saveContext()
            
            self.goods = searchResults
        }
        catch{
            
        }
        
        let importer = CSVImporter<[String]>(path: path)
        let importedRecords = importer.importRecords { $0 }
        //        let path = "/Users/admin/Desktop/data.csv"
        //        let strUrl = "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png"
        //        var strUrl = "http://abali.ru/wp-content/uploads/2010/12/znak-radiaciya.png"
        //
        //        let url = URL(string: strUrl)
        //        var data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        //
        //        if data == nil{
        let img = UIImage(named: "empty")
        let data = UIImagePNGRepresentation(img!)
        let strUrl = ""
        //          }
        for i in (0...importedRecords.count - 1) {
            
            let prodObj:Product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: DatabaseController.getContext()) as! Product
            prodObj.name = importedRecords[i][0]
            prodObj.price = Double(importedRecords[i][1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            prodObj.amount = Int16(importedRecords[i][2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            prodObj.image = data as NSData?
            prodObj.imageUrl = strUrl
        }
        DatabaseController.saveContext()
        
        fetchProducts()
        tableView.reloadData()
    }
    
    func csvTextFieldDidChange(_ textField: UITextField) {
        
        let fileManager = FileManager.default
        
        // Check if file exists, given its path
        if fileManager.fileExists(atPath: textField.text!) {
            pathToCsvFile = textField.text!
        }
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
            self.goods = searchResults
        }
        catch{
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdintifier = "AdminCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! AdminCustomTableViewCell
        
        cell.productNameLabel.text = goods[indexPath.row].name
        cell.priceLabel.text = "\(String(goods[indexPath.row].price))"
        
        return cell
    }
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "MoveToProductView", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MoveToProductView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToProductView"
        {
            if let detViewController = segue.destination as? ProductViewController{
                detViewController.myProtocol = self
                if let indPath = sender as? IndexPath {
                    let prodObj = goods[(indPath.row)]
                    
                    detViewController.productData = prodObj
                    detViewController.indexPath = indPath
                }
            }
        }
    }
    
    func updateProductInViewTable(prodObj: Product?, indexPath: IndexPath?){
        if indexPath != nil{
            let cellIdintifier = "AdminCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath!) as! AdminCustomTableViewCell
            
            cell.productNameLabel.text = prodObj?.name
            cell.priceLabel.text = "\(prodObj?.price)"
            
            myProductObjProtocol?.updateProductInStoreVC(prodObj: prodObj!, indexPath: indexPath!)
        }
        else{
            fetchProducts()
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Social
        //        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: { (actin, indexPath) -> Void in
        //            let defaultText = "Just checking in at " + self.goods[indexPath.row].name!
        //            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        //            self.present(activityController, animated: true, completion: nil)
        //        })
        
        //Delete
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(actin, indexPath) -> Void in
            self.goods.remove(at: indexPath.row)
            
            //            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            //                let restarauntToDelete = self.fetchResultController.object(at: indexPath) as! Product
            //
            //                managedObjectContext.delete(restarauntToDelete)
            //                tableView.deleteRows(at: [indexPath], with: .fade)
            //                do {
            //                    try managedObjectContext.save()
            //                } catch {
            //                    print(error)
            //                }
            //            }
            
            let fetchRequest:NSFetchRequest<Product> = Product.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "name = %@", "MyIphone2")
            
            do {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [Product]
                let productToDelete = searchResults[indexPath.row]
                DatabaseController.getContext().delete(productToDelete)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DatabaseController.saveContext()
                
                self.myProtocol?.refreshListOfGoods()
                //                for res in searchResults as [Product]{
                //                    print("name is \(res.name!) and price is \(res.price) and amount is \(res.amount)")
                //                    DatabaseController.getContext().delete(res)
                //                }
            }
            catch{
                
            }
            
        })
        
        //        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
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
