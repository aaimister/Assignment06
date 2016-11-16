//
//  SnapData.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import Foundation
import UIKit

class SnapData {
    
    public enum Status: String {
        case Delivered, Opened, Viewed, Tapped
    }
    
    private static let selfies = [
        #imageLiteral(resourceName: "selfie1"), #imageLiteral(resourceName: "selfie2"), #imageLiteral(resourceName: "selfie3"), #imageLiteral(resourceName: "selfie4"), #imageLiteral(resourceName: "selfie5"), #imageLiteral(resourceName: "selfie6"), #imageLiteral(resourceName: "selfie7"), #imageLiteral(resourceName: "selfie8"), #imageLiteral(resourceName: "selfie9"), #imageLiteral(resourceName: "selfie10"), #imageLiteral(resourceName: "selfie11"),
        #imageLiteral(resourceName: "selfie12"), #imageLiteral(resourceName: "selfie13"), #imageLiteral(resourceName: "selfie14"), #imageLiteral(resourceName: "selfie15"), #imageLiteral(resourceName: "selfie16"), #imageLiteral(resourceName: "selfie17"), #imageLiteral(resourceName: "selfie18"), #imageLiteral(resourceName: "selfie19"), #imageLiteral(resourceName: "selfie20"), #imageLiteral(resourceName: "selfie21"),
        #imageLiteral(resourceName: "selfie22"), #imageLiteral(resourceName: "selfie23"), #imageLiteral(resourceName: "selfie24"), #imageLiteral(resourceName: "selfie25"), #imageLiteral(resourceName: "selfie26"), #imageLiteral(resourceName: "selfie27"), #imageLiteral(resourceName: "selfie28"), #imageLiteral(resourceName: "selfie29"), #imageLiteral(resourceName: "selfie30")
    ]
    
    private static let firstNameList = [
        "Karry", "Lavina", "Tiara", "Mandy", "Paulina", "Keli", "Oliva", "Nguyet", "Gertrud", "Dorinda", "Terica", "Magali",
        "Andera", "Donald", "Alease", "Marine", "Regine", "Eloisa", "Hillary", "Alysia", "Sadie", "Augustina", "Ione", "Mimi",
        "Gigi", "Evalyn", "Christy", "Minda", "Aaron", "Jannet"
    ]
    
    private static let lastNameList = [
        "Dalton", "Wiggins", "Merritt", "Gamble", "Sanford", "Lin", "Baxter", "Salas", "Mullins", "Duarte", "Middleton", "Chan",
        "Holden", "Morse", "Beasley", "Curtis", "Wallace", "Stevens", "Perez", "Cooke", "Richard", "Garrison", "Williams",
        "Deleon", "Gill", "Mcconnel", "Kroupa", "Clinton", "Trump", "Owens"
    ]
    
    private var name: String
    private var image: UIImage
    private var status: String?
    private var consumed: Bool
    private var timeStamp: String?
    private let dateFormatter: DateFormatter
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
        consumed = false
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        setStatus(.Delivered)
    }
    
    convenience init() {
        let n = "\(SnapData.firstNameList[Int(arc4random_uniform(UInt32(SnapData.firstNameList.count)))]) \(SnapData.lastNameList[Int(arc4random_uniform(UInt32(SnapData.lastNameList.count)))])"
        let i = SnapData.selfies[Int(arc4random_uniform(UInt32(SnapData.selfies.count)))]
        self.init(name: n, image: i)
    }
    
    private func generateStatus(_ status: Status) -> String {
        switch(status) {
        case .Delivered:
            timeStamp = dateFormatter.string(from: Date())
            return "Delivered \(timeStamp!)"
        case .Opened:
            timeStamp = dateFormatter.string(from: Date())
            return "Opened \(timeStamp!)"
        case .Viewed:
            consumed = true
            return "Viewed \(timeStamp!)"
        case .Tapped:
            return "Double tap to reply"
        default:
            return "Unknown"
        }
    }
    
    func getName() -> String {
        return name
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func isConsumed() -> Bool {
        return consumed
    }
    
    func getStatus() -> String {
        return status ?? "Unknown"
    }
    
    func setStatus(_ status: Status) {
        self.status = generateStatus(status)
    }

}
