//
//  commissionViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/30.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "BTBaseViewController.h"

@interface commissionViewController : BTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *symbol;
@end
