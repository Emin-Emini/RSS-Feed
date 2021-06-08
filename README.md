# RSS-Feed

## Overview
[Description](#description)

[Going Deep](#going-deep)

## Description
**This project is created as a technical interview task assignment.**

Purpose of this assignment is to create a RSS feed reader app. The app has following functionalities:
1. Screen or modal where user can input RSS feed URL
2. Screen where user can see added RSS feeds
a. Each RSS feed presentation should include RSS feed name, Image, description.
3. User can add/remove RSS feeds
4. User can select RSS feed and screen with RSS feed items should be presented
a. Each RSS feed item presentation should include image, title, description.
5. When user select RSS item, it opens up in WebView or device browser


## Going Deep
### Required Tasks
All of the requirements mentioned above are done.

**1. Screen or modal where user can input RSS feed URL**
in code can be found as `AddNewFeedViewController`

**2. Screen where user can see added RSS feeds** in code can be found as `FeedListViewController`. Each cell of the added feed is in `FeedListTableViewCell`.

**3. User can add/remove RSS feeds**
User can add new RSS Feed through `addNewFeedList()` UIButton (visually represented as **Plus** button on bottom right corner in the first screen). The button will send user to `AddNewFeedViewController` where he/she can add the RSS Feed they want to subscribe. (Note: The added RSS Feeds are stored in `Core Data`)
```
    @IBAction private func addNewFeedList(_ sender: Any) {
        if let addFeedViewController = storyboard?.instantiateViewController(identifier: "AddNewFeedViewController") as? AddNewFeedViewController {
            addFeedViewController.actionDelegate = self
            addFeedViewController.modalPresentationStyle = .overCurrentContext
            present(addFeedViewController, animated: true)
        }
    }
```
As for removing RSS Feeds, user can remove them by sliding left on each cell. The code for removing each subscribed (added) RSS Feed can be found in `TableView` delegate methods in `FeedListViewController`.
```
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(feedList[indexPath.row])
        feedList.remove(at: indexPath.row)
        do {
            try managedContext.save()
        } catch _ {
        }
        
        checkIfListIsEmpty()
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
```
**4. User can select RSS feed and screen with RSS feed items should be presented.** This part of code can be found in `FeedPostsViewController`. Each cell of the posts from the feed are in `FeedPostsTableViewCell`.

**5. When user select RSS item, it opens up in WebView or device browser**
When user taps on each cell of the post, it will get the URL from the post and automatically opens the post on Safari browser.
```
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = rssFeed!.items?[indexPath.row]
        
        if let url = URL(string: item?.link ?? "") {
            UIApplication.shared.open(url)
        }
    }
```

### Used Libraries
In this task I had to use a third-party library for parsin *RSS Feed* from URL. I tried few libraries but one that seemed for me easiest to implement was <a href="https://github.com/nmdias/FeedKit">Feed Kit</a>. Also, it was most recently updated compared to other libraries I found.

### Optional Tasks

1. User should be able to turn on notifications for when new feed items are available for subscribed RSS feeds.

As per receiving notifications, it cannot be generated from a website. If we have a backend server from which we are getting some data, the backend server can generate the push when a new article is served in that website. So, the backend server needs to listen to the RSS feeds as well.

I found some third-party techs, but unfortunatelly I couldn't find a way to implement it per each RSS URL added in app. The way they worked was: You go to their website, and add the RSS Feed URL in their website, then you will receive notifications for the added RSS Feed in their server.

I believe with more research and work this task can be finished too.
