//
//  MyMovieListVC.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/25/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit

class MyMovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var myMoviesTableViewObj: UITableView!
    
    let defaultImageArray = ["posternf.png","pearl.jpg","gitcat.jpg"]
   
    var mymovies = [
        PlistStuff2.MyMovie(name: "Initialized Movie - Bug - delete me!", year: "", type: "", imdb: "", poster: "", comments: "")
    ]
//    var mymoviesSorted = [
//        PlistStuff2.MyMovie(name: "", year: "", type: "", imdb: "", poster: "")
//    ]
    
    let cellID = "cellID"
    
    //.. instantiate plist class
    let myPlist = PlistStuff2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //..tableView.rowHeight = 40
        myMoviesTableViewObj.rowHeight = 200
        //myMoviesTableViewObj.separatorColor = UIColor.blue

        // Do any additional setup after loading the view.
       
        myMoviesTableViewObj.dataSource = self
        myMoviesTableViewObj.delegate = self
        
        //.. try to load existing plist... if it doesn't exist, "save"/create it
        do {
            //.. try to load
            let dictionaryload = try myPlist.loadPropertyList()
            mymovies = dictionaryload
        
            } catch {
                    //.. if not loaded (ie. not found bc it's new), try to save a new one
                    do {
                        var dictionaryInitSave = try myPlist.savePropertyList(mymovies)
                        } catch {
                            print("..tried to save a 'new' plist but it didn't work")
                        }
                    print(error)
                    print(".. tried to load an existing plist but it didn't load or wasn't there")
            }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //.. try to load existing plist... if it doesn't exist, "save"/create it
        do {
            //.. try to load
            let dictionaryload2 = try myPlist.loadPropertyList()
            mymovies = dictionaryload2
            print("****** mymovies = \(mymovies)")
        
            } catch {
                    //.. if not loaded (ie. not found bc it's new), try to save a new one
                    do {
                        var dictionaryInitSave = try myPlist.savePropertyList(mymovies)
                        } catch {
                            print("..tried to save a 'new' plist but it didn't work")
                        }
                    print(error)
                    print(".. tried to load an existing plist but it didn't load or wasn't there")
            }
        self.myMoviesTableViewObj.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mymovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MyMoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell2") as! MyMoviesTableViewCell
            
            if (cell == nil ) {
                //cell = UITableViewCell(style: UITableViewCell.CellStyle.default,
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: cellID) as! MyMoviesTableViewCell
                }

        mymovies = mymovies.sorted { $0.name < $1.name }
        
//        let mmRow = mymoviesSorted[indexPath.row]
        let mmRow = mymovies[indexPath.row]
                
        cell.myMovieName?.text = mmRow.name
        cell.myMovieYear?.text = mmRow.year
        cell.myMovieType?.text = mmRow.type
        cell.myMovieComments?.text = mmRow.comments
        
        print("****************** myMovieComments = \(mmRow.comments)")
            
//.. if using a dictionary instead
//        var key = Array(self.movieDictionary8.keys)[indexPath.row]
//        var value = Array(self.movieDictionary8.values)[indexPath.row]
//        cell.mainText?.text = key
//        cell.subText?.text = value.mYear
//        let url = value.mPoster
        
        let url = mmRow.poster
        var myImage = UIImage(named: defaultImageArray[0])
        
        if url == "" {
            myImage = UIImage(named: defaultImageArray[0])
        } else {
            let imageURL = URL(string: url)
            if let imageData = try? Data(contentsOf: imageURL!) {
               
                myImage = UIImage(data: imageData)
                //print(myImage)
                DispatchQueue.main.async {
                    return myImage
                }
            } else {
                //myImage = UIImage(named: defaultImageArray[0])
                myImage = UIImage(named: "posternotfound.JPG")
            }
        }
     
        //.. this is referenced in TableViewCell.swift; if you just use cell.imageView?.image (commented out line below), the pictures just "default" to whatever size they come in as
        cell.myMovieImage.image = myImage
        //cell.imageView?.image = myImage
       
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //********* maybe use same type of code in MovieDetailVC
        var mmRowSelected = mymovies[indexPath.row]
        let movieNameSelected = mmRowSelected.name
        //var movieYearSelected = mmRowSelected.year
        let movieCommentsSelected = mmRowSelected.comments
        
        let alert = UIAlertController(title: "Your Choice", message: "\(movieNameSelected)", preferredStyle: .alert)

//       alert.addTextField(configurationHandler: {(textField) in                textField.placeholder = "Your Comments here..."
//           //textField.isSecureTextEntry = true
//       })
        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "Enter new comments here..."
            //textField.isSecureTextEntry = true
        })

        //.. defines Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
        })
    
       //.. defines OK button
       let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
               //.. called savedText, which represents the first text field (note the index value of 0) on the alert controller. If you add more than one text field to an alert controller, you’ll need to define additional constants to represent those other text fields

                let savedText = alert.textFields![0] as UITextField
        
//                let savedText2: String  = savedText.text ?? ""
//
//                //.. save the year from the movie
//                let savedYear = String(movieValueSelected.prefix(4))
            
//                self.mymovies[indexPath.row].year = ("\(savedYear) - \(savedText2)")
                self.mymovies[indexPath.row].comments = savedText.text ?? movieCommentsSelected
                
                //.. save the plist
                do {
                    try self.myPlist.savePropertyList(self.mymovies)
                    //try self.myPlist.savePropertyList(self.movieDictionary)
                    self.myMoviesTableViewObj.reloadData()
                } catch {
                    print("no way... not happening...")
                }
           })

               //..adds the button to the alert controller and next line presents or displays the alert controller
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true , completion: nil)
        }
    

}
