import RxSwift

class CompetitionContentsUsecase {
    private let repository: StubCompetitionContentsRepository
    
    init(repository: StubCompetitionContentsRepository) {
        self.repository = repository
    }
    
    func fetchCompetitionContents() -> Single<[Vote]> {
        return repository.fetchCompetitionContents()
    }
}
