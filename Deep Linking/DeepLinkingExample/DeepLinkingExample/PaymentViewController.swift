//
//  PaymentViewController.swift
//  Rich Notifications
//
//  Created by Atiaa on 2/23/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    var paymentID: String = "1"          // instance property
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text =  "Payment # " + paymentID

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
