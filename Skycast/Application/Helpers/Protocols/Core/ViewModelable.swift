//
//  ViewModelable.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation

protocol ViewModelable: AnyObject {
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }
}
