//
//  FeedViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit
import FeedKit

var feedURL = URL(string: "https://www.buzzfeed.com/world.xml")!
let parser = FeedParser(URL: feedURL)

class FeedPostsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedDescriptionLabel: UILabel!
    @IBOutlet weak var feedTableView: UITableView!
    
    //MARK: Properties
    var parser = FeedParser(URL: feedURL)
    var rssFeed: RSSFeed?
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableViews()
        
        parser = FeedParser(URL: feedURL)
        parseRSS()
    }
    
    //MARK: Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}


//MARK: - Functions
extension FeedPostsViewController {
    func parseRSS() {
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            switch result {
            case .success(let feed):
                // Grab the parsed feed directly as an optional rss feed object
                self.rssFeed = feed.rssFeed
                
                // Then back to the Main thread to update the UI.
                DispatchQueue.main.async {
                    self.feedTitleLabel.text = self.rssFeed?.title
                    self.feedDescriptionLabel.text = self.rssFeed?.description
                    self.feedTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


//MARK: - Table View
extension FeedPostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableViews() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeed?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedPostsTableViewCell
        
        let item = rssFeed!.items?[indexPath.row]
        
        cell.feedTitle.text = item?.title
        cell.feedDescription.text = item?.description
        
        //Assign Image from parsed RSS Feed
        guard let imageURL = URL(string: (item?.media?.mediaThumbnails?.first?.attributes?.url) ?? "") else { return cell }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                
                cell.feedImage.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = rssFeed!.items?[indexPath.row]
        
        if let url = URL(string: item?.link ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
