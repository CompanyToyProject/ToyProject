//
//  extensions.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation

extension String {
    
    func localizeIdentifier() -> String{

        return Locale(identifier: Locale.preferredLanguages.first!).localizedString(forIdentifier: self) ?? "언어 감지"
    }
    
    func localizeRegion() -> String {
        return Locale(identifier: Locale.preferredLanguages.first!).localizedString(forRegionCode: self) ?? "언어 감지"
    }
    
    func localizeLanguage() -> String{
        return Locale(identifier: Locale.preferredLanguages.first!).localizedString(forLanguageCode: self) ?? "언어 감지"
    }
    
}
