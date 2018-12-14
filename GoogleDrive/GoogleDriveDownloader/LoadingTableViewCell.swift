//
//  LoadingTableViewCell.swift
//  GoogleDriveDownloader
//
//  Created by Nikhil Modi on 12/14/18.
//  Copyright © 2018 Bá Anh Nguyễn. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
