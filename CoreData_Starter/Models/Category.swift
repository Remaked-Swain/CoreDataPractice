enum Category: Int {
    case catchphrase = 0
    case dadJoke
    
    var cellIdentifier: String {
        switch self {
        case .catchphrase: "CatchphraseCell"
        case .dadJoke: "DadJokeCell"
        }
    }
}
