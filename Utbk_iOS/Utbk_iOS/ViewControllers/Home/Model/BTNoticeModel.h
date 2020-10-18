//
//  BTNoticeModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTNoticeModel : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,assign)BOOL isTop;

@end

NS_ASSUME_NONNULL_END
