//
//  StartViewController.swift
//  AppShop
//
//  Created by Admin on 13/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var pathToCsvFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var alterAction = UIAlertAction()
    
    func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.isEmpty)!
        {
            alterAction.isEnabled = false
        }
        else
        {
            alterAction.isEnabled = true
        }
    }
    
    @IBAction func TapLogin(_ sender: Any) {
        let altMessage = UIAlertController(title: "Login", message: "Introduce yourself", preferredStyle: .alert)
        
        altMessage.addTextField(configurationHandler: {(textField) -> Void in
            textField.text = "John"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        })
        
        alterAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "FirstSegueID", sender: nil)
        })
        
        altMessage.addAction(alterAction)
        
        self.present(altMessage, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FirstSegueID"
        {
            let barViewController = segue.destination as? UITabBarController
            let storeNavigatCotroller = barViewController?.viewControllers?[0] as! UINavigationController
            let storeController = storeNavigatCotroller.topViewController as! StoreTableViewController
            
            let adminNavigatCotroller = barViewController?.viewControllers?[1] as! UINavigationController
            let adminController = adminNavigatCotroller.topViewController as! AdminTableViewController
            adminController.myProtocol = storeController
            adminController.myProductObjProtocol = storeController
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
