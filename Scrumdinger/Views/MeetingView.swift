//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 24/04/2022.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    //MARK: - Properties
    @Binding var scrum: DailyScrum
    
    @StateObject var scrumTimer = ScrumTimer()
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    //MARK: - Heirarchy
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                
                MeetingHeaderView(
                    secondsElapsed: scrumTimer.secondsElapsed,
                    secondsRemaining: scrumTimer.secondsRemaining,
                    theme: scrum.theme
                )
                
                MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme)
                    .padding()
                
                MeetingFooterView(
                    speakers: scrumTimer.speakers,
                    skipAction: scrumTimer.skipSpeaker
                )
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.startScrum()
            scrumTimer.speakerChangedAction = speakerDidChange
        }
        .onDisappear {
            scrumTimer.stopScrum()
            let newHistory = ScrumHistory(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60)
            scrum.history.insert(newHistory, at: 0)
        }
    }
    
    private func speakerDidChange() -> Void {
        player.seek(to: .zero)
        player.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[2]))
            .preferredColorScheme(.dark)
    }
}
