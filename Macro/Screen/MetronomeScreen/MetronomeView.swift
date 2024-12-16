//
//  MetronomeView.swift
//  Macro
//
//  Created by Yunki on 12/16/24.
//

import SwiftUI

struct MetronomeView: View {
    @State var viewModel: MetronomeViewModel
    
    @State private var isSobakOn: Bool = false
    
    private var jangdanName: String
    
    init(viewModel: MetronomeViewModel, jangdanName: String) {
        self.jangdanName = jangdanName
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HanbaeBoardView(
                    jangdan: viewModel.state.jangdanAccent,
                    isSobakOn: self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? viewModel.state.isSobakOn : false,
                    isPlaying: viewModel.state.isPlaying,
                    currentRow: viewModel.state.currentRow,
                    currentDaebak: viewModel.state.currentDaebak,
                    currentSobak: viewModel.state.currentSobak
                ) { row, daebak, sobak, newAccent in
                    withAnimation {
                        viewModel.effect(action: .changeAccent(row: row, daebak: daebak, sobak: sobak, newAccent: newAccent))
                    }
                }
                if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                    SobakSegmentsView(sobakSegmentCount: sobakSegmentCount, currentSobak: self.viewModel.state.currentSobak, isPlaying: self.viewModel.state.isPlaying, isSobakOn: self.viewModel.state.isSobakOn)
                        .padding(.bottom, -4)
                }
            }
            .frame(height: 372)
            .padding(.horizontal, 8)
            
            if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                ViewSobakToggleView(isSobakOn: $isSobakOn)
                    .padding(.bottom, 16)
            } else {
                ListenSobakToggleView(isSobakOn: $isSobakOn)
                    .padding(.bottom, 16)
            }
            MetronomeControlView(viewModel: viewModel)
        }
        // 빠르기 찾기 기능 비활성화 용도
        .contentShape(Rectangle())
        .onTapGesture {
            self.viewModel.effect(action: .disableEstimateBpm)
        }
        
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
            self.isSobakOn = self.viewModel.state.isSobakOn
        }
        .onChange(of: isSobakOn) {
            self.viewModel.effect(action: .changeSobakOnOff)
        }
    }
}

#Preview {
    MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: "진양")
}
