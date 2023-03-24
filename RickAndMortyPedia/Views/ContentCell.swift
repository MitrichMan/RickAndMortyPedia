//
//  ContentCell.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 24.03.2023.
//

import UIKit

class ContentCell: UITableViewCell {

    @IBOutlet var contentNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
