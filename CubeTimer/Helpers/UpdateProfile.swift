//
//  UpdateProfile.swift
//  CubeTimer
//
//  Created by Said Alır on 22.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation
import Firebase

class UpdateProfile {
    
    static let shared = UpdateProfile()

    func addSolution(solution: SolutionData, session: Int) {
    
        let uid = AuthManager.shared.getUID()
        let db = Firestore.firestore()
        
        //Main collection reference
        let colRef = Firestore.firestore().collection("Users")
        //Current user document reference
        let userDocRef = colRef.document(uid)
        //Current session document reference
        let sessionRef = userDocRef.collection("sessions").document("session\(session)")
        //Current session's solution collection reference
        let solutionsRef = sessionRef.collection("solutions")
        //New data document reference
        let solutionRef = solutionsRef.document()
        
        //Solution data will be added to solutions collection
        let solutionData: [String: Any] = ["duration": solution.duration, "created": solution.created, "algorithm": solution.algorithm]
        
        db.runTransaction(({ (transaction, error) -> Any? in
            
            let userDocument: DocumentSnapshot!
            let sessionDocument: DocumentSnapshot!
            
            //step 1
            transaction.setData(solutionData, forDocument: solutionRef)
            
            do {
                try userDocument = transaction.getDocument(userDocRef)
            } catch  {
                return nil
            }
     
            let totalSolves = userDocument.data()?["totalSolves"] as? Int ?? 0
            
            //step 2
            transaction.updateData(["totalSolves": totalSolves+1], forDocument: userDocRef)
            
            do {
                try sessionDocument = transaction.getDocument(sessionRef)
            } catch {
                return nil
            }
            //step 3
            let sessionSolves = sessionDocument.data()?["sessionSolves"] as? Int ?? 0
            transaction.updateData(["sessionSolves": sessionSolves+1], forDocument: sessionRef)
            
            //step 4
            let totalDuration = userDocument.data()?["totalDuration"] as? Double ?? 0.0
            let newTotal = totalDuration + solution.duration
            transaction.updateData(["totalDuration": newTotal], forDocument: userDocRef)
            
            //step 5
            let totalSessionDuration = sessionDocument.data()?["sessionDurations"] as? Double ?? 0.0
            let newSessionTotal = totalSessionDuration + solution.duration
            transaction.updateData(["sessionDurations": newSessionTotal], forDocument: sessionRef)
            
            //step 6-7
            let newTotalAvg = totalDuration / Double(totalSolves)
            let newSessionAvg = totalSessionDuration / Double(sessionSolves)
            
            transaction.updateData(["totalAvg": newTotalAvg], forDocument: userDocRef)
            transaction.updateData(["sessionAvg": newSessionAvg], forDocument: sessionRef)
            
            //Step 8
            let bestSession = userDocument.data()?["bestSession"] as? Int ?? 1
            let bestSessionRef = userDocRef.collection("sessions").document("session\(bestSession)")
            
            let bestSessionDocument: DocumentSnapshot!
            
            do {
                try bestSessionDocument = transaction.getDocument(bestSessionRef)
            } catch {
                return nil
            }
            
            let bestSessionAvg = bestSessionDocument.data()?["sessionAvg"] as? Double ?? 0.0
            
            if newSessionAvg < bestSessionAvg {
                transaction.setData(["bestSession": session], forDocument: userDocRef)
            }
            
            
            //Step 9
            let pb = userDocument.data()?["pb"] as? Double ?? 0.0
            if solution.duration < pb || pb == 0 {
                transaction.updateData(["pb" : solution.duration], forDocument: userDocRef)
            }
            
            //Step 10-11-12
        
            let best5 = userDocument.data()?["bestAvg5"] as? Double ?? 0.0
            let best12 = userDocument.data()?["bestAvg12"] as? Double ?? 0.0
            let best100 = userDocument.data()?["bestAvg100"] as? Double ?? 0.0
            
            
            return true
        })) { (object, error) in
            return
        }
        //1. add data to solutions...
        //2. increment total solves..
        //3. increment session solves..
        //4. add duration of last solve to total durations
        //5. add duration of last solve to session durations
        //6. update sessionAvg
        //7. update totalAvg
        //8. update best session if needed
        //9. check pb update if needed.
        //10. check best5 update if needed
        //11. check best12 update if needed
        //12. check best100 update if needed
        
    }
}
