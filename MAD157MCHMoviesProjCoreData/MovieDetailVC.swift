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
    
    //.. used if calling function to set var/lable
    //var testString = "Test String"
    
    var movieTitle = ""
    var movieYear = ""
    var movieType = ""
    var movieIMDB = ""
    var moviePoster = ""
    var movieComments = ""
    
    let defaultImageArray = ["posternf.png"]
    
    //.. PLIST
    //.. NOTE: complex dictionary objects (objects with key:tuple - called CFType) cannot be saved in a plist
    //..  Old movieDictionary is for the plist; not using anymore. Using mymovies structure.
    //var movieDictionary: [String : String] = [:]
    var mymovies = [
        PlistStuff2.MyMovie(name: "", year: "", type: "", imdb: "", poster: "", comments: "")
    ]
    
    //.. instantiate plist class
    let myPlist = PlistStuff2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        mymovies.removeAll()
        
        //testLabel.text = testString
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
        
//        do {
//            mymovies = try myPlist.loadPropertyList()
//            } catch {
//                print(error)
//                print("$$$ MovieDetailVC.. nope... did NOT load plist")
//            }
//
        movieComments = commentsText.text
        
//        mymovies.append(PlistStuff2.MyMovie(name: movieTitle, year: movieYear, type: movieType, imdb: movieIMDB, poster: moviePoster, comments: movieComments))
//
//        //.. save the plist
//        do {
//            try myPlist.savePropertyList(mymovies)
//            print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
//            //.. if it saved, show an alert
//            let alert2 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
//            let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//                //Just dismiss the action sheet
//                })
//            alert2.addAction(okAction2)
//            self.present(alert2, animated: true, completion: nil )
//
//        } catch {
//            print("$$$ MovieDetailVC ..tried to save plist but it didn't work")
//            print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
//        }
        
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
            listArray.append(newEntity)
            
            print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
            //.. if it saved, show an alert
            let alert2 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
                })
            alert2.addAction(okAction2)
            self.present(alert2, animated: true, completion: nil )
        } catch{
            print ("Error saving data")
            print("$$$ MovieDetailVC ..tried to save plist but it didn't work")
            print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
        }
        
        print("$$$$$$ newEntity = \(newEntity)")
        
//            dispDataHere.text?.removeAll()
//            enterGuitarDescription.text?.removeAll()
//            //.. refetch data to redisplay
//            fetchData()
//        }
            
            //.. want to save "new" movie if it doesn't already exist (name/year/type)
            
//            for item in mymovies {
//                print("...inside the for loop --- item = \(item)")
        
            
//                    print("^^^^^^^ duplicate movie....... --- item.imdb = \(item.imdb)  movieIMDB = \(movieIMDB)")
//                    //.. movie already in mymovies - so do nothing
//                    //.. if it did not save, show an alert
//                    let alert1 = UIAlertController(title: "Message", message: "Movie Already Exists in My Movies", preferredStyle: .alert)
//                    let okAction1 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//                        //Just dismiss the action sheet
//                        })
//                    alert1.addAction(okAction1)
//                    self.present(alert1, animated: true, completion: nil )
//                } else {
//                    print("^^^^^^^ insert movie........")
//                    //.. insert new movie
//                    mymovies.append(PlistStuff2.MyMovie(name: movieTitle, year: movieYear, type: movieType, imdb: movieIMDB, poster: moviePoster))
//                    //.. save the plist
//                    do {
//                        try myPlist.savePropertyList(mymovies)
//                        print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
//                    } catch {
//                         print("$$$ MovieDetailVC ..tried to save plist but it didn't work")
//                        print("$$$ MovieDetailVC - mymovies plist save attempt - \(mymovies)")
//                    }
//                    //.. if it saved, show an alert
//                    let alert2 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
//                    let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//                        //Just dismiss the action sheet
//                        })
//                    alert2.addAction(okAction2)
//                    self.present(alert2, animated: true, completion: nil )
//
//                }
////            }
//
//        } catch {
//            print(error)
//            print("$$$ MovieDetailVC.. nope... did NOT save/update plist with 'new' movie... why not?")
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
         return newText.count < 10
    }
          
    
}
