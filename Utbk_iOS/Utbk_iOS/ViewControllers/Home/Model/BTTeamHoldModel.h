//
//  BTTeamHoldModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTeamHoldModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) NSInteger allAddress;
@property (nonatomic,assign) CGFloat allChicang;
@property (nonatomic,assign) NSInteger allDevices;
@property (nonatomic,assign) CGFloat daChicang;
@property (nonatomic,assign) CGFloat myBTCK;
@property (nonatomic,assign) CGFloat xiaoquChicang;

@end

NS_ASSUME_NONNULL_END
