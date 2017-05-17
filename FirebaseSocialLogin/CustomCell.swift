//
//  CustomCell.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 12/05/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalLocation: UILabel!
    @IBOutlet weak var nurseName: UILabel!
    @IBOutlet weak var nurseSpecialityAndType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
