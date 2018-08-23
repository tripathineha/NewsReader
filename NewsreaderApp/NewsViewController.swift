//
//  NewsViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class NewsViewController: UIViewController {
    
    private let reuseIdentifier = "CommentCell"
    
    var news : NewsObject!
    private var isNewsLiked = true
    var like : Like? = nil
    
    @IBOutlet weak var webActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    
    lazy var fetchedResultsController : NSFetchedResultsController<Comment> = {
        
        //set the fetch request for comment
        let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
        
        // get the likes for the current url
        like = DataManager.sharedInstance.likeNews(liked: false, newsLink: news.url)
        
        if let like = like  {
            let predicate = NSPredicate(format: "%K == %@",CommentEntity.commentOn.rawValue, like)
            fetchRequest.predicate = predicate
        }
       
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: CommentEntity.commentedAt.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                  managedObjectContext: DataManager.sharedInstance.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        do{
            try fetchedResultsController.performFetch()
            
        }catch {
            let fetchError = error as Error
            createAlert(title: "Error", message: fetchError.localizedDescription, hasCancelAction: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK :- UITableViewDataSource
extension NewsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell else {
            fatalError(Values.cell_not_initialised.localised)
        }
        let comment = fetchedResultsController.object(at: indexPath)
        cell.configureCell(comment : comment)
        return cell
    }
}

//MARK: - Table View Delegate
extension NewsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(UIResponderStandardEditActions.delete(_:)) {
            DataManager.sharedInstance.deleteComment(object: fetchedResultsController.object(at: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - Fetched Result Controller Delegate
extension NewsViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        commentTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        commentTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                commentTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                commentTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                guard let cell = commentTableView.cellForRow(at: indexPath) as? CommentTableViewCell else {
                    fatalError(Values.invalid_indexpath.localised)
                }
                if let comment = controller.object(at: indexPath) as? Comment{
                    cell.configureCell(comment : comment)
                }
            }
        case .move:
            break
        }
    }
}

//MARK: - WKNavigation Delegate
extension NewsViewController : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webActivityIndicator.stopAnimating()
    }
    
}

//MARK: - @IBAction methods
extension NewsViewController{
    
    @IBAction func onLikeTapped(_ sender: UIButton) {
        // like the current news
        like = DataManager.sharedInstance.likeNews(liked: true, newsLink: news.url)
        isNewsLiked = !isNewsLiked
        // set up the like button and likes label
        setUpLike(like: like )
    }
    
    // Save the comment after validation
    @IBAction func onCommentTapped(_ sender: UIButton) {
        guard let comment = commentTextView.text ,
            comment.count > 0 else {
                createAlert(title: Values.alert.localised, message: Values.comment_empty.localised, hasCancelAction: false)
                return
        }
        
        commentTextView.text = ""
        let date = NSDate()
        self.like = DataManager.sharedInstance.likeNews(liked: false, newsLink: news.url)
        if let like = like,
            let user = DataManager.sharedInstance.user {
            let valueDictionary : [String:Any] = [CommentEntity.comment.rawValue : comment,
                                                  CommentEntity.commentedAt.rawValue : date,
                                                  CommentEntity.commentOn.rawValue : like,
                                                  CommentEntity.commentedBy.rawValue : user
            ]
            DataManager.sharedInstance.saveComment(valueDictionary: valueDictionary)
        }
    }
}

//MARK: - Keyboard Handlers

extension NewsViewController {
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        }
    }
    
}

//MARK: - Custom Methods
extension NewsViewController {
    
    private func setupViews(){
        
       // Getting the url for news
        guard let url = URL(string: news.url) else {
            createAlert(title: Values.alert.localised, message: Values.link_couldnt_be_loaded.localised, hasCancelAction: false)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        newsWebView.load(urlRequest)
        
        newsWebView.navigationDelegate = self
        newsWebView.addSubview(webActivityIndicator)
        webActivityIndicator.startAnimating()
        
        like = DataManager.sharedInstance.likeNews(liked: false, newsLink: news.url)
        isNewsLiked = DataManager.sharedInstance.getLike(like:like)
        setUpLike(like: like )
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGray.cgColor
        commentTextView.layer.cornerRadius = 3
        commentTextView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        commentTableView.backgroundColor = UIColor(red:Theme.red.rawValue/255.0,green:Theme.green.rawValue/255.0,blue:Theme.blue.rawValue/255.0, alpha: 0.75)
    }
    
     // set up the like button and likes label
    private func setUpLike(like : Like?){
        if let like = like {
            numberOfLikesLabel.text = String(like.like) + Values.likes.localised
        }
        
        if isNewsLiked {
            likeButton.setTitle(Values.unlike.localised, for: .normal)
            likeButton.tintColor = UIColor.blue
        } else {
            likeButton.setTitle(Values.like.localised, for: .normal)
            likeButton.tintColor = UIColor.black
        }
    }
}
