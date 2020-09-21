//
//  BTMnemonisModel.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTMnemonisModel.h"
@implementation BTMnemonisListModel

@end

@implementation BTMnemonisModel

- (NSArray *)showArray{
    if (!_showArray) {
        NSArray *randomArr = [self.mnemonicWordsList sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
           int seed = arc4random_uniform(2);
           if (seed) {
               return [str1 compare:str2];
           } else {
               return [str2 compare:str1];
           }
         }];
        NSMutableArray *showList = [NSMutableArray array];
        [randomArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BTMnemonisListModel *model = [[BTMnemonisListModel alloc]init];
            model.mnemonis = obj;
            model.selected = NO;
            [showList addObject:model];
        }];
        _showArray = showList;
    }
    return _showArray;
}
@end
