//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by John Erick Santos on 6/6/2023.
//

import CoreData
import UIKit

enum DBError: Error {
    case failedToSaveTMDBData
    case failedToFetchTMDBData
}

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()

    func downloadItem(with model: TMDBData, completion: @escaping (Result<Void, Error>) -> Void) {
        // reference to the app delegate instance
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        // core data context
        let context = appDelegate.persistentContainer.viewContext

        // item to be saved in coredata db
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.id = Int64(model.id)
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DBError.failedToSaveTMDBData))
        }
    }
    
    func fetchTMDBDataFromDB(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        // reference to the app delegate instance
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        // core data context
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DBError.failedToFetchTMDBData))
        }
    }
}
