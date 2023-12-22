import Foundation

struct Joke {
    let id: UUID
    var content: String
    let category: Category
    
    init(id: UUID, content: String, category: Category) {
        self.id = id
        self.content = content
        self.category = category
    }
    
    static let sampleJokes = [
        Joke(id: UUID(), content: "내또출", category: .catchphrase),
        Joke(id: UUID(), content: "억텐", category: .catchphrase),
        Joke(id: UUID(), content: "우리 엄마엄마가", category: .catchphrase),
        Joke(id: UUID(), content: "오히려 좋아", category: .catchphrase),
        Joke(id: UUID(), content: "통모짜핫도그", category: .catchphrase),
        Joke(id: UUID(), content: "그 잡채", category: .catchphrase),
        Joke(id: UUID(), content: "캘박", category: .catchphrase),
        Joke(id: UUID(), content: "SBN", category: .catchphrase),
        Joke(id: UUID(), content: "싫존주의", category: .catchphrase),
        Joke(id: UUID(), content: "내봬누", category: .catchphrase),
        Joke(id: UUID(), content: "전화기로 건물을 지으면? 콜로세움", category: .dadJoke),
        Joke(id: UUID(), content: "얼음이 죽으면? 다이빙", category: .dadJoke),
        Joke(id: UUID(), content: "칼이 화나면 어떻게 될까요? 검정색", category: .dadJoke),
        Joke(id: UUID(), content: "원숭이를 구우면? 구운몽", category: .dadJoke),
        Joke(id: UUID(), content: "가장 해로운 청바지는? 유해진", category: .dadJoke),
        Joke(id: UUID(), content: "곰은 사과를 어떻게 먹을까요? Bear먹지요~", category: .dadJoke),
        Joke(id: UUID(), content: "세종대왕이 초콜릿을 나눠줄 때 하는 말은? '가나'다.", category: .dadJoke),
        Joke(id: UUID(), content: "반성문을 영어로 하면? 글로벌", category: .dadJoke),
        Joke(id: UUID(), content: "비가 한 시간동안 오면? 추적60분", category: .dadJoke)
    ]
}
