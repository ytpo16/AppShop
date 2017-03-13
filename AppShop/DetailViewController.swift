//
//  DetailViewController.swift
//  AppShop
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol DetailVCProtocol{
    
    func updateProductAmountInViewTable(amount: Int16, indexPath: IndexPath)
}

class DetailViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    
    //    var productPrice: String?
    var productData: Product?
    var indexPath: IndexPath?
    var myProtocol: DetailVCProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doFullscreenImage))
        imageView.isUserInteractionEnabled = true
        tap.delegate = self
        imageView.addGestureRecognizer(tap)
        
        amountField.delegate = self
        productNameLabel.text = productData?.name
        priceField.text = "\(productData!.price)"
        amountField.text = "\(productData!.amount)"
        imageView.image = UIImage(data: (productData?.image)! as Data)
    }
    
    @IBAction func buyButtonClick(_ sender: Any) {
        textFieldDidEndEditing(amountField)
        if amountField.text == "0"
        {
            let altMessage = UIAlertController(title: "Warning", message: "Amount can`t be zero", preferredStyle: .alert)
            
            let alterAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            altMessage.addAction(alterAction)
            
            self.present(altMessage, animated: true, completion: nil)
            return
        }
        
        do {
            let en = NSEntityDescription.entity(forEntityName: "Product", in: DatabaseController.getContext())
            let batchUpdateRequest = NSBatchUpdateRequest(entity: en!)
            
            batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
            
            productData?.amount = (productData?.amount)! - Int16(amountField.text!)!
            
            batchUpdateRequest.predicate = NSPredicate(format: "name = %@", (productData?.name)!)
            batchUpdateRequest.propertiesToUpdate = ["amount": productData?.amount ?? 0]
            
            try DatabaseController.getContext().execute(batchUpdateRequest)
            
            DatabaseController.saveContext()
            
            myProtocol?.updateProductAmountInViewTable(amount: (productData?.amount)!, indexPath: indexPath!)
        }
        catch{
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if string == "" && amountField.text!.characters.count == 1{
            amountField.text! = "0"
        }
        
        var resFormat = true
        
        if string == numberFiltered && string != ""{
            if Int16(amountField.text! + string)! > (productData?.amount)!{
                resFormat = false
            }
        }
        else
        {
            resFormat = false
        }
        
        return resFormat
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        buyButton.isEnabled = true
        
        if amountField.text == "" || amountField.text == "0"
        {
            amountField.text = "0"
            //            buyButton.isEnabled = false
        }
        
        if (amountField.text?.characters.count)! > 1 && amountField.text?.characters.first == "0"
        {
            amountField.text = "0"
            //            buyButton.isEnabled = false
        }
        
        if Int16(amountField.text!)! > (productData?.amount)!{
            amountField.text = "\((productData?.amount)!)"
        }
        
        //        if Int16(amountField.text!)! > (productData?.amount)! {
        //            let altMessage = UIAlertController(title: "Warning", message: "Exceeded the amount of goods in stock.", preferredStyle: .alert)
        //
        //            let alterAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        //
        //            altMessage.addAction(alterAction)
        //
        //            self.present(altMessage, animated: true, completion: nil)
        //
        //            amountField.text = "0"
        //
        //            return
        //        }
        
    }
    
    @IBAction func amountPlusButton(_ sender: Any) {
        amountField.text = "\(Int(amountField.text!)! + 1)"
        textFieldDidEndEditing(amountField)
    }
    @IBAction func amountMinusButton(_ sender: Any) {
        if amountField.text == "0"
        { return }
        
        amountField.text = "\(Int(amountField.text!)! - 1)"
        textFieldDidEndEditing(amountField)
    }
    //
    //        labelValuePrice.text = productData?.price
    // Do any additional setup after loading the view.    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doFullscreenImage(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.imageData = imageView.image!
        self.present(imageVC, animated: true, completion: nil)
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
