//
//  MetronomeOnOffImplement.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Foundation
import Combine
import UIKit.UIApplication

class MetronomeOnOffImplement {
    private var jangdan: [[Accent]]
    private var jangdanAccentList: [Accent] {
        if self.isSobakOn {
            return jangdan.flatMap { $0 }
        } else {
            return jangdan.map { $0.enumerated().map { $0.offset == 0 ? $0.element : .none }}.flatMap { $0 }
        }
    }

    private var bpm: Double
    private var currentBeatIndex: Int
    var isSobakOn: Bool
    
    var cancelBag: Set<AnyCancellable> = []
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .userInteractive) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / bpm
    }
    
    private var jangdanRepository: JangdanRepository
    private var soundManager: PlaySoundInterface
    
    init(jangdanRepository: JangdanRepository, soundManager: PlaySoundInterface) {
        self.jangdan = [[.medium]]
        self.bpm = 60.0
        self.currentBeatIndex = 0
        self.isSobakOn = false
        
        self.jangdanRepository = jangdanRepository
        self.soundManager = soundManager
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdanEntity in
            guard let self else { return }
            self.jangdan = jangdanEntity.daebakList.map { $0.bakAccentList }
            
            let daebakCount = self.jangdan.count
            let bakCount = self.jangdan.reduce(0) { $0 + $1.count }
            let averageSobakCount = Double(bakCount) / Double(daebakCount)
            self.bpm = Double(jangdanEntity.bpm) * averageSobakCount
            
            self.timer?.schedule(deadline: .now() + self.interval, repeating: self.interval, leeway: .nanoseconds(1))
        }
        .store(in: &self.cancelBag)
    }
}

// Play / Stop
extension MetronomeOnOffImplement: MetronomeOnOffUseCase {
    
    func changeSobak() {
        self.isSobakOn.toggle()
    }

    func play(_ tickHandler: @escaping () -> Void ) {
        // 데이터 갱신
        self.currentBeatIndex = 0
        UIApplication.shared.isIdleTimerDisabled = true
        // Timer 설정
        if let timer { self.stop() }
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: self.interval)
        self.timer?.setEventHandler { [weak self] in
            guard let self = self else { return }

            tickHandler()
            self.timerHandler()
        }

        // Timer 실행
        self.timer?.resume()
    }

    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func timerHandler() {
        let accent: Accent = jangdanAccentList[self.currentBeatIndex % jangdanAccentList.count]
        self.soundManager.beep(accent)
        self.currentBeatIndex += 1
    }
}