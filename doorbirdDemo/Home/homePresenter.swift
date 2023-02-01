//
//  homePresenter.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

protocol HomeProtocol {
    func fetchInfo(token:String)
}

class homePresenter{
    
    // MARK: - Properties
    private let repository: HomeRepositoryProtocol
    private weak var view: HomeViewProtocol?
    private var infos: [NotificationModel] = []

    init(_ repository: HomeRepositoryProtocol,view: HomeViewProtocol) {
        self.repository = repository
        self.view = view
    }
    
    // MARK: - Functions
    private func handleResponse(_ response:AppResponse<[NotificationModel]>) {
        switch response {
            
        case .success(let value):
            view?.passinfos(with: value)
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleError(_ error: NetworkError) {
        view?.showError(with: error.description)
    }

    
}


extension homePresenter: HomeProtocol {
    func fetchInfo(token:String) {
        view?.showLoader()
        repository.homeFoods(token: token) { [weak self] response in
            guard let self = self else {
                return
            }
            self.view?.hideLoader()
            self.handleResponse(response)
        }
    }

}
