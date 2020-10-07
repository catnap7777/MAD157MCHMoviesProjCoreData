//
//  PlistStuff2.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/26/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import Foundation

class PlistStuff2 {
    
    struct MyMovie: Codable {
        var name: String
        var year: String
        var type: String
        var imdb: String
        var poster: String
        var comments: String
    }
    
    var mymovies = [
        MyMovie(name: "", year: "", type: "", imdb: "", poster: "", comments: "")
    ]
  
//************************************************************************************
//.. example from stackoverflow - https://stackoverflow.com/questions/48677102/how-to-save-array-of-tuples-in-userdefaults
//    let bookies = [
//        Bookie(name: "mbro12", nameId: "id1", bookId: "b1", picture: Data()),
//        Bookie(name: "mayoff", nameId: "id2", bookId: "b2", picture: Data())
//    ]
//    let bookiesData = try! PropertyListEncoder().encode(bookies)
//    UserDefaults.standard.set(bookiesData, forKey: "bookies")

//    let fetchedData = UserDefaults.standard.data(forKey: "bookies")!
//    let fetchedBookies = try! PropertyListDecoder().decode([Bookie].self, from: fetchedData)
//    print(fetchedBookies)
//************************************************************************************
    
    var plistURL : URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("dictionaryKam2.plist")
        //.. this "file" (above) gets hidden in a really long complicated directory -  I used the error msg, terminal, and Atom to find directory/file and to open file to see .xml with movie "records"
        //.. Example of directory where plist is stored (not always the same) =
        //..   /Users/kam/Library/Developer/CoreSimulator/Devices/546DFFAC-C0F5-4FC6-9702-5D72DF9B8133/data/Containers/Data/Application/3AFC5C2A-7302-4734-A9AE-2DB6F32781F8/Documents/dictionaryKam1.plist
        //.. Don't need to use Atom.  Just go into finder, hit shift+command+G, go to Library ~/Library/, search for "items matching text" (dictionaryKam2) - see saved search - I don't know how I did that
    }

    
    func savePropertyList(_ plist: Any) throws
    {
        mymovies = plist as! [PlistStuff2.MyMovie]
        let moviesData = try! PropertyListEncoder().encode(mymovies)
        //print("%%%% PlistStuff2 savePropertyList - moviesData = \(moviesData)")
        
        //.. OLD way to save when using simple dictionary [key:value] for plist
        //print("..in savePropertyList - plist = \(plist)")
//        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
//        print("..plistData = \(plistData)")
        
        do {
            //try plistData.write(to: plistURL)
            try moviesData.write(to: plistURL)
            } catch {
                print("!!!!!!! ..plist write FAILED..")
            }
    }

    func loadPropertyList() throws -> [MyMovie]
    {
        //.. stackoverflow EXAMPLE from above
        //let fetchedData = UserDefaults.standard.data(forKey: "bookies")!
//        let fetchedBookies = try! PropertyListDecoder().decode([Bookie].self, from: fetchedData)
//        print(fetchedBookies)
        
        //.. I should probably put erro handling in here
        let data = try Data(contentsOf: plistURL)
        //print("%%%% PlistStuff2 loadPropertyList - data = \(data)")
        let plist = try PropertyListDecoder().decode([MyMovie].self, from: data)
        //print("%%%% PlistStuff2 loadPropertyList - plist = \(plist)")
        

        //.. OLD code from before when using simple dictionary [key:value] as plist
//        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String:String] else {
//            print(".. plist load FAILED..")
//            return [:]
//        }
        
        //print("!!!!!..movie plist currently has: \(plist)")
        return plist
    }


}

