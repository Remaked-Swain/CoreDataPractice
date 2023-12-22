import UIKit

final class JokeListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    weak var jokeDataDelegate: (any CoreDataManagable<Joke>)? = nil
    var jokes: [Joke] = Joke.sampleJokes
    var currentTabCategory: Category {
        Category(rawValue: self.tabBarItem.tag)!
    }
}

extension JokeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateActionHandler = { (
            _: UIContextualAction,
            _: UIView,
            completion: @escaping (Bool) -> Void
        ) in
            completion(true)
            self.showUserInputAlert() { userInput in
                guard let userInput = userInput else { return }
                var jokeToUpdate = self.jokes[indexPath.row]
                jokeToUpdate.content = userInput
                self.jokeDataDelegate?.updateCoreData(jokeToUpdate)
                self.reloadCell(jokeToUpdate)
            }
        }
        
        let deleteActionHandler = { (
            _: UIContextualAction,
            _: UIView,
            completion: @escaping (Bool) -> Void
        ) in
            completion(true)
            let jokeToDelete = self.jokes[indexPath.row]
            self.jokeDataDelegate?.deleteCoreData(jokeToDelete)
            self.deleteCell(jokeToDelete)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: nil, handler: updateActionHandler)
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: deleteActionHandler)
        
        updateAction.image = UIImage(systemName: "pencil")
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
    
    private func showUserInputAlert(_ completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "아무말 수정", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let submit = UIAlertAction(title: "수정", style: .default) { _ in
            completionHandler(alert.textFields?.first?.text)
        }
        
        alert.addTextField { textField in textField.placeholder = "수정할 아무말을 입력해주세요." }
        alert.addAction(cancel)
        alert.addAction(submit)
        
        self.present(alert, animated: true)
    }
}

extension JokeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { jokes.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currentTabCategory.cellIdentifier, for: indexPath)
        cell.textLabel?.text = jokes[indexPath.row].content
        return cell
    }
}

extension JokeListViewController: CellUpdatable {
    func updateAllCells(_ data: [Joke]) {
        self.jokes = data
        guard let tableView = self.tableView else { return }
        tableView.reloadData()
    }
    
    func insertCell(_ data: Joke) {
        guard data.category == currentTabCategory else { return }
        self.jokes.append(data)
        guard isViewLoaded else { return }
        let indexPath = self.getCurrentIndexPath(data)
        if self.tabBarController?.selectedViewController == self {
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            self.tableView.reloadData()
        }
    }
    
    func reloadCell(_ data: Joke) {
        guard data.category == currentTabCategory else { return }
        let indexPath = self.getCurrentIndexPath(data)
        self.jokes[indexPath.row] = data
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteCell(_ data: Joke) {
        guard data.category == currentTabCategory else { return }
        let indexPath = self.getCurrentIndexPath(data)
        self.jokes.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func getCurrentIndexPath(_ data: Joke) -> IndexPath {
        guard let jokeIndex = self.jokes.firstIndex(where: { joke in
            joke.id == data.id
        }) else { return IndexPath() }
        
        return IndexPath(row: jokeIndex, section: 0)
    }
}
