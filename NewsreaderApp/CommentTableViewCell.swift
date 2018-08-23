//
//  CommentTableViewCell.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}

//MARK: - @IBAction methods
extension CommentTableViewCell {
    @IBAction func onDeleteButtonTapped(_ sender: UIButton) {
        
        let tableView = getTableView()
        if let indexPath = tableView.indexPath(for: self) {
             tableView.delegate?.tableView?(tableView, performAction: #selector(UIResponderStandardEditActions.delete(_:)), forRowAt: indexPath, withSender: sender)
        }
        
    }
}

//MARK: - custom methods
extension CommentTableViewCell {
    /// Method for configuring the table view cell
    ///
    /// - Parameter news: The Comment NSObject using which the cell will be configured
    func configureCell(comment : Comment) {
        if  let commentingUser = comment.commentedBy,
            let user = DataManager.sharedInstance.user,
            commentingUser == user {
            deleteButton.isHidden = false
        }
        usernameLabel.text = comment.commentedBy?.name
        commentLabel.text = comment.comment
    }
    
    /// return the collection view to which the cell belongs
    ///
    /// - Returns: Get the collection view to which the cell belongs
    private func getTableView() -> UITableView{
        var view : UIView = self
        repeat{
            view = view.superview!
        }while !(view is UITableView)
        let tableView = view as! UITableView
        return tableView
    }
}
