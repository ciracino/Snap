import SwiftUI

struct ItemDetailView: View {
    var item: Item
    var image: Image
    var body: some View {
        ScrollView {
            LazyVStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 8)
                HStack {
                    Text("\(item.name)")
                        .padding(.top, 4)
                        .padding(.bottom, 4)
                    Spacer()
                }
                HStack {
                    Text("\(item.quantity)")
                        .font(.title2)
                    Spacer()
                }
                .padding(.bottom, 8)
                Divider()
                // 관련 댓글
                HStack {
                    Text("댓글")
                    Spacer()
                    Button {
                        
                    } label: {
                        HStack {
                            Text("더 보기")
                            Button {
                                
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
                // 댓글 3개까지만 보여주기
                Spacer()
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        HStack {
            Button {
                
            } label: {
                Text("대여")
            }
            Button {
                
            } label: {
                Text("예약")
            }
        }
    }
    
    private func IntPrice(price: Double) -> Int {
        return Int(price)
    }
}


struct sampleKeyword: View {
    let keyword: String
    var body: some View {
        Text(keyword)
            .padding(5)
            .foregroundStyle(.red)
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct sampleLogPreview: View {
    let image: Image
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.bottom, 4)
            Text("가나다라마바사아자차카타파하")
                .frame(width: 120)
                .clipped()
                .lineLimit(1)
        }
    }
}
