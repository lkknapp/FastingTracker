//
//  FastingManager.swift
//  FastingTracker
//
//  Created by Linda Knapp on 3/6/24.
//

import Foundation

enum FastingState {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"
    
    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date
    @Published private(set) var endTime: Date
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    var feedingTime: Double {
        return 24 - fastingPlan.fastingPeriod * 60 * 60
    }

    
    init() {
        let calendar = Calendar.current
        
//        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
//        //components.hour = 20
//        print(components)
//        
//        let scheduledTime = calendar.date(from: components) ?? Date.now
//        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
       
        let components = DateComponents(hour: 19)
        let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod)
        print("startTime", startTime.formatted(.dateTime.month().day().hour().minute().second()))
        print("endTime", endTime.formatted(.dateTime.month().day().hour().minute().second()))
    }

    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        endTime = startTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod)
        elapsedTime = 0.0
    }
    
    func tracker() {
        guard fastingState != .notStarted else {return}
        
        print("now", Date().formatted(.dateTime.month().day().hour().minute().second()))
        
        if endTime >= Date() {
            print("not elapsed")
            elapsed = false
        } else {
            print("elapsed")
            elapsed = true
        }
        elapsedTime += 1
        print("elapsedTime", elapsedTime)
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
        print("progress", progress)
    }
}
