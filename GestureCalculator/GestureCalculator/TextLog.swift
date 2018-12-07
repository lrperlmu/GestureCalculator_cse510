//
//  TextLog.swift
//  GestureCalculator
//
//  Created by Bindita Chaudhuri on 12/4/18.
//  Copyright © 2018 Bindita Chaudhuri. All rights reserved.
//

import Foundation
struct TextLog: TextOutputStream {
    
    /// Appends the given string to the stream.
    mutating func write(_ string: String) {
        //let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        //let documentDirectoryPath = paths.first!
        //let log = documentDirectoryPath.appendingPathComponent("log.txt")
        let log = URL(string: "/Users/binditachaudhuri/Desktop/log.txt")!
        
        do {
            let handle = try FileHandle(forWritingTo: log)
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            print(error.localizedDescription)
            do {
                try string.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }        
    }
}
