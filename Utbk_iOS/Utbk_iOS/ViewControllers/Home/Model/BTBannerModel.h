//
//  BTBannerModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/28.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBannerModel : NSObject
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *serialNumber;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,assign)int status;
@property(nonatomic,assign)int sysAdvertiseLocation;
@property(nonatomic,copy)NSString *linkUrl;
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
