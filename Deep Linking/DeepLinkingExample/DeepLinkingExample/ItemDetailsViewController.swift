//
//  ItemDetailsViewController.swift
//  Rich Notifications
//
//  Created by Atiaa on 2/23/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var itemID: String = "1"
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        itemNumberLabel.text =  "item Details # " + itemID
        // Do any additional setup after loading the view.
    }

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
