//
//  WalkthroughVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class WalkthroughVC: UIViewController,WalkthroughPageVCDelegate {

    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var walthroughPageVC: WalkthroughPageVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        if let index = walthroughPageVC?.currentIndex{
            switch index {
            case 0...2:
                nextBtn.setTitle("Next", for: .normal)
            case 3:
                nextBtn.setTitle("Done", for: .normal)
                skipBtn.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
        
    }
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if let index = walthroughPageVC?.currentIndex{
            switch index {
            case 0...2:
                walthroughPageVC?.forwardPage()
            case 3:
                UserDefaults.standard.set(true, forKey: "seenWalkthrough")
                dismiss(animated: true, completion: nil)
            default:
                break
            }
            updateUI()
        }
    }
    
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "seenWalkthrough")
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageVC = destination as? WalkthroughPageVC{
            walthroughPageVC = pageVC
            walthroughPageVC?.walkthroughdelegate = self
        }
    }

}
