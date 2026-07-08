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
    
    var petitions: [Petition] = []
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
    
    var users: [User] = [
        User(username: "janeDoe", avatar: "user", profileId: ""),
        User(username: "mayDoe", avatar: "user", profileId: ""),
        User(username: "mperez", avatar: "user", profileId: ""),
    ]
    
    
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
        
        self.petitions = [
            Petition(
                id: "1",
                title: "Recarpet of big potholes on the road  ",
                description: "Several potholes must be recarpeted",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, language: "es", shareLink: ""),
                postPublisher: .init(username: "", avatar: "", profileId: "")
            ),
            
            Petition(
                id: "2",
                title: "Un semaforo no esta funcionando en la avenida",
                description: "Un semaforo esta funcionando mal",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, language: "es", shareLink: ""),
                postPublisher: .init(username: "", avatar: "", profileId: "")
            ),
            Petition(
                id: "3",
                title: "Hay una fuga de agua en la colonia",
                description: "",
                targetSignatures: 22,
                currentSignatures: 0,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 799056444.493906),
                updatedAt: Date(timeIntervalSince1970: 799056444.493906),
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, language: "es", shareLink: ""),
                postPublisher: .init(username: "", avatar: "", profileId: "")
            ),
        ]
        
        self.petitions.append(contentsOf: petitions)
        
        
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
}
