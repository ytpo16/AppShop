//
//  DetailViewController.swift
//  AppShop
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    
    var productPrice: String?
    var productData: Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
        productNameLabel.text = productData?.name
        priceField.text = "\(productData!.price)"
        amountField.text = "\(productData!.amount)"
        imageView.image = productData?.image
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
