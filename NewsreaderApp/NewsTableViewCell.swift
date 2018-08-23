//
//  NewsTableViewCell.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = UIImage(named: "defaultPhoto")
    }
    
}

extension NewsTableViewCell {
    /// Method for configuring the table view cell
    ///
    /// - Parameter news: The NewsObject using which the cell will be configured
    func configureCell(news : NewsObject) {
        let author = news.author ?? Values.unknown.localised
        newsAuthorLabel.text = author + " | " + news.publishedAt
        newsDescriptionLabel.text = news.newsDescription
        newsTitleLabel.text = news.title
        if let imageUrl = news.imageUrl,
            let url = URL(string: imageUrl){
            newsImageView.imageFromURL(url: url)
        }
        
    }
    
    // Set the views up
    private func setupView(){
        self.backgroundColor = UIColor.clear
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        
        contentView.layer.borderColor = UIColor.black.cgColor
        newsImageView.layer.cornerRadius = 5
        newsImageView.layer.borderColor = UIColor.black.cgColor
        newsImageView.layer.borderWidth = 2
        newsImageView.clipsToBounds = true
        newsAuthorLabel.textColor = UIColor.red
    }
}
