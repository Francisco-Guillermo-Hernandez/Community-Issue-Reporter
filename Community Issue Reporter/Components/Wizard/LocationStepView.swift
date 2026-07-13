//
//  LocationStepView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI


struct LocationStepView: View {
    @Bindable var model: ReportDataModel
    @State private var showMapPickerSheet: Bool = false
    
    init(_ model: ReportDataModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack {
                VStack {
                    MiniMapLocator(
                        coordinate: $model.report.coordinate,
                        locator: $model.locator,
                        onExpandMap: { _ in
                            showMapPickerSheet.toggle()
                        },
                        onChange: {
                            model.isDifferentLocation = true
                        }
                    )
                    
                }
                .overlay(
                    RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                    .stroke(Color.theme.border, lineWidth: 1)
                )
                .cornerRadius(.themeRadius * 2)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1) // shadow-sm
                .sheet(isPresented: $showMapPickerSheet)  {
                    
                    ZStack(alignment: .top) {
//                        // Screen Background
                        Color.theme.background
                            .ignoresSafeArea()
                        
                        Color.orange.opacity(0.12)
                            .frame(height: 280)
                            .mask(
                                LinearGradient(
                                    colors: [.white, .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blur(radius: 20)
                            .ignoresSafeArea()
                        
                        MapPickerView(
                            coordinate: $model.report.coordinate,
                            locator: $model.locator,
                            onConfirm: { coordinate, locator in
                                model.updateCoordinate(coordinate)
                                model.updateLocator(with: locator)
                                self.showMapPickerSheet = false
                            }
                        )
                    }
                }

                TextInput(
                    name: "Address",
                    label: String(localized: "Please tell us where is the issue", comment: "ReportView: Please tell us where is the issue"),
                    validators: addressValidator,
                    regex: .customPattern(addressRegex),
                    axis: .vertical,
                    isValid: $model.isAddressValid,
                    value: $model.report.address
                )
                
                Spacer()
            }
            
          
        }
        .padding(.top, 4)
    }
}


#Preview {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return LocationStepView(model)
}
