//
//  HomeViewController.swift
//  SwiftConcurrency
//
//  Created by 서충원 on 1/13/24.
//

import UIKit
import SnapKit
import Then
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    lazy var addButton = UIButton().then {
        $0.setTitle("ADD", for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(addData), for: .touchUpInside)
    }
    
    @objc func addData() async {
        
        Task {
            do {
                let ref = try await db.collection("users").addDocument(data: ["first": "Ada", "last": "Lovelace"])
                print("Document added with \(ref.documentID)")
            } catch {
                print("Error adding document: \(error)")
            }
        }
    }
    
//    func saveNFT(type: String, url: URL, videoUrl: URL?, handler: @escaping () -> Void) {
//        let videoUrl = videoUrl?.absoluteString ?? ""
//        
//        db.collection("NFT").document(NFTID).setData(NFT.dicType) { error in
//            if let error = error {
//                print("NFT 저장 에러: \(error)")
//                hand
//            } else {
//                print("NFT 저장 성공: \(self.NFTID)")
//                handler()
//            }
//        }
//    }
    
    lazy var readButton = UIButton().then {
        $0.setTitle("READ", for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(readData), for: .touchUpInside)
    }
    
    @objc func readData() {
        Task {
            do {
                let snapshot = try await db.collection("users").getDocuments()
                for document in snapshot.documents {
                    print("\(document.documentID) -> \(document.data())")
                }
            } catch {
                print("Error adding document: \(error)")
            }
        }
    }
    
//    func getAuthors(authors: [String], handler: @escaping ([User]) -> ()) {
//        var users = Array(repeating: User.dummyType, count: authors.count)
//        db.collection("User").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("User 불러오기 에러: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let user = document.makeUser()
//                    let index = authors.enumerated().filter{ $0.element == user.userUid }.map{ $0.offset }
//                    for index in index {
//                        users[index] = user
//                    }
//                }
//                handler(users)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
    }
    
    func setViews() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(readButton)
        readButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    enum LocationError: Error {
        case unknown
    }
    
    func getWeatherReadings(for location: String) async throws -> [Double] {
        switch location {
        case "London":
            return (1...100).map{ _ in Double.random(in: 6...26) }
        case "Rome":
            return (1...100).map{ _ in Double.random(in: 20...32) }
        case "San Francisco":
            return (1...100).map{ _ in Double.random(in: 60...80) }
        default:
            throw LocationError.unknown
        }
    }
    
    func printAllWeatherReadings() async {
        do {
            print("Calculating average weather...")
            
            let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
//                for location in ["London", "Rome", "San Francisco"] {
//                    group.addTask{ try await self.getWeatherReadings(for: location) }
//                }
                group.addTask{ try await self.getWeatherReadings(for: "London") }
                let allValues = try await group.reduce([], +)
                let average = allValues.reduce(0, +) / Double(allValues.count)
                return "Overall Average Temperature is \(average)"
            }
            
            print("Done! \(result)")
        } catch {
            print(error)
        }
    }

}
