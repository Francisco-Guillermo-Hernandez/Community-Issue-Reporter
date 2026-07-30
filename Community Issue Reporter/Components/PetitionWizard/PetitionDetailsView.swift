//
//  PetitionDetailsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/7/26.
//

import SwiftUI

enum PetitionWizardElements: Hashable {
    case title
    case category
    case description
}

struct PetitionDetailsView: View {
    
    @Bindable var controller: PetitionController
    @FocusState.Binding var focusedField: PetitionWizardElements?
    
    init(_ controller: PetitionController, _ focusedField: FocusState<PetitionWizardElements?>.Binding) {
        self.controller = controller
        self._focusedField = focusedField
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            /// Provides title for the petition
            TextInput(
                 name: String(localized: "Give a title to your petition"),
                 label: String(localized: "Please enter a title"),
                 validators: titleValidator,
                 isValid: $controller.isTitleValid,
                 value: $controller.petition.title,
            )
            .id(PetitionWizardElements.title)
            .focused($focusedField, equals: .title)
            .accessibilityIdentifier("PetitionTitleInput")
         
            /// Provides description for the petiton
            TextInput(
                 name: String(localized: "Describe your petition"),
                 label: String(localized: "Please enter a description"),
                 validators: descriptionValidator,
                 axis: .vertical,
                 isValid: $controller.isDescriptionValid,
                 value: $controller.petition.description,
            )
            .id(PetitionWizardElements.description)
            .focused($focusedField, equals: .description)
            .accessibilityIdentifier("PetitionDescriptionInput")
            
            /// Its used to choose a category in order to categorize the petition
            PetitionCategorySelector(selected: $controller.petition.category) {}
            .id(PetitionWizardElements.category)
            .focused($focusedField, equals: .category)
            .accessibilityIdentifier("PetitionCategorySelector")
            
        }
        .task {
            focusedField = .title
        }
    }
}

#Preview {
    @Previewable @State var controller = PetitionController()
    @Previewable @FocusState var focusedField: PetitionWizardElements?
    
    ScrollView {
        PetitionDetailsView(controller, $focusedField)
    }
    .background(Color.theme.background)
}
