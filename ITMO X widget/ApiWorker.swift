//
//  ApiWorker.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation

class ApiWorker {
    static var shared = ApiWorker()
    private init() {
        self.group = UserDefaults(suiteName: "group.blockcontent")!.string(forKey: "group") ?? self.group
    }
    
    private let baseURL = "https://mountain.ifmo.ru/api.ifmo.ru/public/v1/"
    private let scheduleEndpoint = "schedule_lesson_group/"
    private let cdeLoginURL = "https://de.ifmo.ru/servlet/"
    private let cdeURL = "https://de.ifmo.ru/api/private/eregister"
    
    var subjects: [ScheduleSubject] = []
    var group: String = ""
    var weekEven = 1
    
    
    private func serverRequest(endpoint: String, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let urlString : String = baseURL + endpoint
        if let url = URL(string: urlString) {
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if(error != nil){
                    onFailure(error!)
                } else{
                    onSuccess(data!)
                }
            })
            task.resume()
        } else {
            onFailure(NSError(domain: "", code: 22, userInfo: nil) )
        }
    }
    
    func getSchedule(onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        self.serverRequest(endpoint: self.scheduleEndpoint + self.group, onSuccess: { (data) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let objects = jsonResult as? [String: Any] {
                        if let week = objects["current_week"] as? Int {
                            if week % 2 == 1 {
                                self.weekEven = 2
                            }
                        }
                        if let subjects = objects["schedule"] as? [[String: Any]] {
                            var result: [ScheduleSubject] = []
                            for item in subjects {
                                let subject = ScheduleSubject(title: item["title"] as? String,
                                                              place: item["place"] as? String,
                                                              room: item["room"] as? String,
                                                              status: item["status"] as? String,
                                                              person: item["person"] as? String,
                                                              start_time: item["start_time"] as! String,
                                                              end_time: item["end_time"] as! String,
                                                              data_week: item["data_week"] as! Int,
                                                              data_day: item["data_day"] as! Int)
                                result.append(subject)
                            }
                            self.subjects = result
                            onSuccess()
                        }
                    }
                }
            } catch let parseError as NSError {
                onFailure(parseError)
            }
        }) { (error) in
            onFailure(error)
        }
    }
}
