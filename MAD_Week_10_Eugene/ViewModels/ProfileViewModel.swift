//
//  ProfileViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var isSeeding: Bool = false
    @Published var message: String?
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    let seedCategories: [SeedCategory] = [
        SeedCategory(id: "bajak_laut",
                     catTitle: "Bajak laut",
                     catDesc: "Mulai petualangan mencari harta karun samudra.",
                     catType: "pirate"),
        SeedCategory(id: "ninja",
                     catTitle: "Ninja",
                     catDesc: "Mulai perjalanan ninja menembus batas desa.",
                     catType: "ninja"),
        SeedCategory(id: "romance",
                     catTitle: "Romance",
                     catDesc: "Mulai kisah asmara manis di bawah sakura.",
                     catType: "romance")
    ]
    
    func achievements(for user: User?) -> [Achievement] {
        let completedCount = user?.finishedStories.count ?? 0
        return [
            Achievement(id: "first_step",
                        achievementTitle: "Langkah Awal",
                        achievementDesc: "Satu cerita selesai.",
                        badgeIcon: "lightbulb.fill",
                        hasUnlocked: completedCount >= 1),
            Achievement(id: "explorer",
                        achievementTitle: "Penjelajah Takdir",
                        achievementDesc: "Tiga cerita selesai.",
                        badgeIcon: "map.fill",
                        hasUnlocked: completedCount >= 3),
            Achievement(id: "master",
                        achievementTitle: "Sang Pencatat",
                        achievementDesc: "Lima cerita selesai.",
                        badgeIcon: "crown.fill",
                        hasUnlocked: completedCount >= 5)
        ]
    }
    
    func seed(category: SeedCategory) async {
        isSeeding = true
        message = nil
        errorMessage = nil
        do {
            switch category.catType {
            case "pirate":
                try await seedPirate()
            case "ninja":
                try await seedNinja()
            case "romance":
                try await seedRomance()
            default:
                break
            }
            message = "\(category.catTitle) berhasil ditambahkan"
        } catch {
            errorMessage = error.localizedDescription
        }
        isSeeding = false
    }
    
    private func seedPirate() async throws {
        let story = Story(storyTitle: "Tekad Sang Kapten",
                          storyDesc: "Perjalanan Dylan mencari harta karun samudra dengan kru yang kuat.",
                          storyCategory: "pirate")
        try await seedStory(story: story, nodes: pirateNodes())
    }
    
    private func seedNinja() async throws {
        let story = Story(storyTitle: "Jalan Ninja",
                          storyDesc: "Ian harus memilih jalannya sendiri sebagai ninja desa tersembunyi.",
                          storyCategory: "ninja")
        try await seedStory(story: story, nodes: ninjaNodes())
    }
    
    private func seedRomance() async throws {
        let story = Story(storyTitle: "Sakura Terakhir",
                          storyDesc: "Kisah cinta Gavin di musim semi sekolah menengah.",
                          storyCategory: "romance")
        try await seedStory(story: story, nodes: romanceNodes())
    }
    
    private func seedStory(story: Story, nodes: [StoryNode]) async throws {
        let storyRef = try db.collection("stories").addDocument(from: story)
        let storyId = storyRef.documentID
        
        var idMap: [String: String] = [:]
        var startNodeId: String?
        
        for node in nodes {
            let docRef = db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .document()
            idMap[node.id ?? ""] = docRef.documentID
            if node.isStart {
                startNodeId = docRef.documentID
            }
        }
        
        for node in nodes {
            guard let originalId = node.id, let realId = idMap[originalId] else { continue }
            let mappedChoices = node.options.map { choice in
                StoryChoice(id: choice.id,
                            optionText: choice.optionText,
                            followingNodeId: idMap[choice.followingNodeId] ?? choice.followingNodeId)
            }
            var newNode = StoryNode(parentStoryId: storyId,
                                    storyText: node.storyText,
                                    options: mappedChoices,
                                    isStart: node.isStart,
                                    isEnd: node.isEnd,
                                    timestamp: Date())
            newNode.id = realId
            try db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .document(realId)
                .setData(from: newNode)
        }
        
        if let entryId = startNodeId {
            try await db.collection("stories")
                .document(storyId)
                .updateData(["entryNodeId": entryId])
        }
    }
    
    private func ninjaNodes() -> [StoryNode] {
        let n1 = "n1", n2 = "n2", n3 = "n3", n4 = "n4", n5 = "n5"
        return [
            StoryNode(id: n1, parentStoryId: "", storyText: "Ian berlatih di hutan. Ujian ninja tinggal besok pagi. Ian merasa kurang menguasai chakra-nya.",
                     options: [
                        StoryChoice(optionText: "Meditasi Chakra", followingNodeId: n2),
                        StoryChoice(optionText: "Latihan Fisik Keras", followingNodeId: n3)
                     ], isStart: true),
            StoryNode(id: n2, parentStoryId: "", storyText: "Ian duduk bersila. Aliran chakra-nya menjadi tenang dan stabil. Ia merasakan kekuatan baru.",
                     options: [StoryChoice(optionText: "Lanjut ke Ujian", followingNodeId: n4)]),
            StoryNode(id: n3, parentStoryId: "", storyText: "Ian melatih tubuhnya hingga lelah. Tenaganya bertambah, namun chakranya kacau.",
                     options: [StoryChoice(optionText: "Lanjut ke Ujian", followingNodeId: n5)]),
            StoryNode(id: n4, parentStoryId: "", storyText: "Ian lulus ujian dengan kontrol chakra sempurna. Ia menjadi ninja desa yang dihormati.",
                     options: [], isEnd: true),
            StoryNode(id: n5, parentStoryId: "", storyText: "Ian gagal pada teknik akhir. Ia bertekad berlatih lebih giat tahun depan.",
                     options: [], isEnd: true)
        ]
    }
    
    private func pirateNodes() -> [StoryNode] {
        let n1 = "n1", n2 = "n2", n3 = "n3", n4 = "n4", n5 = "n5"
        return [
            StoryNode(id: n1, parentStoryId: "", storyText: "Dylan berdiri di dermaga. Peta harta karun di tangannya. Dua jalur tersedia menuju pulau misteri.",
                     options: [
                        StoryChoice(optionText: "Lewati Badai Selatan", followingNodeId: n2),
                        StoryChoice(optionText: "Berlayar Tenang ke Utara", followingNodeId: n3)
                     ], isStart: true),
            StoryNode(id: n2, parentStoryId: "", storyText: "Badai dahsyat menerjang. Dylan dan kru melawan ombak besar dengan keberanian.",
                     options: [StoryChoice(optionText: "Tiba di Pulau", followingNodeId: n4)]),
            StoryNode(id: n3, parentStoryId: "", storyText: "Pelayaran tenang namun panjang. Persediaan menipis sebelum mereka tiba di pulau.",
                     options: [StoryChoice(optionText: "Tiba di Pulau", followingNodeId: n5)]),
            StoryNode(id: n4, parentStoryId: "", storyText: "Dylan menemukan harta karun legendaris. Kru bersorak gembira di bawah matahari.",
                     options: [], isEnd: true),
            StoryNode(id: n5, parentStoryId: "", storyText: "Dylan menemukan pulau kosong. Harta sudah lebih dulu diambil bajak laut lain.",
                     options: [], isEnd: true)
        ]
    }
    
    private func romanceNodes() -> [StoryNode] {
        let n1 = "n1", n2 = "n2", n3 = "n3", n4 = "n4", n5 = "n5"
        return [
            StoryNode(id: n1, parentStoryId: "", storyText: "Gavin berdiri di bawah pohon sakura. Surat cinta di tangannya. Ia harus memilih caranya.",
                     options: [
                        StoryChoice(optionText: "Berikan Langsung", followingNodeId: n2),
                        StoryChoice(optionText: "Titipkan Lewat Teman", followingNodeId: n3)
                     ], isStart: true),
            StoryNode(id: n2, parentStoryId: "", storyText: "Gavin memberanikan diri. Ia menyerahkan surat sambil tersenyum gugup.",
                     options: [StoryChoice(optionText: "Tunggu Jawaban", followingNodeId: n4)]),
            StoryNode(id: n3, parentStoryId: "", storyText: "Surat sampai lewat teman. Namun pesan menjadi kurang personal dan terasa dingin.",
                     options: [StoryChoice(optionText: "Tunggu Jawaban", followingNodeId: n5)]),
            StoryNode(id: n4, parentStoryId: "", storyText: "Ia membaca dengan tersenyum. Mereka berjanji bertemu lagi musim semi berikutnya.",
                     options: [], isEnd: true),
            StoryNode(id: n5, parentStoryId: "", storyText: "Surat tidak pernah dibalas. Gavin belajar bahwa keberanian memang penting.",
                     options: [], isEnd: true)
        ]
    }
}
