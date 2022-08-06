//
//  Commit+CoreDataClass.swift
//  GithubCommits
//
//  Created by 陳怡安 on 2022/8/2.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
}
