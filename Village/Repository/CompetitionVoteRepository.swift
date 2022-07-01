import Alamofire
import RxSwift

protocol CompetitionContentsRepositroyType: AnyObject {
    func fetchCompetitionContents() -> Single<[Vote]>
}

class StubCompetitionContentsRepository: CompetitionContentsRepositroyType {
    
    func fetchCompetitionContents() -> Single<[Vote]> {
        return Single.create { single in
            
            let contents = [
                Vote(voteId: 3,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 1, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 2, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                
                Vote(voteId: 4,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️ 괜찮아 잡아줄 수 있지 ☺️ 괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                
                Vote(voteId: 4,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                
                Vote(voteId: 4,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                
                Vote(voteId: 4,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)]),
                
                Vote(voteId: 4,
                     title: "📌 애인이 나의 동성친구가 먹으려는 깻잎이 안 떼질 때, 곤란한 친구의 깻잎을 잡아준다면?",
                     choice: [VoteContent(voteContentId: 3, voteContentTitle: "괜찮아 잡아줄 수 있지 ☺️", votes: 0),
                              VoteContent(voteContentId: 4, voteContentTitle: "말이야 방구야 그게 말이 되나 😡", votes: 0)])
            ]
            
            
            single(.success(contents))
            return Disposables.create()
        }
    }
}
