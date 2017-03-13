//
//  ProductViewController.swift
//  AppShop
//
//  Created by Admin on 11/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol ProductVCProtocol{
    
    func updateProductInViewTable(prodObj: Product, indexPath: IndexPath)
}

class ProductViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    var productData: Product?
    var indexPath: IndexPath?
    var myProtocol: ProductVCProtocol?
    var oldName: String?
    var isNewObj = false
//    isNewObj = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Title"
        
        if !isNewObj {
            oldName = productData!.name
            
            nameField.text = oldName
            priceField.text = "\(productData!.price)"
            imageField.text = productData!.imageUrl
            amountField.text = "\(productData!.amount)"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func cancelButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        do {
            let en = NSEntityDescription.entity(forEntityName: "Product", in: DatabaseController.getContext())
            let batchUpdateRequest = NSBatchUpdateRequest(entity: en!)
            
            batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
            
//            productData?.amount = (productData?.amount)! - Int16(amountField.text!)!
            
            productData?.name = nameField.text
            productData?.price = Double(priceField.text!)!
            productData?.amount = Int16(amountField.text!)!
            productData?.imageUrl = imageField.text
            
            let data = try? Data(contentsOf: URL(string: (productData?.imageUrl)!)!)
            productData?.image = data as NSData?
            
            batchUpdateRequest.predicate = NSPredicate(format: "name = %@", (oldName)!)
            
            batchUpdateRequest.propertiesToUpdate = ["name": (productData?.name)!]
            batchUpdateRequest.propertiesToUpdate = ["amount": productData?.amount ?? 0]
            batchUpdateRequest.propertiesToUpdate = ["price": productData?.price ?? 0]
            batchUpdateRequest.propertiesToUpdate = ["imageUrl": (productData?.imageUrl)!]
            
            try DatabaseController.getContext().execute(batchUpdateRequest)
            
            DatabaseController.saveContext()
            
            myProtocol?.updateProductInViewTable(prodObj: productData!, indexPath: indexPath!)
        }
        catch{
            
        }
        
//        myProtocol?.updateProductInViewTable(prodObj: productData!, indexPath: indexPath!)
        
        _ = navigationController?.popViewController(animated: true)
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
