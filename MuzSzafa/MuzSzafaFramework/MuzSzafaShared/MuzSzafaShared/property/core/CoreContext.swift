//
//  UserDefs.swift
//  MuzSzafa
//
//  Created by Alagris on 09/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
open class CoreContext{
    public static let shared = CoreContext(db:"MuzSzafa")
    public static func find(ent byName:String)->CoreDataEntity?{
        return shared.cache.find(byName)
    }
    
    public let persistentContainer:NSPersistentContainer
    public let cache:CoreDataCache
	public let observer:CoreContextObserver
    public init(db name:String){
        persistentContainer = loadCoreContext(name)
        guard let json = loadJson(name)else{
            fatalError("JSON file not loaded!")
        }
        guard let j = json as? [[String:Any]] else{
            fatalError("JSON file malformatted!")
        }
		observer = CoreContextObserver(cntx: persistentContainer.viewContext)
        cache = CoreDataCache(mom: persistentContainer.managedObjectModel,json:j)
        cache.cntx = self
		for ent in persistentContainer.managedObjectModel.entities{
			assert(cache.find(ent) != nil)
			for (name,_) in ent.attributesByName{
				assert(cache.find(ent)!.find(attr: name) != nil)
				assert(cache.find(ent)!.find(attr: name)!.parent != nil)
			}
		}
    }
	
    open func get()->NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    open func save() {
        saveCoreContext(get())
    }
    open func entity(for name:String)->NSEntityDescription?{
        return NSEntityDescription.entity(forEntityName: name, in: get())
    }
    open func purge() {
        for ent in persistentContainer.managedObjectModel.entities{
            guard let name = ent.name else{
                continue
            }
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let delReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
            do {
                try self.get().execute(delReq)
                self.get().reset()
            }catch{
                print(error)
            }
        }
    }
	open func addObserver(observer:Any,selector:Selector,name:Notification.Name?){
		NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: get().undoManager)
	}
	open func addUndoObserver(observer:Any,selector:Selector){
		let name = Notification.Name.NSUndoManagerDidUndoChange
		addObserver(observer: observer, selector: selector, name: name)
	}
	open func addRedoObserver(observer:Any,selector:Selector){
		let name = Notification.Name.NSUndoManagerDidRedoChange
		addObserver(observer: observer, selector: selector, name: name)
	}
	
	
	
    
}


public func loadJson(_ coreDataName:String)->Any?{
    let bundle = Bundle(for: CoreContext.self)
    if let path = bundle.path(forResource: coreDataName, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONSerialization.jsonObject(with: data)
        } catch {
        }
    }
    return nil
}


public func loadCoreContext(_ coreDataName:String)->NSPersistentContainer{
    let bundle = Bundle(for: CoreContext.self)

    guard let url = bundle.url(forResource: coreDataName, withExtension: "momd") else{
        fatalError("Count not find \(coreDataName).momd")
    }
    guard let mom = NSManagedObjectModel(contentsOf: url) else{
        fatalError("Count load url: \(url)")
    }
    let persistentContainer = NSPersistentContainer(name: coreDataName, managedObjectModel: mom)
	
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
	// Adds undo/redo support
	persistentContainer.viewContext.undoManager = UndoManager()
    return persistentContainer
}

public func saveCoreContext(_ context:NSManagedObjectContext) {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }else{
        print("No changes!!!!!")
    }
}





