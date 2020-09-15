//
//  ViewController.swift
//  ChinaTelecomDemo
//
//  Created by Larry Mac Pro on 2020/9/14.
//  Copyright © 2020 LarryTeam. All rights reserved.
//

import UIKit

let kAppId = ""    //请在开放平台申请
let kAppSecret = ""    //请在开放平台申请

let w = UIScreen.main.bounds.width

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "中国电信-天翼免密登录"
        
        EAccountOpenPageSDK.initWithAppId(kAppId, appSecret: kAppSecret)
        EAccountOpenPageSDK.printConsoleEnable(true)
        
        let arrs = ["调用预登录接口",
                    "打开全屏登录界面",
                    "打开Mini登录界面center",
                    "打开Mini登录界面bottom"]
        
        let offset_x: CGFloat = 50
        var offset_y: CGFloat = 100
        
        var tagIndex = 10000
        
        for title in arrs {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: offset_x, y: offset_y, width: w - 2.0 * offset_x, height: 50)
            btn.tag = tagIndex
            offset_y += 80
            tagIndex += 10000
            
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 4.0
            btn.layer.borderWidth = 2.0
            btn.layer.borderColor = UIColor.blue.cgColor
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(.blue, for: .normal)
            btn.addTarget(self, action: #selector(handleBtnClick(_:)), for: .touchUpInside)
            view.addSubview(btn)
        }
    }
    
    @objc func handleInterfaceBtnClick () {
        let model = EAccountHYPreLoginModel(defaultConfig: ())
        EAccountOpenPageSDK.requestPRELogin(model, completion: { (resultDic) in
            print("completion dic = \(resultDic)")
        }) { (error) in
            print("error = \(error.localizedDescription)");
        }
    }
    
    @objc func handleBtnClick(_ sender: UIButton) {
        print("handleBtnClick \(sender.tag)");
        if (sender.tag == 10000) {
            handleInterfaceBtnClick()
            return
        }
        
        
        let config = EAccountOpenPageConfig()

        //  配置LoginVC
        switch sender.tag {
        case 20000:
            config.nibNameOfLoginVC = "EAccountAuthVC_dynamic";
        case 30000:
            config.nibNameOfLoginVC = "EAccountMiniAuthVC_center";
        case 40000:
            config.nibNameOfLoginVC = "EAccountMiniAuthVC_bottom";
        default:
            break;
        }
        
        //  nav
        config.navGoBackImg_normal = UIImage(named: "delete_X")!
        config.navGoBackImg_highlighted = UIImage(named: "delete_X")!
        config.navText = ""
        config.navLineColor = .clear
        
        //  logoImg
        config.logoImg = UIImage(named: "noteBook_logo")!
        
        config.paLabelText = "登录即同意$OAT与$CAT"
        config.paLabelOtherTextColor = .purple
        config.paNameColor = .red
        config.partnerPANameColor = .green
        config.partnerPAName = "《36记用户协议》"
        config.webNavText = "服务与隐私协议"
        config.paUrl = "http://www.baidu.com"
        config.pWebNavText = "自定义协议在右"
        
        config.paLabelTextLineSpacing = 4
        
        //  一键登录按钮
        config.logBtnWidth = 100.0
        config.logBtnText = "一键登录"
        
        //  隐藏“其他登录方式”
        config.otherWayLogBtnHidden = true
        
        EAccountOpenPageSDK.openAtuhVC(config, controller: self, clickHandler: { (senderTag) in
            print("senderTag = \(senderTag)")
        }, completion: { (dic) in
            print("completion dic = \(dic)")
            EAccountOpenPageSDK.closeOpenAuthVC()
        }) { (error) in
            print("error = \(error.localizedDescription)");
            EAccountOpenPageSDK.closeOpenAuthVC()
        }
    }
}

