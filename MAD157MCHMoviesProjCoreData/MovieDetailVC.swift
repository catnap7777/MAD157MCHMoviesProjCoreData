//
//  MovieDetailVC.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/22/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import CoreData

//.. Detail movie info for one of the movies that was "selected" (clicked on)
//..   in the tableView of the movies that came back from the API search
class MovieDetailVC: UIViewController {

    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var imdbLabel: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var commentsText: UITextView!
    
    var dataManager : NSManagedObjectContext!
    //.. array to hold the database info for loading/saving
    var listArray = [NSManagedObject]()
    
    var movieTitle = ""
    var movieYear = ""
    var movieType = ""
    var movieIMDB = ""
    var moviePoster = ""
    var movieComments = ""
    
    let defaultImageArray = ["posternf.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        movieTitleLabel.text = movieTitle
        yearLabel.text = movieYear
        typeLabel.text = movieType
        imdbLabel.text = movieIMDB
        //posterLabel.text = moviePoster
                
        //        let url = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
        
        //.. value of which was already set from MovieListVC when row was clicked on and segue performed
        //.. NOTE: If the movie is older, it may not have a movie poster.
        //..  If it doesn't, the url will be blank or N/A
        //..  In that case, set the self.detailImage.image = posternotfound.jpg
        let url = moviePoster
        //self.detailImage.image = UIImage(named: defaultImageArray[0])
        self.detailImage.image = UIImage(named: "posternotfound.JPG")
        //.. takes the movie url from moviePoster and call func setImage to place picture on screen
        self.setImage(from: url)
        //  self.imgView.downloadImage(from: url!)
                
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.detailImage.image = image
            }
        }
    }
    
    @IBAction func IMDBButton(_ sender: Any) {
        
        let imdbURL = "https://www.imdb.com/title/" + movieIMDB
        
        if let url = URL(string: imdbURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func saveMyMovieButtonPressed(_ sender: Any) {
        
        listArray.removeAll()
        fetchData()
        
        movieComments = commentsText.text
        print("12391840750375 in saveMyMovieButtonPressed")
        print("movie name = \(movieTitle)  movie imdb = \(movieIMDB)")
        
        var foundFlag = false
        
        for item in listArray {
            if item.value(forKey: "imdb") as! String == movieIMDB {
                //.. it's already in db so do nothing but alert and set foundFlag
                foundFlag = true
                
                let alert2 = UIAlertController(title: "Message", message: "Movie Already Exists in My Movies", preferredStyle: .alert)
                //.. from https://stackoverflow.com/questions/27895886/uialertcontroller-change-font-color
                //.. make text in alert message red
                //alert2.view.tintColor = UIColor.red
                //.. tints whole box red
                alert2.view.backgroundColor = UIColor.red
                //.. to set the "message" in red and "title" in blue
                alert2.setValue(NSAttributedString(string: alert2.message ?? "nope", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                //.. to set the "title" in blue
                alert2.setValue(NSAttributedString(string: alert2.title ?? "nada", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.blue]), forKey: "attributedTitle")
                
                //.. style: .destructive = red "OK" button; .default = black
                let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                    //Just dismiss the action sheet
                })
                alert2.addAction(okAction2)
                self.present(alert2, animated: true, completion: nil )
                print("!@*$&*%*#^%#^ movie already in db - \(movieTitle)")
            }  //.. end if
        } //.. end for
            
        if !foundFlag {
            //.. movie not already found in db
            print("!@*$&*%*#^%#^ trying to insert movie in db - \(movieTitle)")
            //.. insert it into db
            //.. for "Item" table in xcdatamodeld
            let newEntity = NSEntityDescription.insertNewObject(forEntityName:"MyMovieTable", into: dataManager)
            //.. for "about" attribute/field in table "Item" in xcdatamodeld
            newEntity.setValue(movieTitle, forKey: "name")
            newEntity.setValue(movieYear, forKey: "year")
            newEntity.setValue(movieType, forKey: "type")
            newEntity.setValue(movieIMDB, forKey: "imdb")
            newEntity.setValue(moviePoster, forKey: "poster")
            newEntity.setValue(movieComments, forKey: "comments")
            
            do{
                //.. try to save in db
                try self.dataManager.save()
                //.. add new entity to array
                //listArray.append(newEntity)
                
                //.. if it saved, show an alert
                let alert3 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
                let okAction3 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                    //Just dismiss the action sheet
                })
                alert3.addAction(okAction3)
                self.present(alert3, animated: true, completion: nil )
            } catch{
                print ("Error saving data")
                print("$$$ MovieDetailVC ..tried to save coreData but it didn't work")
            }
            
            print("$$$$$$ newEntity = \(newEntity)")
            //fetchData()
            
            foundFlag = false
            
        }  //.. end if
            
        
        
    } //.. end saveMyButtonPressed
    
    //.. read from db - FOR THIS PARTICULAR ONE, IS THERE A WAY TO FETCH ONLY TO SEE IF THE MOVIE (VIA IMDB) IS ALREADY IN THERE OR DO I HAVE TO READ THE WHOLE THING?
    func fetchData() {
        
        //.. setup fetch from "Item" in xcdatamodeld
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
        do {
            //.. try to fetch data
            let result = try dataManager.fetch(fetchRequest)
            //.. set the array equal to the results fetched
            listArray = result as! [NSManagedObject]
            
            //.. for each item in the array, do the following..
            for item in listArray {
                //.. get the value for "name, year, type, imdb, poster, comments" (attribute/field "name", etc. in xcdatamodeld) and set it equal to var product
                //var product = item.value(forKey: "about") as! String
                let myMovieNameRetrieved = item.value(forKey: "name") as! String
                print("====> myMovieNameRetrieved in listArray/CoreData: \(myMovieNameRetrieved)")
            }
            
            } catch {
                print ("Error retrieving data")
            }
            
        }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//         return newText.count < 10
//    }

    
}
