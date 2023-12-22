import UIKit

final class UserSaveViewController: UIViewController {
    @IBOutlet private weak var userTextField: UITextField!
    
    weak var userDataDelegate: (any CoreDataManagable<User>)? = nil
    weak var userViewDelegate: (any CellUpdatable<User>)? = nil
    
    @IBAction private func saveUser(_ sender: UIButton) {
        let newUser = User(
            id: UUID(),
            name: userTextField.text!,
            jokes: []
        )
        
        userDataDelegate?.saveCoreData(newUser)
        userViewDelegate?.insertCell(newUser)
        
        self.dismiss(animated: true)
    }
}
