//
//  NewsTableViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class NewsTableViewController: UIViewController {
    
    private let CellIdentifier = "NewsCell"
    private let segueIdentifier = "Show News Details"
    
    private var newsList = [NewsObject]()
    private var isMenuDisplayed = false
    private let menuTableViewHelper = MenuTableViewHelper()
    private let newsTableViewDelegate = NewsTableViewDelegate()

    @IBOutlet weak var menuTableViewLeadingConstarint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTableViewLeadingConstarint.constant = -30 - menuTableView.frame.width
        isMenuDisplayed = false
    }
}

//MARK: - Table View Data Source
extension NewsTableViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError(Values.invalid_indexpath.localised)
        }
        
        let news = newsList[indexPath.row]
        cell.configureCell(news: news)
        cell.newsImageView.layoutSubviews()
        
        return cell
    }
}

//MARK: - Menu Table View Delegate
extension NewsTableViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let source = menuTableView.cellForRow(at: indexPath)?.textLabel?.text {
            
            switch source {
            case Values.logout.localised :
                saveDefaultUser(emailId: nil, password: nil)
                navigationController?.popToRootViewController(animated: true)
                
            default:
                tableView.deselectRow(at: indexPath, animated: true)
                loadNews(source: source )
                newsTableView.reloadData()
                showMenu()
            }
        } else {
            createAlert(title: Values.error.localised, message: Values.source_not_found.localised, hasCancelAction: false)
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

}


// MARK: - Navigation
extension NewsTableViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let cell = sender as? NewsTableViewCell else {
            return
        }
        let identifier = segue.identifier ?? ""
        switch identifier{
        case segueIdentifier:
            guard let destinationViewController = segue.destination as? NewsViewController else{
                
                return
            }
            if let indexPath = newsTableView.indexPath(for: cell){
                destinationViewController.news = newsList[indexPath.row]
            }
        default:
            print(Values.defaultValue.localised)
        }
    }
}

//MARK: - @IBAction Methods
extension NewsTableViewController {
    @IBAction func onMenuIconTapped(_ sender: UIBarButtonItem) {
       showMenu()
    }
}

//MARK: - Custom methods
extension NewsTableViewController {
    
    /// handler is used for parsing the data received from the URL
    ///
    /// - Parameters:
    ///   - response: json response from the server
    ///   - error: any error that occured due to the device
    @objc func handler(response: [String : Any]?,error:  Error?) {
        if let error = error {
            print(error)
            createAlert(title: Values.error.rawValue.localized() , message: error.localizedDescription, hasCancelAction: false)
            updateViews()
            return
        }
        if let response = response{
            guard let newsArticles = response[JsonKeys.articles.rawValue] as? [[String:Any]] else {
                createAlert(title: Values.error.rawValue.localized() , message: String(describing : response), hasCancelAction: false)
                updateViews()
                return
            }
            newsList = [NewsObject]()
            for newsDetails in newsArticles {
                if let news = NewsObject(json : newsDetails){
                    self.newsList.append(news)
                    updateViews()
                }
            }
        } else {
             createAlert(title: Values.error.rawValue.localized() , message: Values.invalidData.localised, hasCancelAction: false)
            updateViews()
            return
        }
    }
    
    // Method to update the tableView after loading 
    private func updateViews(){
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    /// Method for loading the news from Web
    private func loadNews(source : String){
        activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendRequest(source: source, completion: self.handler(response:error:))
        
    }
    
    // Method to show and hide the menu
    private func showMenu(){
        if isMenuDisplayed {
            menuTableViewLeadingConstarint.constant = -20 - menuTableView.frame.width
        } else {
            view.bringSubview(toFront: menuTableView)
            menuTableViewLeadingConstarint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        } )
        
        isMenuDisplayed = !isMenuDisplayed
    }
    
    // Method for loading views
    private func setupView(){
        
        loadNews(source: NewsCategory.topnews.rawValue)
        newsTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.dataSource = menuTableViewHelper
        newsTableView.delegate = newsTableViewDelegate
        
        menuTableView.layer.shadowOffset = CGSize(width: 5, height: view.frame.height)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "background-blue-shadow-1") )
        imageView.contentMode = .scaleAspectFill
        menuTableView.backgroundView = imageView
       
        // Set the background color to match better
        newsTableView.backgroundColor = UIColor(red:Theme.red.rawValue/255.0,green:Theme.green.rawValue/255.0,blue:Theme.blue.rawValue/255.0, alpha: 0.75)
        
        view.bringSubview(toFront: activityIndicator)
        view.bringSubview(toFront: menuTableView)
        
    }
}
