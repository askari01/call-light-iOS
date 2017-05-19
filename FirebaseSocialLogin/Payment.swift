//
//  Payment.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 18/05/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
//, CardIOPaymentViewControllerDelegate
class Payment: UIViewController {

    
    
    @IBOutlet weak var lbl_Result: UILabel!
//    
//    @IBAction func startScan(sender: UIButton) {
//        var cardVC = CardIOPaymentViewController(paymentDelegate: self)
//        cardVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
//        
//        present(cardVC!, animated: true) { () -> Void in
//            
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    
//    //MARK: - CardIOPaymentViewControllerDelegate
//    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
//        lbl_Result.text = "Cancel"
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
//        
//        if let cardInformation = cardInfo {
//            lbl_Result.text = "卡号:\(cardInformation.cardNumber)\n+到期:\(cardInformation.expiryYear)年, \(cardInformation.expiryMonth)\n+cvv:\(cardInformation.cvv)"
//        }
//        
//        paymentViewController.dismiss(animated: true, completion: nil)
//        
//    }
}
