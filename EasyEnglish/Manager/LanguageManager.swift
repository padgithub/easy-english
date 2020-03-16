//
//  LanguageManager.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/27/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import Foundation

enum GlobalConstants : String {
    case englishCode = "en"
    case vietnameeseLangCode = "vi"
}

class LanguageManager: NSObject {
    
    static let shared = LanguageManager()
    
    var availableLocales = [CustomLocale]()
    var lprojBasePath = String()
    
    override fileprivate init() {
        super.init()
        let english = CustomLocale(languageCode: GlobalConstants.englishCode.rawValue, countryCode: "gb", name: "United Kingdom")
        let vietnamese  = CustomLocale(languageCode: GlobalConstants.vietnameeseLangCode.rawValue, countryCode: "vn", name: "Việt Nam")
        let jp  = CustomLocale(languageCode: GlobalConstants.vietnameeseLangCode.rawValue, countryCode: "jp", name: "日本")
        self.availableLocales = [english,vietnamese,jp]
        self.lprojBasePath =  getSelectedLocale()
    }
    
    fileprivate func getSelectedLocale() -> String{
        let lang = Locale.preferredLanguages//returns array of preferred languages
        let languageComponents: [String : String] = Locale.components(fromIdentifier: lang[0])
        if let languageCode: String = languageComponents["kCFLocaleLanguageCodeKey"]{
            for customlocale in availableLocales {
                if(customlocale.languageCode == languageCode){
                    return customlocale.languageCode!
                }
            }
        }
        return "en"
    }
    
    func getCurrentBundle()->Bundle{
        if let bundle = Bundle.main.path(forResource: lprojBasePath, ofType: "lproj"){
            return Bundle(path: bundle)!
        }else{
            fatalError("lproj files not found on project directory. /n Hint:Localize your strings file")
        }
    }
    
    func setLocale(_ langCode:String){
        UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        self.lprojBasePath = getSelectedLocale()
    }
}

class CustomLocale: NSObject {
    var name:String?
    var languageCode:String?
    var countryCode:String?
    
    init(languageCode: String,countryCode:String,name: String) {
        self.name = name
        self.languageCode = languageCode
        self.countryCode = countryCode
    }
}
