//
//  SearchResultsViewModel.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import RxSwift

final class SearchResultsViewModel: TableViewModel {
    typealias Model = [TripViewModel]
    internal var model: Model
    
    fileprivate let disposeBag = DisposeBag()
    
    private let businessService: SearchResultsBusinessService
    
    public var dataAvailability = PublishSubject<Void>.init()
    
    init(businessService: SearchResultsBusinessService) {
        self.businessService = businessService
        self.model = []
    }
}

extension SearchResultsViewModel {
    
    public func fetchTrips() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                return Disposables.create()
            }
            self.businessService
                .fetchSearchTrips(departureCity: "Paris", arrivalCity: "Rennes")
                .map({ trips -> [TripViewModel] in
                    trips.map { trip -> TripViewModel in
                        return TripViewModel(tripModel: trip)
                    }
                })
                .subscribe(onSuccess: { tripViewModels in
                    self.model = tripViewModels
                    completable(.completed)
                    self.dataAvailability.onNext(())
                }, onError: { error in
                    completable(.error(error))
                    self.dataAvailability.onError(error)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
