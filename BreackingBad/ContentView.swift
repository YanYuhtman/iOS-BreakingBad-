//
//  ContentView.swift
//  BreackingBad
//
//  Created by Yan  on 21/12/2025.
//

import SwiftUI
import Foundation

@Observable
@MainActor
class ViewModel:ObservableObject {
    var loading:Bool?
    var quote:Quote? = nil
    var character:Char? = nil
    var death:DeathRecord? = nil
    var isDead:Bool
    {
        if let character = character{
            return character.status == "Dead"
        }
        return false
    }

    init(){
        do{
            quote = try decodeFromLocale(fileName: "samplequote", ext: "json")
        }catch{
            print("Error decoding Quote sample data: \(error)")
        }
        do{
            character = try decodeFromLocale(fileName: "samplecharacter", ext: "json")
        }catch{
            print("Error decoding sample Character data: \(error)")
        }
        do{
            death = try decodeFromLocale(fileName: "sampledeath")
        }catch{
            print("Error decoding sample Death data: \(error)")
        }
    }
    private func decodeFromLocale<T:Decodable> (fileName: String, ext: String = "json") throws -> T{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let url = Bundle.main.url(forResource: fileName, withExtension: ext)
        guard let u = url else {
            fatalError("Invalud url:\(String(describing: url))")
        }
        let data = try Data(contentsOf: u)
        
        return try decoder.decode(T.self, from: data)
    }
    func fetchData(production: Production){
        Task {
            do{
                let servise = FetchingServise()
                loading = true
                quote = try await servise.fetchRandomQuote(production: production)
                if let q = quote{
                    character = try await servise.fetchCharacter(name:q.character)
                    if let character = character{
                        death = (try await servise.fetchDeath(name: character.name))
                    }
                }
            }catch{
                
            }
            loading = false
        }
    }
}

extension Production {
    var color:Color{
        return switch(self){
        case .BreakingBad:
            Color.green.mix(with: Color.black, by: 0.6)
        case .BetterCallSaul:
            Color.blue.mix(with: Color.black, by: 0.6)
        case .ElCamino:
            Color.red.mix(with: Color.black, by: 0.6)
        }
    }
}

struct ContentView : View {
    var viewModel:ViewModel
    @State var tabSelection:Bool = false
    var body: some View {
        
        let mainPage = MainPage(viewModel: viewModel)
        TabView(selection: $tabSelection) {
            mainPage.tabItem{
                Image(systemName: "house")
                Text("Home")
            }
            .tag(false)
            
            
            mainPage.tabItem{
                Image(systemName: "person")
                Text("Details")
            }
            .tag(true)
            
        }
        .preferredColorScheme(.dark)
        .accentColor(.green.mix(with: .black, by:0.4))
        .sheet(isPresented: $tabSelection){
            DetailView(viewModel: viewModel)
        }

        
    }
}
struct MainPage: View {
    var viewModel:ViewModel
    @State var production:Production = .BreakingBad
    var body: some View {
            
        ZStack{
            GeometryReader{proxy in
                Image(production.imageName)
                    .resizable()
                    .ignoresSafeArea(.all,edges: .top)
                    .frame(width: proxy.size.width * 2)
                    .offset(x: -proxy.size.width/2)
            }
            VStack{
                VStack{
                    if let q = viewModel.quote{
                        Text(q.quote)
                    }else{
                        Text("No quotes")
                            
                            
                    }
                    
                }
                .minimumScaleFactor(0.5)
                .frame(width:300 ,height: 60)
                .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(.rect(cornerRadius: 20))
                    
                
                if let character = viewModel.character{
                    GeometryReader{ r in
                        
                            HStack{
                                Spacer()
                                TabView{
                                    let images = character.images.shuffled()
                                    ForEach(0..<images.count,id: \.self) { index in
                                        AsyncImage(url: images[index]){image in
                                            ZStack(alignment: .bottom){
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: r.size.width * 0.9, height: r.size.height * 0.8)
                                                
                                                Text(character.name)
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                                    .frame(width: r.size.width * 0.9)
                                                    .padding()
                                                    .background(.ultraThinMaterial.opacity(0.9))
                                                //                                            .background{
                                                //                                                Rectangle()
                                                //                                                    .fill(Color.black)
                                                //                                                    .blur(radius: 5)
                                                //                                            }
                                                
                                            }.frame(width: r.size.width * 0.9, height: r.size.height * 0.8)
                                                .clipped().cornerRadius(20)
                                            
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                }.tabViewStyle(.page)
                               
                                Spacer()
                            }
                            
                        
                           
                    }
//
                        
                }
                Spacer()
                HStack{
                    Button(){
                        production = Production.BreakingBad
                        viewModel.fetchData(production: production)
                    } label: {
                        Text("Quote:\n\(Production.BreakingBad.label)")
                            .foregroundColor(Color.white)
                            .padding(20)
                            .background(production.color)
                            .clipped().cornerRadius(20)
                        
                        
                    }
                    Button(){
                        production = Production.BetterCallSaul
                        viewModel.fetchData(production: production)
                    } label: {
                        Text("Quote:\n\(Production.BetterCallSaul.label)")
                            .foregroundColor(Color.white)
                            .padding(20)
                            .background(production.color)
                            .clipped().cornerRadius(20)
                            
                    }
                    Button(){
                        production = Production.ElCamino
                        viewModel.fetchData(production: production)
                    } label: {
                        Text("Quote:\n\(Production.ElCamino.label)")
                            .foregroundColor(Color.white)
                            .padding(20)
                            .background(production.color)
                            .clipped().cornerRadius(20)
                            
                    }
                }
                .font(.caption)
                .padding(.bottom,20)
                
            }
            
            
        }
    }
}

struct DetailView:View {
    var viewModel:ViewModel
    @State private var is_Expanded = false
    
    var body: some View{
        @State var character = viewModel.character!
        
        ZStack(alignment: .top){
            VStack{
                Image(.breakingbad)
                    .resizable()
                    .scaledToFit()
                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .black, location: 0.0),
                                Gradient.Stop(color: .black, location: 0.5),
                                Gradient.Stop(color: .gray.mix(with: .black, by: 0.6), location: 1.0),
                                
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                
                
                
            }
            ScrollViewReader{ scrollProxy in
                ScrollView{
                    
                    VStack{
                        
                        AsyncImage(url: character.images[0]) { image in
                            
                            image.resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 20))
                               
                            
                        }
                        placeholder: {
                            ProgressView()
                        }
                        .frame(width: 350, height: 450 )
                        //                        .background(Color.green)
                        .padding(.top, 60)
                        
                        VStack(alignment: .leading){
                            Text(character.name)
                                .font(.largeTitle)
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font(.title3)
                                .padding(.bottom)
                            Text(character.fullName)
                                .font(.title3)
                            Text("Born: \(character.birthday)")
                            Divider()
                            Text("Ocupations:")
                            ForEach(character.occupations, id: \.self){ occupation in
                                Text("◦\(occupation)")
                            }
                            Divider()
                            DisclosureGroup("Status:", isExpanded: $is_Expanded){
                                if let deathRecord = viewModel.death{
                                    
                                    Text("Dead")
                                        .font(.title3.bold())
                                        .padding(.bottom)
                                    VStack(alignment: .leading){
                                        Text("Cause: \(deathRecord.cause)")
                                            .padding(.bottom)
                                        Text("Details: \(deathRecord.details)")
                                            .padding(.bottom)
                                        Text("Responsibles: \(deathRecord.responsible.joined(separator: ","))")
                                        
                                        Divider()
                                        AsyncImage(url: deathRecord.image, content: {image in
                                            image.resizable()
                                                .scaledToFit()
                                                .frame(width: 320,height: 240)
                                                .onAppear(){
                                                    withAnimation(.smooth(duration: 10,extraBounce: 5)){
                                                        scrollProxy.scrollTo("death_image",anchor: .bottom)
                                                    }
                                                }
                                        }, placeholder: {
                                            ProgressView()
                                        })
                                        .id("death_image")
                                    }
                                    
                                    
                                }
                                else
                                {
                                    Text("Alive")
                                }
                                
                            }
                            
                        }  .foregroundColor(.white)
                            .frame(width: 350)
                        Spacer()
                        
                        
                    }
                }
                .scrollIndicators(.hidden)
            }
                
        }.ignoresSafeArea(.all,edges: .top)
    }
    
}
#Preview{
    DetailView(viewModel: ViewModel())
        .preferredColorScheme(.dark)
}

#Preview {
    ContentView(viewModel: ViewModel())
        .preferredColorScheme(.dark)
}
