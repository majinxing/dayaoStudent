//
//  NoticeSwiftViewController.swift
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/11.
//  Copyright © 2017年 majinxing. All rights reserved.
//

import UIKit


class NoticeSwiftViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var tableView : UITableView!
    var dataAry :  NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.dataAry = NSMutableArray();
        self.setupTableView();
        
        // Do any additional setup after loading the view.
    }

    func getData(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupTableView(){
        self.tableView = UITableView (frame:self.view.frame,style:UITableViewStyle.plain)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier:"MyTestCell")
        self.view.addSubview(self.tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.dataAry.count>0 {
            return self.dataAry.count
        }
        return 10
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style:UITableViewCellStyle.subtitle,reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = "134543234";
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
