//
//  ViewController.swift
//  Invitaion
//
//  Created by 현은백 on 2021/12/30.
//

import UIKit

class ViewController: UIViewController {
    
    let string = """
    가나당랑마바사
    abcdefg
    !~!
    🍻🍻🍻
    """
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.0
        imageView.image = UIImage(named: "dinosour")
        return imageView
    }()
    
    let happyNewYearLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.numberOfLines = 1
        label.text = "🐯HAPPY NEW YEAR🐯"
        label.font = UIFont(name: "AvenirNext-HeavyItalic",
                            size: 28)
        return label
    }()
    
    let letterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Medium",
                            size: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        layoutSet()
    }
    
    func diassembleUnicode(_ char: UInt32) -> [UnicodeScalar] {
        
        let x = (char - 0xac00) / 28 / 21
        let y = (char - 0xac00) / 28 % 21
        let z = (char - 0xac00) % 28
        
        let initial = UnicodeScalar(0x1100 + x)// 초성
        let neuter = UnicodeScalar(0x1161 + y)// 중성
        let final = UnicodeScalar(0x11a6 + 1 + z)// 종성
        
        var arr = [initial, neuter, final].compactMap { $0 }
        
        if final == UnicodeScalar(0x11A7) { //받침 없음
            arr.removeLast()
        }
        
        return arr
    }
}

extension ViewController {
    func layoutSet() {
        backgroundSet()
        initialSet()
        happyNewYearLabelLayoutSet()
        letterLabelLayoutSet()
    }
    
    func backgroundSet() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func initialSet() {
        let headLabel = UILabel()
        headLabel.textColor = .systemBackground
        headLabel.text = "Invitation"
        headLabel.font = UIFont(name: "AvenirNext-HeavyItalic",
                                size: 55)
        headLabel.alpha = 0.0
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headLabel)
        [
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ].forEach { $0.isActive = true }
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseInOut, .autoreverse, .repeat],
                       animations: {
                        UIView.modifyAnimations(withRepeatCount: 4,
                                                autoreverses: true,
                                                animations: {
                                                    headLabel.alpha = 1.0
                                                })
                       },
                       completion: { _ in
                        self.view.backgroundColor = .white
                        headLabel.alpha = 0.0
                        headLabel.layer.removeAllAnimations()
                        headLabel.removeFromSuperview()
                        
                        UIView.animate(withDuration: 1.0,
                                       animations: {
                                        self.happyNewYearLabelAnimation()
                                        self.imageView.alpha = 0.2
                                       })
                        self.runTypo()
                       }
        )
    }
    
    
    func letterLabelLayoutSet() {
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterLabel)
        [
            letterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 16),
            letterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -16),
            
            letterLabel.topAnchor.constraint(equalTo: happyNewYearLabel.bottomAnchor,
                                             constant: 40)
        ].forEach { $0.isActive = true }
    }
    
    func happyNewYearLabelLayoutSet() {
        happyNewYearLabel.alpha = 0.0
        happyNewYearLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(happyNewYearLabel)
        [
            happyNewYearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            happyNewYearLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                   constant: 64)
        ].forEach { $0.isActive = true }
    }
    func happyNewYearLabelAnimation() {
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       options: [.curveEaseInOut, .autoreverse, .repeat],
                       animations: {
                        UIView.modifyAnimations(withRepeatCount: .infinity,
                                                autoreverses: true,
                                                animations: {
                                                    self.happyNewYearLabel.alpha = 1.0
                                                })
                       },
                       completion: nil)
    }
    
    func runTypo() {
        var 글자 = ""
        for i in string {
            if let unicodeVal = UnicodeScalar(String(i))?.value {
                if unicodeVal <= UInt32(0xD7A3) && UInt32(0xAC00) <= unicodeVal { //한글 유니코드 범위
                    let arr = diassembleUnicode(unicodeVal)
                    arr.forEach{ char in
                        글자 += "\(char)"
                        let random = Double.random(in: 0.04...0.2)
                        RunLoop.current.run(until: Date() + TimeInterval(random))
                        self.letterLabel.text! = 글자
                    }
                } else {
                    RunLoop.current.run(until: Date() + 0.08)
                    글자 += String(i)
                    self.letterLabel.text! = 글자
                }
                
            }
            RunLoop.current.run(until: Date() + 0.04)
        }
        
    }
}
