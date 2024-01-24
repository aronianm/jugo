//
//  HealthDataManager.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import HealthKit

class HealthDataManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var activeEnergy: Double = 0 {
        didSet {
            activeEnergy = roundToTwoDecimalPlaces(activeEnergy)
        }
    }
    @Published var exerciseMinutes: Double = 0 {
        didSet {
            exerciseMinutes = roundToTwoDecimalPlaces(exerciseMinutes)
        }
    }
    @Published var standHours: Double = 0 {
        didSet {
            standHours = roundToTwoDecimalPlaces(standHours)
        }
    }
    
    init() {
        requestAuthorization()
        loadHealthData()
    }
    private func roundToTwoDecimalPlaces(_ value: Double) -> Double {
            return (value * 100).rounded() / 100
    }
        
    func formattedValue(value: Double) -> String {
            return String(format: "%.1f", value)
    }
    
    private func requestAuthorization() {
        let healthTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: healthTypes) { (_, _) in }
    }
    
    private func loadHealthData() {
        loadQuantitySample(type: .activeEnergyBurned) { quantity in
            self.activeEnergy = quantity.doubleValue(for: .kilocalorie())
        }
        
        loadQuantitySample(type: .appleExerciseTime) { quantity in
            self.exerciseMinutes = quantity.doubleValue(for: .minute())
        }
        
        loadQuantitySample(type: .appleStandTime) { quantity in
            self.standHours = quantity.doubleValue(for: .hour())
        }
    }
    
    private func loadQuantitySample(type: HKQuantityTypeIdentifier, completion: @escaping (HKQuantity) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: type)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            if let sum = result?.sumQuantity() {
                DispatchQueue.main.async {
                    completion(sum)
                }
            }
        }
        
        healthStore.execute(query)
    }
}
