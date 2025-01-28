//
//  APICall.swift
//  MountainPassCondition
//
//  Created by Nabiya Alam on 1/23/25.
//

import SwiftUI

class MountainPassService {

    let accessCode = "2c9055a7-2f71-4fd0-b8e5-3113304a2ebc"

    func getData(id: Int, completion: @escaping (String) -> Void) {
        guard
            let url = URL(
                string:
                    "https://wsdot.wa.gov/Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionsAsJson?AccessCode=\(accessCode)"
            )
        else {
            completion("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion("error: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                let responseString = String(data: data, encoding: .utf8)
            else {
                completion("Error, no DATA")
                return
            }
            do {
                
                if let jsonArray = try JSONSerialization.jsonObject(
                    with: data, options: []) as? [[String: Any]]
                {
                    
                    let filteredArray = jsonArray.filter { dictionary in
                        return dictionary["MountainPassId"] as? Int == id
                    }
                    
                    let filteredData = try JSONSerialization.data(withJSONObject: filteredArray, options: .prettyPrinted)
                    let filteredJSONString = String(data: filteredData, encoding: .utf8) ?? "Error"
                    completion(filteredJSONString)
                }
            } catch {
                completion("error parsing json: \(error)")
            }

        }.resume()
    }
}

//https://wsdot.wa.gov/Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionsAsJson?AccessCode=2c9055a7-2f71-4fd0-b8e5-3113304a2ebc
