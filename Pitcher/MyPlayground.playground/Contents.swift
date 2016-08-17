//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

if let path = NSBundle.mainBundle().pathForResource("temp", ofType: "strings"){
do {
    var text = try String(contentsOfFile: path)
    print(text)
}
catch{
    
}
}

