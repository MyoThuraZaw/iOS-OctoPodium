//
//  LanguageCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell, NibReusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageImageView: LanguageImageView!
    
    var language: String? {
        didSet {
            let lang = language ?? ""
            nameLabel.text = lang
            languageImageView.render(with: lang)
        }
    }
}
