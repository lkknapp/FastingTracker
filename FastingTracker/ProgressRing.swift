//
//  ProgressRing.swift
//  FastingTracker
//
//  Created by Linda Knapp on 3/6/24.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    //@State var progress = 0.0
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        ZStack {
            // MARK: Placeholder Ring
            
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            // MARK: Colored Ring
          
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(
                    gradient: Gradient(colors:
                                        [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),
                                         Color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)),
                                         Color(#colorLiteral(red: 0.8882588885, green: 1, blue: 0.4630023739, alpha: 1)),
                                         Color(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)),
                                         Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)),
                                         Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))]),
                    center: .center),
                        style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect((Angle(degrees: 270)))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                 
                    // MARK: Upcoming Fast
                    
                    VStack(spacing: 5) {
                        Text("Upcoming Fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                } else {
                    
                    // MARK: Elapsed Time
                    
                    VStack(spacing: 5) {
                        Text("Elapsed Time (\(fastingManager.progress.formatted(.percent)))")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.top)
                    
                    // MARK: Remaining Time
                    
                    VStack(spacing: 5) {
                        if !(fastingManager.elapsed) {
                            Text("Remaining Time (\((1 - fastingManager.progress).formatted(.percent)))")
                                .opacity(0.7)
                        } else {
                            Text("Extra Time")
                                .opacity(0.7)
                        }
                        
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    
                }
                
           
                
            }
        }
        .frame(width: 250, height: 250)
        .padding()
//        .onAppear {
//            progress = 1.0
//        }
        .onReceive(timer) { _ in
            fastingManager.tracker()
        }
    }
}

#Preview {
    ProgressRing()
}
