//
//  ModelHelper.swift
//  ArraySearchVSCoreDataRequest
//
//  Created by Soheil on 06/05/2019.
//  Copyright © 2019 Novinfard. All rights reserved.
//

import XCTest
import CoreData
import ArraySearchVSCoreDataRequest

class BaseModelTest: XCTestCase {
	
	private var dataModelName = "Model"
	private var managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
	var container: NSPersistentContainer?
	
	override func setUp() {
		let container = NSPersistentContainer(name: self.dataModelName, managedObjectModel: self.managedObjectModel)
		
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType  // in-memory container
		description.shouldAddStoreAsynchronously = false
		
		container.persistentStoreDescriptions = [description]
		
		container.loadPersistentStores { (description, error) in
			precondition(description.type == NSInMemoryStoreType)
			
			if let error = error {
				fatalError("In memory coordinator creation failed \(error)")
			}
		}
		self.container = container
	}
	
	override func tearDown() {
		self.container = nil
	}
}

extension XCTestCase {
	
	func getJsonDictionaryFromFile(_ filename: String) -> [String: Any]? {
		let testBundle = Bundle(for: type(of: self))
		guard let url = testBundle.url(forResource: filename, withExtension: "json") else {
			XCTFail("Missing JSON file")
			return nil
		}
		
		do {
			let data = try Data(contentsOf: url)
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				XCTFail("Could not serialise the data \(error.localizedDescription)")
				return nil
			}
			
		} catch {
			XCTFail("Could not Load the data \(error.localizedDescription)")
			return nil
		}
	}
	
	func report_memory(for text: String) {
		var info = mach_task_basic_info()
		var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
		
		let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
			$0.withMemoryRebound(to: integer_t.self, capacity: 1) {
				task_info(mach_task_self_,
						  task_flavor_t(MACH_TASK_BASIC_INFO),
						  $0,
						  &count)
			}
		}
		
		if kerr == KERN_SUCCESS {
			print("Memory in use (in bytes) for \(text): \(info.resident_size)")
		}
		else {
			print("Error with task_info(): " +
				(String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
		}
	}
}
