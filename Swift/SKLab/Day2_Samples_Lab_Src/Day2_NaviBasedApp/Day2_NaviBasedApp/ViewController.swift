//
//  ViewController.swift
//  Day2_NaviBasedApp
//
//  Created by Jaehoon Lee on 2017. 4. 13..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*
     세그웨이 ID를 DetailSegue
     상세 뷰 컨트롤러 클래스 만들기 : DetailViewController
     스토리보드에서 상세 씬의 클래스 설정
     DetailViewController에 data 문자열 프로퍼티 만들기
     DetailViewController의 viewWillAppear에서 data의 값을 레이블에 반영
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue : \(segue)")
        if segue.identifier == "DetailSegue" {
            let detail = segue.destination as! DetailViewController
            detail.data = "Hello"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

