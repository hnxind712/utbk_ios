//
//  BTConfigureModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/24.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTConfigureModel : NSObject

@property (copy, nonatomic) NSString *dataType;
@property (assign, nonatomic) NSInteger ID;//配置对应的ID
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *value;
/**
 dataType = "string ";
 id = 21;
 key = "usdt-link-type";
 remarks = "USDT\U94fe\U7c7b\U578b";
 value = "ERC20,TRC20";
 */
@end

NS_ASSUME_NONNULL_END
