//
//  ControlTableView.swift
//  YHAPP
//
//  Created by HeHongwe on 16/1/20.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit

class ControlTableView:UITableView{

    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame:frame,style:style)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension ControlTableView:UITableViewDelegate,UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#E6E6E6")
        return view
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(rgba:"#E6E6E6")
        return view
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let tableCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        tableCell.selectionStyle = UITableViewCellSelectionStyle.None
        return tableCell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40;
    }

}
