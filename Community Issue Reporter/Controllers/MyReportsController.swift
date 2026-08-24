//
//  MyReportsController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 16/6/26.
//

import SwiftUI
import Observation
import MapKit


@MainActor
@Observable
final class MyReportsController {
    var reports: [Report] = []
    var showDeleteAlert: Bool = false
    var elementToDelete: IndexSet = []
    var reportToDelete: Report? = nil
    var refreshID = UUID()
    var isLoading: Bool = false
    
    let model = ReportDataModel.shared
    
    var currentPage: Int = 1
    var hasNext: Bool = false
    var isLoadingMore: Bool = false
    
    func fetchReports(loadMore: Bool = false) async {
        if loadMore {
            guard hasNext, !isLoadingMore else { return }
            isLoadingMore = true
            currentPage += 1
        } else {
            isLoading = true
            currentPage = 1
        }
        
        do {
            let stream = ReportRepository.shared.listByUser(page: currentPage)
            
            let startIndex = (currentPage - 1) * 5
            
            for try await result in stream {
                self.hasNext = result.hasNext
                guard let documents = result.documents else {
                    continue
                }
                
                let newReports = documents.map { $0.toModel() }
                
                if loadMore {
                    if self.reports.count >= startIndex {
                        self.reports = Array(self.reports.prefix(startIndex)) + newReports
                    } else {
                        self.reports.append(contentsOf: newReports)
                    }
                } else {
                    self.reports = newReports
                }
            }
        } catch {
            print(error)
            if loadMore {
                currentPage -= 1
            }
        }
        
        if loadMore {
            isLoadingMore = false
        } else {
            isLoading = false
        }
    }
    
    func confirmDeletion(of id: String) {
        withAnimation {
            reports.removeAll { $0.id == id }
        }
        reportToDelete = nil
    }
    
    func update(report: Report) {
        Task {
            isLoading = true
            do {
                let result = try await ReportRepository.shared.update(report)
                if result == .updated {
                    self.refreshID = .init()
                }
                
            } catch {
                
            }
            
            isLoading = false
        }
    }
    
    func delete(report id: Report? = nil) {
        Task {
            guard let id = id?.id else { return }
            
            do {
                let result = try await ReportRepository.shared.delete(id)
                if result == .deleted {
                    self.confirmDeletion(of: id)
                }
            } catch {
                
            }
        }
    }
    
    func openInMaps(_ coordinate: Coordinate) {
        Task {
            /// load maps
            await MapExplorerController.shared.loadReportsWith(
                CLLocationCoordinate2D(
                    latitude: coordinate.lat,
                    longitude: coordinate.lng
                )
            )
            
            ///
            let span = MKCoordinateSpan(
                latitudeDelta:  0.000392298826163122953,
                longitudeDelta: 0.0003914447804127257768
            )
            
            /// set camera position
            AuthViewModel.shared.cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.lat,
                        longitude: coordinate.lng
                    ),
                    span: span
                )
            )
            
            /// route to first tab
            DeepLinkRouter.shared.activeTab = 1
        }
    }
    
    func openDetails(of reportId: String, cityId: String) {
        Task {
            
            do {
                let result = try await MapExplorerRepository.shared.report(reportId, countryCode: .SV, cityId: cityId)
//                MapExplorerController.shared.expandedItem = result
            } catch {
                
            }
            
        }
    }
}
