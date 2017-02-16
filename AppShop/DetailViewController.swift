//
//  DetailViewController.swift
//  AppShop
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    var productPrice: String?
    var productData: Product?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        productNameLabel.text = productData?.name
        priceField.text = "\(productData!.price)"
        amountField.text = "\(productData!.amount)"
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
