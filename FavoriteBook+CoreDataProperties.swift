//
//  FavoriteBook+CoreDataProperties.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//
//

import Foundation
import CoreData


extension FavoriteBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBook> {
        return NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
    }

    @NSManaged public var authors: String?
    @NSManaged public var contents: String?
    @NSManaged public var datetime: Date?
    @NSManaged public var id: String?
    @NSManaged public var isbn: String?
    @NSManaged public var price: Int32
    @NSManaged public var publisher: String?
    @NSManaged public var salePrice: Int32
    @NSManaged public var status: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var translators: String?
    @NSManaged public var url: String?

}

extension FavoriteBook : Identifiable {

}
