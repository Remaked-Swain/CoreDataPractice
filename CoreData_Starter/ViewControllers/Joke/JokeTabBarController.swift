import UIKit
import CoreData

final class JokeTabBarController: UITabBarController {
    private var currentUser: User
    
    init?(user: User, coder: NSCoder) {
        self.currentUser = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers?.forEach { viewController in
            guard let jokeListViewController = viewController as? JokeListViewController else { return }
            jokeListViewController.jokeDataDelegate = self
            let fetchedJokes: [Joke] = self.fetchWithPredicate(currentUser: currentUser, currentCategory: jokeListViewController.currentTabCategory)
            jokeListViewController.updateAllCells(fetchedJokes)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let jokeSaveViewController = segue.destination as? JokeSaveViewController else { return }
        jokeSaveViewController.jokeDataDelegate = self
        self.viewControllers?.forEach { viewController in
            guard let jokeListViewController = viewController as? JokeListViewController else { return }
            switch jokeListViewController.currentTabCategory {
            case .catchphrase:
                jokeSaveViewController.catchphraseViewDelegate = jokeListViewController
            case .dadJoke:
                jokeSaveViewController.dadJokeViewDelegate = jokeListViewController
            }
        }
    }
    
    @IBSegueAction func showJokeSaveView(_ coder: NSCoder) -> JokeSaveViewController? {
        return JokeSaveViewController(currentUser: self.currentUser, coder: coder)
    }
}

extension JokeTabBarController: CoreDataManagable {
    func saveCoreData(currentUser: User, _ data: Joke) {
        // ---------------------------------------------------------------------------------------------------------//
        // 이 곳에서 CoreData에 Joke data를 저장하세요.
        // 1. 우선 currentUser 파라미터를 사용하지 말고, Joke data를 저장해보세요.
        // 2. 나중에 User에 관한 CoreData CRUD가 완성이 되면, 그때 currentUser 파라미터를 사용하여 Relationship을 설정하도록 해봅니다.
        // ---------------------------------------------------------------------------------------------------------//
        let context = CoreDataManager.shared.context
        let jokeObject = JokeMO(context: context)
        jokeObject.id = data.id
        jokeObject.content = data.content
        jokeObject.category = Int16(data.category.rawValue)
    
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", currentUser.id as CVarArg)
        let fetchResult = CoreDataManager.shared.fetchData(request: request)
        let userObject = fetchResult.first
        userObject?.addToJokeRelationship(jokeObject)
        
        CoreDataManager.shared.saveContext()
    }
    
    func fetchWithPredicate(currentUser: User, currentCategory: Category) -> [Joke] {
        // ---------------------------------------------------------------------------------------------------------//
        // 이 곳에서 CoreData의 Joke data들을 가져오세요.
        // 1. 우선 currentUser, CurrentCategory 파라미터를 사용하지 말고, 모든 Joke 데이터를 return 해보세요.
        // 2. 나중에 User와 Relationship을 설정하여 Joke를 저장한 경우, 그때 NSPredicate를 활용하여 원하는 Joke들을 가져옵니다.
        // ---------------------------------------------------------------------------------------------------------//

        // ---------------------------------------------------------------------------------------------------------//
        // 설정해야 하는 NSPredicate 조건은 두 가지 입니다.
        // 1. 현재 선택된 User - currentUser 파라미터 활용
        // 2. 현재 선택된 Category - currentCategory 파라미터 활용
        // 위 두 가지를 만족하는 데이터들만 가져올 수 있도록 NSPredicate를 만들어보세요.
        // ---------------------------------------------------------------------------------------------------------//
        let request: NSFetchRequest<JokeMO> = JokeMO.fetchRequest()
        request.predicate = NSPredicate(format: "userRelationship.id == %@ AND category == %i", currentUser.id as CVarArg, currentCategory.rawValue as CVarArg)
        let fetchResult = CoreDataManager.shared.fetchData(request: request)
        return fetchResult.compactMap { jokeMo in
            guard let id = jokeMo.id,
                  let content = jokeMo.content,
                  let category = Category(rawValue: Int(jokeMo.category))
            else { return nil }
            
            return Joke(id: id, content: content, category: category)
        }
    }
    
    func updateCoreData(_ data: Joke) {
        // ---------------------------------------------------------------------------------------------------------//
        // 이 곳에서 CoreData의 특정 Joke data를 업데이트하세요.
        // ---------------------------------------------------------------------------------------------------------//
        let request: NSFetchRequest<JokeMO> = JokeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", data.id.uuidString as CVarArg)
        let fetchResult = CoreDataManager.shared.fetchData(request: request)
        if let jokeToUpdate = fetchResult.first {
            jokeToUpdate.content = data.content
            jokeToUpdate.category = Int16(data.category.rawValue)
        }
        CoreDataManager.shared.saveContext()
    }
    
    func deleteCoreData(_ data: Joke) {
        // ---------------------------------------------------------------------------------------------------------//
        // 이 곳에서 CoreData의 특정 Joke data를 삭제하세요.
        // ---------------------------------------------------------------------------------------------------------//
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<JokeMO> = JokeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", data.id.uuidString as CVarArg)
        let fetchResult = CoreDataManager.shared.fetchData(request: request)
        if let jokeToDelete = fetchResult.first {
            context.delete(jokeToDelete)
        }
        CoreDataManager.shared.saveContext()
    }
}
