import Foundation

struct User {
    let id: UUID
    var name: String
    var jokes: [Joke]
    
    init(id: UUID, name: String, jokes: [Joke]) {
        self.id = id
        self.name = name
        self.jokes = jokes
    }
    
    static let sampleUsers = [
        User(id: UUID(), name: "타코캣", jokes: Joke.sampleJokes),
        User(id: UUID(), name: "잼킹", jokes: Joke.sampleJokes),
        User(id: UUID(), name: "디오", jokes: Joke.sampleJokes),
        User(id: UUID(), name: "핀", jokes: Joke.sampleJokes),
        User(id: UUID(), name: "키오", jokes: Joke.sampleJokes),
        User(id: UUID(), name: "수박", jokes: Joke.sampleJokes)
    ]
}
