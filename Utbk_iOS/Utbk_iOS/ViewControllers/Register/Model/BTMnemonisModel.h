//
//  BTMnemonisModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BTMnemonisListModel : NSObject

@property (assign, nonatomic) BOOL selected;
@property (copy, nonatomic) NSString *mnemonis;//助记词

@end
@interface BTMnemonisModel : NSObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *secretKey;//助记词
@property (strong, nonatomic) NSArray <NSString *>*mnemonicWordsList;
@property (strong, nonatomic) NSArray *showArray;//用于验证里面显示的数组，直接转为model

@end

NS_ASSUME_NONNULL_END
