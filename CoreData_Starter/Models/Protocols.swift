import UIKit

protocol CellUpdatable<T>: AnyObject {
    associatedtype T
    
    func updateAllCells(_ data: [T])
    func insertCell(_ data: T)
    func reloadCell(_ data: T)
    func deleteCell(_ data: T)
    func getCurrentIndexPath(_ data: T) -> IndexPath
}

protocol CoreDataManagable<T>: AnyObject {
    associatedtype T
    
    func saveCoreData(_ data: T)
    func saveCoreData(currentUser: User, _ data: T)
    func fetchCoreData() -> [T]
    func fetchWithPredicate(currentUser: User, currentCategory: Category) -> [T]
    func updateCoreData(_ data: T)
    func deleteCoreData(_ data: T)
}

extension CoreDataManagable {
    func fetchCoreData() -> [T] { [] }
    func fetchWithPredicate(currentUser: User, currentCategory: Category) -> [T] { [] }
    func saveCoreData(_ data: T) { }
    func saveCoreData(currentUser: User, _ data: T) { }
}
