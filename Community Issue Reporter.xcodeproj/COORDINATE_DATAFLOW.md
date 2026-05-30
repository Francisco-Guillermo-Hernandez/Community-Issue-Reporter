# Coordinate Data Flow and Synchronization

## Overview
This document describes how geographic coordinates and location data are synchronized between the reporting views and the shared data model in the Community Issue Reporter app.

## Components
- **ReportDataModel (`@Observable` class):** The single source of truth for the report being created or edited. It holds the `Report` and `Locator` objects. Access is typically via `ReportDataModel.shared`.
- **ReportView (Main Container):** Manages the lifecycle of a report. It passes bindings to its subcomponents:
    - `$model.report.coordinate` (Binding to the coordinate)
    - `$model.locator` (Binding to the address and region info)
- **MiniMapLocator (Component):** An inline map displayed within the `ReportView` form for quick reference and minor adjustments.
- **MapPickerView (Modal):** A full-screen interface for precise location picking, searching, and zooming.

## Data Flow & Synchronization Logic

### 1. Bidirectional Sync via Bindings
Subcomponents (`MiniMapLocator`, `MapPickerView`) receive `@Binding` properties for coordinates and locator data. This allows any change made in a child component to propagate immediately back to the `ReportDataModel`.

### 2. Map Movement Handling (`handleMapMovement`)
Both map components implement a `handleMapMovement(center:)` function triggered by `.onMapCameraChange`. 
- **Reverse Geocoding:** It converts the map's center coordinate into a readable address and `Locator` object using `MKReverseGeocodingRequest`.
- **Binding Update:** It explicitly updates the `coordinate` binding with the new center. This is critical because it notifies the parent and other observing components of the change.
- **MainActor:** All updates to bindings and shared models from the asynchronous geocoding task are performed on the `MainActor`.

### 3. Cross-Component Awareness
`MiniMapLocator` uses `.onChange(of: coordinate)` to listen for changes originating from elsewhere (e.g., when the user selects a location in the `MapPickerView`). 
- When the coordinate changes, the mini-map automatically centers its camera on the new location, ensuring that both views are always visually synchronized.

## Implementation Notes
- **Debouncing:** Reverse geocoding in `handleMapMovement` includes a small `Task.sleep` to avoid redundant API calls during continuous panning.
- **State vs. Binding:** Internal camera state (`MapCameraPosition`) is kept local to each component to allow independent zooming/panning, while the center `coordinate` is shared via the binding to maintain data integrity.
