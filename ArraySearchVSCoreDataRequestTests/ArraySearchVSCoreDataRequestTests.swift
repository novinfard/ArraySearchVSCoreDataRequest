//
//  ArraySearchVSCoreDataRequestTests.swift
//  ArraySearchVSCoreDataRequestTests
//
//  Created by Soheil on 06/05/2019.
//  Copyright © 2019 Novinfard. All rights reserved.
//

import XCTest
import CoreData
import ArraySearchVSCoreDataRequest

class ArraySearchVSCoreDataRequestTests: BaseModelTest {
	
	func testSearchBySingleRequest() {
		let context = self.container!.viewContext
		
		self.deleteAllEntries(context: context)
		self.addDummyEntries(context: context)
		
		self.measure {
			for _ in 1 ... 100 {
				let searchIndex = String(Int.random(in: 1 ... 1000))

				let fetchRequest: NSFetchRequest<Blog> = Blog.fetchRequest()
				fetchRequest.predicate = NSPredicate(format: "id == %@", searchIndex)

				_ = try! context.fetch(fetchRequest)
			}
			self.report_memory(for: "testSearchBySingleRequest")
		}
	}
	
	func testSearchByArray() {
		let context = self.container!.viewContext
		
		self.deleteAllEntries(context: context)
		self.addDummyEntries(context: context)
		
        self.measure {
		let allFetchRequest: NSFetchRequest<Blog> = Blog.fetchRequest()
		let allBlogs: [Blog]? = try! context.fetch(allFetchRequest)
		
			for _ in 1 ... 100 {
				let searchIndex = String(Int.random(in: 1 ... 1000))
				_ = allBlogs?.first(where: { $0.id == String(searchIndex) })
			}
			self.report_memory(for: "testSearchByArray")
		}
	}
	
    func testSearchByDictionary() {
        let context = self.container!.viewContext
        
        self.deleteAllEntries(context: context)
        self.addDummyEntries(context: context)
        
        self.measure {
            let allFetchRequest: NSFetchRequest<Blog> = Blog.fetchRequest()
            let allBlogs: [Blog]? = try! context.fetch(allFetchRequest)
            var allBlogDict: [String: Blog] = [:]
            allBlogs?.forEach { allBlogDict[$0.id!] = $0 }
        
            for _ in 1 ... 100 {
                let searchIndex = String(Int.random(in: 1 ... 1000))
                _ = allBlogDict[String(searchIndex)]
            }
            self.report_memory(for: "testSearchByDictionary")
        }
    }
    
	private func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
	
	private func addDummyEntries(context: NSManagedObjectContext) {
		for i in 1 ... 1000 {
			let blog = Blog(context: context)
			blog.id = "\(i)"
			blog.title = self.randomString(length: 100)
			blog.intro = self.randomString(length: 1000)
			blog.content = self.randomString(length: 1000)
		}
	}
	
	private func deleteAllEntries(context: NSManagedObjectContext) {
		let allFetchRequest: NSFetchRequest<Blog> = Blog.fetchRequest()
		let allBlogs: [Blog]? = try! context.fetch(allFetchRequest)
		allBlogs?.forEach {
			context.delete($0)
		}
	}

}
