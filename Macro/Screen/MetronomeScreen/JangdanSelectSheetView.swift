//
//  JangdanSelectSheetView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI

struct JangdanSelectSheetView: View {
    
    let exampleList: [String] = ["진양", "중모리", "중중모리", "굿거리", "휘모리", "동살풀이", "엇모리", "엇중모리", "세마치", "노랫가락 5.8.8.5.5"]
    
    @Binding var jangdan: String
    @Binding var isSheetPresented: Bool
    
    // geometry 설정을 위한 변수
    @State var geoSize: CGSize = .zero
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                // 우상단 창닫기 버튼
                Button(action: {
                    isSheetPresented = false
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)  // TODO: change color name
                            .font(.system(size: geoSize.width * 0.076))
                            .padding(.bottom, geoSize.height * 0.021)
                            .padding(.trailing, geoSize.width * 0.041)
                    }
                })
          
                Text("다른 장단 선택하기")
                    .font(.Title1_R)
                    .foregroundStyle(.textDefault)
                    .padding(.leading, geoSize.width * 0.041)
                
                List {
                    ForEach(exampleList, id: \.self) { jangdan in
                        Button(action: {
                            self.jangdan = jangdan
                            isSheetPresented = false
                        }, label: {
                            HStack(spacing: 0) {
                                Text("\(jangdan)")
                                    .padding(.vertical, geoSize.height * 0.011)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 17)) // TODO : 사용 여부 및 반응형 여부 확인 필요
                                    .foregroundStyle(.gray) // TODO: 변경 필요
                            }
                        })
                    }
                }
                
            }
            .padding(.top, geoSize.height * 0.016)
    }
}

//#Preview {
////    JangdanSelectSheetView()
//}
