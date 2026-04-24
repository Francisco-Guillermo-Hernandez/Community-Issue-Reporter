//
//  CustomCalendar.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/4/26.
//

import SwiftUI
import UIKit

struct CustomCalendar: UIViewRepresentable {

    @Binding var selectedDate: Date
    var activityMap: [String: DaySummary]
    var onDateSelected: (Date) -> Void

    private let calendar = Calendar.current
    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.calendar = Calendar.current
        return df
    }()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = calendar
        view.delegate = context.coordinator

        // Selection behavior
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = selection

        return view
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.parent = self
        uiView.reloadDecorations(forDateComponents: context.coordinator.allDateComponents(), animated: true)
    }
}

extension CustomCalendar {

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

        var parent: CustomCalendar

        init(_ parent: CustomCalendar) {
            self.parent = parent
        }

        // Convert map keys → DateComponents
        func allDateComponents() -> [DateComponents] {
            parent.activityMap.keys.compactMap {
                guard let date = parent.formatter.date(from: $0) else { return nil }
                return Calendar.current.dateComponents([.year, .month, .day], from: date)
            }
        }

        // MARK: Dot / decoration per day
        func calendarView(
            _ calendarView: UICalendarView,
            decorationFor dateComponents: DateComponents
        ) -> UICalendarView.Decoration? {

            guard let date = Calendar.current.date(from: dateComponents) else { return nil }
            let key = parent.formatter.string(from: date)

            guard let summary = parent.activityMap[key] else {
                return nil
            }

            // Dot size based on count (optional nice touch)
            let size: CGFloat = summary.count >= 5 ? 8 :
                                summary.count >= 3 ? 6 : 4

            let dot = UIView()
            dot.backgroundColor = UIColor.orange
            dot.layer.cornerRadius = size / 2
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: size).isActive = true
            dot.heightAnchor.constraint(equalToConstant: size).isActive = true

            return .customView {
                let container = UIView()
                container.addSubview(dot)
                NSLayoutConstraint.activate([
                    dot.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    dot.centerYAnchor.constraint(equalTo: container.centerYAnchor)
                ])
                return container
            }
        }

        // MARK: Date selection
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {

            guard let comps = dateComponents,
                  let date = Calendar.current.date(from: comps) else { return }

            parent.onDateSelected(date)
            parent.selectedDate = date
        }
    }
}

struct ExampleCustomCalendarView: View {
    
    @State private var selectedDate: Date = Date()

    let activityMap: [String: DaySummary] = [:
//        "2026-04-10": DaySummary(count: 1, ids: [
//            BasicInfo(id: "12", reportsIds: ["id-1"], signatureIds: ["id-1"])
//        ]),
//        "2026-03-01": DaySummary(count: 1, ids: ["id-1"]),
//        "2026-04-10": DaySummary(count: 1, ids: ["id-1"]),
//        "2026-04-18": DaySummary(count: 3, ids: ["id-1", "id-2", "id-3"]),
//        "2026-04-21": DaySummary(count: 5, ids: ["id-4", "id-5", "id-6", "id-7", "id-8"]),
//        "2026-04-22": DaySummary(count: 1, ids: ["id-1"]),
    ]
    var body: some View {
        CustomCalendar(selectedDate: $selectedDate, activityMap: activityMap) { date in
            print("Selected:", date)
        }
        .frame(height: 400)
        .padding()
    }
}

#Preview {
    ExampleCustomCalendarView()
}
