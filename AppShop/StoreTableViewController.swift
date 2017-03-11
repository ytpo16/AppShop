//
//  TableViewController.swift
//  AppShop
//
//  Created by Admin on 13/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CSVImporter
import CoreData

//class ProductObj
//{
//    public var name: String?
//    public var price: Double = 0
//    public var amount: Int = 0
//    public var image = UIImage()
//    
//@nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
//    return NSFetchRequest<Product>(entityName: "Product");
//}
//
//@NSManaged public var amount: Int32
//@NSManaged public var image: NSData?
//@NSManaged public var name: String?
//@NSManaged public var price: Double
//    init(name: String, price: Double, amount: Int, image: NSData?) {
//        self.name = name
//        self.price = price
//        self.amount = amount
//        self.image = image
//    }
//}


class StoreTableViewController: UITableViewController, UIGestureRecognizerDelegate, DetailVCProtocol {
    
    let namesGoods = ["Iphone", "Ipad", "Mac"]
    var goods:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        
//        let product:Product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: DatabaseController.getContext()) as! Product
//        product.name = "MyIphone2"
//        product.price = 323.34
//        product.amount = 333
////        product.image = UIImage("iphone") as NSData
//        
//        DatabaseController.saveContext()
        
        fetchProducts()
        
        //  если количество элементов в базе 0 то читаем с файла. Дальше только с базой работаем
        if self.goods.count == 0 {
            let path = "/Users/admin/Desktop/data.csv"
            let importer = CSVImporter<[String]>(path: path)
            let importedRecords = importer.importRecords { $0 }
            
            
            let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            for i in (0...importedRecords.count - 1) {
                
                let prodObj:Product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: DatabaseController.getContext()) as! Product
                prodObj.name = importedRecords[i][0]
                prodObj.price = self.toDouble(s: importedRecords[i][1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                prodObj.amount = Int16(importedRecords[i][2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                prodObj.image = data as NSData?
                //self.goods.append(prodObj)
                //            self.goods.append(Product(name: importedRecords[i][0], price: self.toDouble(s: importedRecords[i][1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), amount: self.toInt(s: importedRecords[i][2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), image: data as NSData?))
            }
            DatabaseController.saveContext()
            
            fetchProducts()
        }
//        let product:Product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: DatabaseController.getContext()) as! Product
        

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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    ////    @IBOutlet weak var imageLabel: UIImageView!
    //
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    ////        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
    ////        imageLabel.image = selectedPhoto
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    @IBAction func selectedImage(_ sender: UITapGestureRecognizer) {
    //        let imagePickerController = UIImagePickerController()
    //        imagePickerController.sourceType = .photoLibrary
    //        imagePickerController.delegate = self
    //        present(imagePickerController, animated: true, completion: nil)
    //    }
    
    //    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
    //        let imageView = sender.view as! UIImageView
    //
    //        let newImageView = UIImageView(image: imageView.image)
    //        newImageView.frame = self.view.frame
    //        newImageView.backgroundColor = .black
    //        newImageView.contentMode = .scaleAspectFit
    //        newImageView.isUserInteractionEnabled = true
    //
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
    //        newImageView.addGestureRecognizer(tap)
    //
    //        self.view.addSubview(newImageView)
    //    }
    
    func doFullscreenImage(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.imageData = imageView.image!
        self.present(imageVC, animated: true, completion: nil)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
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
    
    func updateProductAmountInViewTable(amount: Int16, indexPath: IndexPath){
        let cellIdintifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdintifier, for: indexPath) as! CustomTableViewCell
        
        goods[indexPath.row].amount = amount
        
        cell.amountLabel.text = "Amount: \(String(goods[indexPath.row].amount))"
        tableView.reloadData()
    }
    
//    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        //Social
//        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: { (actin, indexPath) -> Void in
//            let defaultText = "Just checking in at " + self.goods[indexPath.row].name!
//            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
//            self.present(activityController, animated: true, completion: nil)
//        })
//        
//        //Delete
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(actin, indexPath) -> Void in
//            self.goods.remove(at: indexPath.row)
//            
////            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
////                let restarauntToDelete = self.fetchResultController.object(at: indexPath) as! Product
////                
////                managedObjectContext.delete(restarauntToDelete)
////                tableView.deleteRows(at: [indexPath], with: .fade)
////                do {
////                    try managedObjectContext.save()
////                } catch {
////                    print(error)
////                }
////            }
//            
//            let fetchRequest:NSFetchRequest<Product> = Product.fetchRequest()
//            //fetchRequest.predicate = NSPredicate(format: "name = %@", "MyIphone2")
//            
//            do {
//                let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [Product]
////                print("number of results\(searchResults.count)")
//                
//                let productToDelete = searchResults[indexPath.row]
//                DatabaseController.getContext().delete(productToDelete)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                do {
//                    try DatabaseController.saveContext()
//                } catch {
//                    print(error)
//                }
////                for res in searchResults as [Product]{
////                    print("name is \(res.name!) and price is \(res.price) and amount is \(res.amount)")
////                    DatabaseController.getContext().delete(res)
////                }
//            }
//            catch{
//                
//            }
//            
//        })
//        
//        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
//        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
//        
//        return [deleteAction, shareAction]
//    }
    
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
