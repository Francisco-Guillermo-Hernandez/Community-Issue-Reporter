//
//  PetitionController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/6/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class SignRequestController {
    
    var petitions: [PetitionPost] = []
    private(set) var isLoading: Bool = false
    
    private(set) var currentPage: Int = 1
    private(set) var canLoadMore: Bool = true
    private(set) var signatureCount: Int = 125
    
    private let pageLimit: Int = 16
    var isPrimaryActionVisible: Bool = true
    
    var title: String?
    var subtitle: String?
    var activeSubtitleIndex: Int?
    var showSignatureModal: Bool = false
    var showCreateRequestView: Bool = false
    var value: Double = 20
    var isSearchBarVisible: Bool = false
    var searchText: String = ""
    var issueType: IssueTypes = .road
    var orderFilter: OrderFilter = .ascending
    var severity: Severity = .low
    var selectedItem: Int?
    var strokes: [SignatureLine] = []
    
    ///
    func fetchPetitions(reset: Bool = false) async {
        if reset {
            currentPage = 1
            canLoadMore = true
        }
        
        guard !isLoading && (canLoadMore || reset) else { return }
        
        isLoading = true
        
        let query = PaginatedRequestQueryParams(
            page: currentPage,
            limit: 10,
            issueTypeId: issueType == .all ? nil : issueType.identifier,
            severityId: severity == .all ? nil : severity.identifier,
            ordering: orderFilter
        )
        
        
        print(query)
        
       
        let locator: Locator = .init()
        locator.setCountryCode(.SV)
        
        print(locator)
        
        self.petitions.append(contentsOf: PetitionsPostMockedData.shared.petitions)
        
        
//        await PetitionRepository.share.list(
//            q: query,
//            locator: locator,
//            onComplete: { result in
//                guard let documents = result.documents else {
//                    canLoadMore = false
//                    return
//                }
//
//                if reset {
//                    self.petitions = documents
//                } else {
//                    let existingIds = Set(self.petitions.compactMap { $0.id })
//                    let uniqueNewPetitions = documents.filter { doc in
//                        guard let id = doc.id else { return true }
//                        return !existingIds.contains(id)
//                    }
//                    self.petitions.append(contentsOf: uniqueNewPetitions)
//                }
//
//                self.canLoadMore = result.hasNext && self.currentPage < self.pageLimit
//                if self.canLoadMore {
//                    self.currentPage += 1
//                }
//
//            }, onError: { error in
//                print(error)
//                canLoadMore = false
//            }
//        )
        
        isLoading = false
    }
    
    func getSelectedIndex(_ petition: PetitionPost) -> Int {
        petitions.firstIndex(where: {
                $0.id == petition.id
            }
        ) ?? 0
    }
    
    func formatSigners(for petition: PetitionPost) -> String {
        
        if petition.postSigners.hasCurrentUserSigned {
            return String(format: "%d citizens and you have signed", petition.currentSignatures)
        }
        
        return String(format: "%d citizens have signed", petition.currentSignatures)
    }
}
