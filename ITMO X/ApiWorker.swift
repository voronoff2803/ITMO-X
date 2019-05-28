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
        self.group = UserDefaults.standard.string(forKey: "group") ?? self.group
    }
    
    private let baseURL = "https://mountain.ifmo.ru/api.ifmo.ru/public/v1/"
    private let scheduleEndpoint = "schedule_lesson_group/"
    private let cdeLoginURL = "https://de.ifmo.ru/servlet/"
    private let cdeURL = "https://de.ifmo.ru/api/private/eregister"
    
    var subjects: [ScheduleSubject] = []
    var cdeSbjects: [CdeSubject] = []
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
    
    func deleteCookies() {
        let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: self.cdeLoginURL)!)
        let cookieJar = HTTPCookieStorage.shared
        cookies?.forEach() {cookieJar.deleteCookie($0)}
    }
    
    func login(login: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        let url : String = cdeLoginURL + "?LOGIN=\(login)&PASSWD=\(password)&Rule=Logon"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url.encodeUrl)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
                UserDefaults.standard.set(nil, forKey: "login")
            } else{
                onSuccess()
            }
        })
        task.resume()
    }
    
    func getJournal(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        let login = UserDefaults.standard.string(forKey: "login") ?? ""
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        self.login(login: login, password: password, onSuccess: {
            let url : String = self.cdeURL
            let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if(error != nil){
                    onFailure(error!)
                    self.deleteCookies()
                } else{
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            if let years = jsonResult["years"] as? [[String : Any]] {
                                var subjects: [[String: Any]] = []
                                for year in years {
                                    if let newsubjects = year["subjects"] as? [[String: Any]] {
                                        subjects.append(contentsOf: newsubjects)
                                    }
                                }
                                if self.group == "" {
                                    self.group = years.last!["group"] as! String
                                    UserDefaults.standard.set(self.group, forKey: "group")
                                }
                                var result: [CdeSubject] = []
                                for item in subjects {
                                    let marks = item["marks"] as! [[String: Any]]
                                    var allMarks: [CdeMark] = []
                                    if let points = item["points"] as? [[String: Any]] {
                                        for mark in points {
                                            let cdeMark = CdeMark(name: mark["variable"] as? String,
                                                                  workType: mark["worktype"] as? String,
                                                                  max: mark["max"] as? String,
                                                                  value: mark["value"] as? String,
                                                                  mark: mark["mark"] as? String,
                                                                  limit: mark["limit"] as? String)
                                            allMarks.append(cdeMark)
                                        }
                                    }
                                    let subject = CdeSubject(name: item["name"] as? String,
                                                             mark: allMarks.first?.mark,
                                                             worktype: marks.first?["worktype"] as? String,
                                                             points: allMarks.first?.value,
                                                             semester: item["semester"] as? String,
                                                             marks: allMarks)
                                    result.append(subject)
                                }
                                self.cdeSbjects = result
                                self.deleteCookies()
                                Config.semestr = result.last?.semester! ?? "1"
                                onSuccess()
                            }
                        }
                    } catch let parseError as NSError {
                        onFailure(parseError)
                        self.deleteCookies()
                        UserDefaults.standard.set(nil, forKey: "login")
                    }
                }
            })
            task.resume()
        }) { (error) in
            onFailure(error)
            self.deleteCookies()
        }
    }
    
    
}
