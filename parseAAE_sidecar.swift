// Playground - noun: a place where people can play

import UIKit
import Foundation

let url: NSURL! = NSBundle.mainBundle().URLForResource("adjusted", withExtension: "AAE")

var myDict: NSDictionary?
if let path = url {
 myDict = NSDictionary(contentsOfURL: path)
 println(myDict)
}
if let dict = myDict {
 // Use your dict here
 println(dict["adjustmentData"])
 let data : NSData = dict["adjustmentData"] as NSData!
 println(data)
 let data2 = NSPropertyListSerialization.propertyListFromData(data, mutabilityOption: nil, format: nil, errorDescription: nil) as NSObject
 println(data2)
}