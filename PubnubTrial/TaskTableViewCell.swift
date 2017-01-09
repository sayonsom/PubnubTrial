//
//  TaskTableViewCell.swift
//  Pods
//
//  Created by Sayonsom Chanda on 1/6/17.
//
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet var typeOfMood: UILabel!
    @IBOutlet var dayOfEndDate: UILabel!
    @IBOutlet var monthOfEndDate: UILabel!
    @IBOutlet var taskName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
