//  ProductViewController.swift
//  AppShop
//
//  Created by Admin on 11/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol ProductVCProtocol{
    func updateProductInViewTable(prodObj: Product?, indexPath: IndexPath?)
}

class ProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    var productData: Product?
    var indexPath: IndexPath?
    var myProtocol: ProductVCProtocol?
    var oldName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountField.tag = 1
        amountField.delegate = self
        
        priceField.tag = 2
        priceField.delegate = self
        
        self.navigationItem.title = "Title"
        
        if indexPath != nil {
            oldName = productData!.name
            
            nameField.text = oldName
            priceField.text = "\(productData!.price)"
            imageField.text = productData!.imageUrl
            amountField.text = "\(productData!.amount)"
        }
        else{
            priceField.text = "0.0"
            amountField.text = "0"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if nameField.text == ""
        {
            let altMessage = UIAlertController(title: "Warning", message: "Product name can`t be empty", preferredStyle: .alert)
            let alterAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            altMessage.addAction(alterAction)
            self.present(altMessage, animated: true, completion: nil)
            return
        }
        
        func showSavingError(){
            let altMessage = UIAlertController(title: "Error!", message: "Failed to save", preferredStyle: .alert)
            let alterAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            altMessage.addAction(alterAction)
            self.present(altMessage, animated: true, completion: nil)
        }
        
        if productData == nil{
            do {
                let prodObj:Product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: DatabaseController.getContext()) as! Product
                prodObj.name = nameField.text
                prodObj.price = Double(priceField.text!)!
                prodObj.amount = Int16(amountField.text!)!
                
                let img = UIImage(named: "empty")
                var data = UIImagePNGRepresentation(img!)
                let maybeUrl = imageField.text!
                imageField.text = ""
                
                let url = URL(string: maybeUrl)
                
                if url != nil{
                    let dataTry = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if dataTry != nil{
                        data = dataTry
                        imageField.text = maybeUrl
                    }
                }
                
                prodObj.image = data as NSData?
                prodObj.imageUrl = imageField.text
                
                DatabaseController.saveContext()
                
                myProtocol?.updateProductInViewTable(prodObj: nil, indexPath: nil)
            }
        }
        else{
            
            do {
                let en = NSEntityDescription.entity(forEntityName: "Product", in: DatabaseController.getContext())
                let batchUpdateRequest = NSBatchUpdateRequest(entity: en!)
                
                batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
                
                productData?.name = nameField.text
                productData?.price = Double(priceField.text!)!
                productData?.amount = Int16(amountField.text!)!
                productData?.imageUrl = imageField.text
                
                if productData?.imageUrl != ""{
                    var data = try? Data(contentsOf: URL(string: (productData?.imageUrl)!)!)
                    if data == nil{
                        let img = UIImage(named: "empty")
                        data = UIImagePNGRepresentation(img!)
                        productData?.imageUrl = ""
                    }
                    productData?.image = data as NSData?
                }
                
                batchUpdateRequest.predicate = NSPredicate(format: "name = %@", (oldName)!)
                
                batchUpdateRequest.propertiesToUpdate = ["name": (productData?.name)!]
                batchUpdateRequest.propertiesToUpdate = ["amount": productData?.amount ?? 0]
                batchUpdateRequest.propertiesToUpdate = ["price": productData?.price ?? 0]
                batchUpdateRequest.propertiesToUpdate = ["imageUrl": (productData?.imageUrl)!]
                batchUpdateRequest.propertiesToUpdate = ["image": (productData?.image)!]
                
                try DatabaseController.getContext().execute(batchUpdateRequest)
                
                DatabaseController.saveContext()
                
                myProtocol?.updateProductInViewTable(prodObj: productData!, indexPath: indexPath!)
            }
            catch{
                showSavingError()
                return
            }
            
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1{
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string == "" && amountField.text!.characters.count == 1{
                amountField.text! = "0"
                return false
            }
            
            if string != "" && amountField.text! == "0"{
                amountField.text! = string
                return false
            }
            
            var resFormat = true
            
            if !(string == numberFiltered){
                resFormat = false
            }
            
            return resFormat
        }
        else{
            
            let oldString = priceField.text!
            let currentString = priceField.text! + string
            
            if (Double(currentString) != nil)
            {
                if let myRange = currentString.range(of: ".") {
                    let startPos = currentString.distance(from: currentString.startIndex, to: myRange.lowerBound)
                    
                    if string == "" && range.location == startPos{
                        return false
                    }
                    
                    if string != "" && startPos == 1 && range.location <= startPos && oldString.characters.first == "0" {
                        priceField.text = string + String(oldString.characters.dropFirst())
                        return false //because upper set correct value
                    }
                    
                    if string == "" && startPos == 1 && range.location == 0{
                        priceField.text = "0" + String(currentString.characters.dropFirst())
                        return false //because upper set correct value
                    }
                    
                    if string == "" && startPos == (currentString.characters.count - 2) && range.location > startPos{
                        priceField.text = String(currentString.characters.dropLast()) + "0"
                        return false //because upper set correct value
                    }
                    
                    if startPos < (currentString.characters.count - 3) && startPos < range.location {
                        return false
                    }
                    
                    return true
                }
                
            }
            
            return false
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
