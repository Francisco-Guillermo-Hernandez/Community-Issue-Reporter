//
//  MockedData.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/7/26.
//

import Foundation

// MARK: - Mocked data for testing purposes
final class MapExplorerMockedData {
    
    static var shared = MapExplorerMockedData()
    var report: MapExplorerReport
    private init() {
        self.report = .init(
            id: "SV-SS-260601-aXWsaxls",
            lat: 13.701270,
            lng: -89.224432,
            address: "Lorem ipsum dolor sit ammet",
            title: "A big pothole in the middle of the street",
            description: "There is a big pothole that is affecting our cars",
            severityId: 1,
            statusId: 1,
            issueTypeId: 1,
            matterToSolveId: 1,
            reportedAtRaw: nil,
            cellIndex: "",
            createdAtRaw: 1780036575602,
            updatedAtRaw: 1780036575602,
            reportedBy: "john.doe",
            cityId: "",
            petitionId: "",
            shareUrl: "",
            attachments: [
                PreviewAttachment(id: "24b93d66-07ff-4141-91ce-408b615123c3", type: .image, createdAtRaw: 0, updatedAtRaw: 0, uploaderUserName: "jhon.doe", validatedBy: .bot, state: .pending, fileName: "1783058838224-f02fb5e4-07d1-49d4-a9f5-742816b669c9.webp", reportContainer: "587d3ac3-0715-4958-8955-1d6d29a3d489"),
                
                PreviewAttachment(id: "06d3df5f-ef2a-43c0-bd40-5125a12fe284", type: .image, createdAtRaw: 0, updatedAtRaw: 0, uploaderUserName: "jhon.doe", validatedBy: .bot, state: .pending, fileName: "1783058837989-ab7a054b-7d99-4137-b9f9-ded39ce7732f.webp", reportContainer: "587d3ac3-0715-4958-8955-1d6d29a3d489")
            ],
            assignedTo: nil,
            institutionId: nil,
            reportContainer: ""
        )
        
        
    }
}


// MARL: -
final class PetitionsPostMockedData {
    
    static var shared = PetitionsPostMockedData()
    var petitions: [PetitionPost]
    private init() {
        self.petitions = [
            PetitionPost(
                id: "1",
                title: "Recarpet of big potholes on the road  ",
                description: "Several potholes must be recarpeted",
                targetSignatures: 100,
                currentSignatures: 10,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 1783215199743 / 1000),
                updatedAt: nil,
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                attachments: [
                    PreviewAttachment(
                        id: "2e5d96b2-2321-4811-ba4f-f3aadb0cb9e0",
                        type: .image,
                        createdAtRaw: 1783215096354,
                        updatedAtRaw: nil,
                        uploaderUserName: "franceskynov.herdls",
                        validatedBy: nil,
                        state: .pending,
                        fileName: "1783215065059-81708b76-1b39-4b0a-9a96-97df64abceb2.webp",
                        reportContainer: "31c6dfb4-a76a-4fc3-964a-3bb6eb058266"
                    ),
                    PreviewAttachment(
                        id: "7792c0e2-eb19-4c6d-ad75-fc388b762289",
                        type: .image,
                        createdAtRaw: 1783215096354,
                        updatedAtRaw: nil,
                        uploaderUserName: "franceskynov.herdls",
                        validatedBy: nil,
                        state: .pending,
                        fileName: "1783215064406-828d2db4-395e-441d-9614-2722428d9fc4.webp",
                        reportContainer: "31c6dfb4-a76a-4fc3-964a-3bb6eb058266"
                    ),
                    PreviewAttachment(
                        id: "34a1f39e-9593-43cd-8171-06c79dcfb547",
                        type: .image,
                        createdAtRaw: 1783215096354,
                        updatedAtRaw: nil,
                        uploaderUserName: "franceskynov.herdls",
                        validatedBy: nil,
                        state: .pending,
                        fileName: "1783215064655-1a478db2-3358-4f08-8b5c-07c8b981b653.webp",
                        reportContainer: "31c6dfb4-a76a-4fc3-964a-3bb6eb058266"
                    ),
                    PreviewAttachment(
                        id: "c8704541-3d6f-4570-95ff-165fdc40372c",
                        type: .image,
                        createdAtRaw: 1783215096354,
                        updatedAtRaw: nil,
                        uploaderUserName: "franceskynov.herdls",
                        validatedBy: nil,
                        state: .pending,
                        fileName: "1783215063847-4a80e0e9-7556-409f-b11e-4a75d8b826d8.webp",
                        reportContainer: "31c6dfb4-a76a-4fc3-964a-3bb6eb058266"
                    ),
                    PreviewAttachment(
                        id: "75259292-e29c-40e7-a09b-01b28852ca86",
                        type: .image,
                        createdAtRaw: 1783215096354,
                        updatedAtRaw: nil,
                        uploaderUserName: "franceskynov.herdls",
                        validatedBy: nil,
                        state: .pending,
                        fileName: "1783215063694-aeb30f13-e62a-42fe-8bda-89eb5a404a17.webp",
                        reportContainer: "31c6dfb4-a76a-4fc3-964a-3bb6eb058266"
                    )
                ],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, city: "Santa Tecla", cityId: "d25de983-c87c-4bf0-bb7f-9203c3755985", language: "es", shareLink: "/kAp82ybCuDE67hello/petition/20260706/SSC/SV/recarpet-of-big-potholes-on-the-road"),
                postPublisher: .init(names: "John Doe", userName: "jonh.doe", profilePicture: "/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg", profileId: "G6abo3sSu1zcQ1U9"),
                postSigners: .init(),
                progress: 10.0
            ),
            
            PetitionPost(
                id: "2",
                title: "Un semaforo no esta funcionando en la avenida",
                description: "Un semaforo esta funcionando mal",
                targetSignatures: 200,
                currentSignatures: 20,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 1783482305955 / 1000),
                updatedAt: nil,
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                attachments: [],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, city: "Cojutepeque", cityId: "60c3a7b8-f778-4883-b5b2-257dd98deae0", language: "es", shareLink: "/11Ap82ybCuDE67oeu/petition/20260706/SSC/SV/un-semafor-no-esta-funcionando-en-la-avenida"),
                postPublisher: .init(names: "John Doe", userName: "jonh.doe", profilePicture: "/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg", profileId: "G6abo3sSu1zcQ1U9"),
                postSigners: .init(latestsSigners: [
                    User(names: "Jane Doe", userName: "jane.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "uiEw3sSu1zcQ1U9"),
                    User(names: "Martha Doe", userName: "martha.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "ieq3sSu1zcQ1U9"),
                    User(names: "Michael Brown", userName: "michael.brown", profilePicture: "/avatars/019f4f22-1464-79bc-a712-acf20b7b3664.png", profileId: "l33sSu1zcQ1U9"),
                ]),
                progress: 10.0
            ),
            
            PetitionPost(
                id: "3",
                title: "Hay una fuga de agua en la colonia",
                description: "Demo demo demo demo",
                targetSignatures: 300,
                currentSignatures: 30,
                categoryId: 4,
                statusId: 1,
                reportedBy: UUID(
                    uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
                ),
                disabled: false,
                createdAt: Date(timeIntervalSince1970: 1783297513380 / 1000),
                updatedAt: nil,
                reportsIds: [
                    "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
                    "51aec27c-17a3-42f5-94a7-b3e9f54be651",
                    "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
                    "e6e67b15-15d7-4523-a85b-cd199d32117e",
                    "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
                    "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
                ],
                attachments: [],
                postMetadata: .init(audience: "", visibility: .draft, countryCode: .SV, city: "San Salvador", cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619", language: "es", shareLink: "/kAp82ybCuDE67oeu/petition/20260706/SSC/SV/fuga-de-agua-en-la-colonia"),
                postPublisher: .init(names: "John Doe", userName: "jonh.doe", profilePicture: "/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg", profileId: "G6abo3sSu1zcQ1U9"),
                postSigners: .init(hasCurrentUserSigned: true, latestsSigners: [
                    User(names: "Jane Doe", userName: "jane.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "uiEw3sSu1zcQ1U9"),
                    User(names: "Martha Doe", userName: "martha.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "ieq3sSu1zcQ1U9"),
                    User(names: "Michael Brown", userName: "michael.brown", profilePicture: "/avatars/019f4f22-1464-79bc-a712-acf20b7b3664.png", profileId: "l33sSu1zcQ1U9"),
                ]),
                progress: 10.0
            ),
        ]
    }
}

final class SelectedMockedCity {
    
    static var shared = SelectedMockedCity()
    
    var city: FriendlyCityDistribution
    private init() {
        city = .init(
            cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
            firstLevel: "El Salvador",
            secondLevel: "San Salvador",
            thirdLevel: "San Salvador",
            ZipCode: "1101",
            legalGroupName: "Distrito de San Salvador",
            coordinates: .init(lat: 13.701270, lng: -89.224432),
            isCapitalCity: 1,
            isDepartmentalCapital: 1
        )
    }
}
