//
//  MDB Mini Project 1 - Match the Members!
//
//  Constants.swift
//  Created by Will Oakley on 9/5/18.
//

import Foundation
import UIKit

class Constants {
    
    static let names = ["Aady Pillai", "Aarushi Agrawal", "Aayush Tyagi", "Abhinav Kejriwal", "Afees Tiamiyu", "Ajay Merchia", "Anand Chandra", "Andres Medrano", "Andrew Santoso", "Anika Bagga", "Anik Gupta", "Anita Shen", "Anjali Thakrar", "Anmol Parande", "Ashwin Aggarwal", "Ashwin Kumar", "Athena Leong", "Austin Davis", "Ayush Kumar", "Brandon David", "Candace Chiang", "Candice Ye","Charles Yang", "Colin Zhou", "Daniel Andrews", "Divya Tadimeti", "DoHyun Cheon", "Eric Kong", "Ethan Wong", "Francis Chalissery", "Geo Morales", "Ian Shen", "Imran Khaliq", "Izzie Lau", "Jacqueline Zhang", "James Jung", "Japjot Singh", "Joey Hejna", "Juliet Kim", "Kanyes Thaker", "Karen Alarcon", "Katniss Lee", "Kayli Jiang", "Kiana Go", "Maggie Yi", "Matthew Locayo", "Max Emerling", "Max Miranda", "Melanie Cooray", "Michael Lin", "Michelle Mao", "Mohit Katyal", "Mudabbir Khan", "Natasha Wong", "Neha Nagabothu", "Nicholas Wang", "Nikhar Arora", "Noah Pepper", "Olivia Li", "Patrick Yin", "Paul Shao", "Radhika Dhomse", "Rini Vasan", "Sai Yandapalli", "Salman Husain", "Samantha Lee", "Shaina Chen", "Sharie Wang", "Shaurya Sanghvi", "Shiv Kushwah", "Shomil Jain", "Shubha Jagannatha", "Shubham Gupta", "Simran Regmi", "Sinjon Santos", "Srujay Korlakunta", "Stephen Jayakar", "Tyler Reinecke", "Vaibhav Gattani", "Varun Jhunjhunwalla", "Victor Sun", "Vidya Ravikumar", "Vineeth Yeevani", "Will Oakley", "Will Vavrik", "Xin Yi Chen", "Yatin Agarwal"]
    
    static func getImageFor(name: String) -> UIImage {
        let noWhitespace = name.components(separatedBy: .whitespaces).joined().lowercased()
        return UIImage(named: noWhitespace)!
    }
}

