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
    public var image = UIImage()
    
    init(name: String, price: Double, amount: Int, image: UIImage) {
        self.name = name
        self.price = price
        self.amount = amount
        self.image = image
    }
}

class StoreTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    let namesGoods = ["Iphone", "Ipad", "Mac"]
    
    var goods:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = "/Users/admin/Desktop/data.csv"
        let importer = CSVImporter<[String]>(path: path)
        let importedRecords = importer.importRecords { $0 }
        
        for i in (0...importedRecords.count - 1) {
            self.goods.append(Product(name: importedRecords[i][0], price: self.toDouble(s: importedRecords[i][1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), amount: self.toInt(s: importedRecords[i][2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), image: UIImage(named: "iphone")!))
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
////
//       let newImageView = UIImageView(image: imageView.image)
//        newImageView.frame = self.view.frame
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        newImageView.addGestureRecognizer(tap)
//        
//        self.view.addSubview(newImageView)
        
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
        cell.imageLabel.image = goods[indexPath.row].image
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doFullscreenImage))
        cell.imageLabel.isUserInteractionEnabled = true
        tap.delegate = self
        cell.imageLabel.addGestureRecognizer(tap)
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
