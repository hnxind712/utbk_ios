//
//  BTComfirmMnemonicsVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTComfirmMnemonicsVC.h"
#import "BTMnemonisConfirmCell.h"
#import "BTMnemonisModel.h"
#import "BTBackupSuccessVC.h"

#define KItemWidth 70.f
#define KItemHeight 40.f

@interface BTComfirmMnemonicsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *selectedLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *showCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *showLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHeight;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation BTComfirmMnemonicsVC
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (NSArray *)showArray{
    if (!_showArray) {
        NSMutableArray *datasource = [NSMutableArray array];
        for (NSInteger i = 0; i < 12; i++) {
            BTMnemonisModel *model = [[BTMnemonisModel alloc]init];
            model.mnemonis = @"SEEN";
            model.selected = NO;
            [datasource addObject:model];
        }
        _showArray = datasource;
    }
    return _showArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"备份助记词");
    [self setupLayout];
}
- (void)setupLayout{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BTMnemonisConfirmCell class]) bundle:nil];
    [self.showCollection registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([BTMnemonisConfirmCell class])];
    [self.selectedCollection registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([BTMnemonisConfirmCell class])];
    
    CGFloat showLeft = 10.f;
    CGFloat left = floor((SCREEN_WIDTH - showLeft * 2 - KItemWidth * 3)/4.f);
    _showLayout.itemSize = CGSizeMake(KItemWidth, KItemHeight);
    _showLayout.sectionInset = UIEdgeInsetsMake(0, showLeft + left, 0, showLeft + left);
    _showLayout.minimumLineSpacing = 0.f;
    _showLayout.minimumInteritemSpacing = left;
    
    CGFloat selectedLeft = 18.f;
    _selectedLayout.itemSize = CGSizeMake(KItemWidth, KItemHeight);
    _selectedLayout.sectionInset = UIEdgeInsetsMake(8.f, selectedLeft, 8.f, selectedLeft);
    _selectedLayout.minimumLineSpacing = 0.f;
    _selectedLayout.minimumInteritemSpacing = floor((SCREEN_WIDTH - selectedLeft * 2 - KItemWidth * 3 - 24.f)/2.f);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.showCollection) {
        return self.showArray.count;
    }
    return self.selectedArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTMnemonisConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BTMnemonisConfirmCell class]) forIndexPath:indexPath];
    if (collectionView == self.selectedCollection) {
        cell.isSelected = YES;
        BTMnemonisModel *model = self.selectedArray[indexPath.row];
        [cell configureCellWithModel:model];
        WeakSelf(weakSelf)
        cell.deleteSelectedMnemonisAction = ^{
            model.selected = NO;
            [weakSelf.selectedArray removeObject:model];
            [weakSelf.showCollection reloadData];
            [weakSelf.selectedCollection reloadData];
            [weakSelf.showCollection layoutIfNeeded];
            [weakSelf.selectedCollection layoutIfNeeded];
            if (weakSelf.selectedCollection.contentSize.height > 168.f) {
                weakSelf.selectedHeight.constant = weakSelf.selectedCollection.contentSize.height;
            }else{
                weakSelf.selectedHeight.constant = 168.f;
            }
            weakSelf.showHeight.constant = weakSelf.showCollection.contentSize.height;
        };
    }else{
        cell.isSelected = NO;
        [cell configureCellWithModel:self.showArray[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.showCollection) {
        BTMnemonisModel *model = self.showArray[indexPath.row];
        if (model.selected) return;//不能重复处理
        model.selected = YES;
        [self.selectedArray addObject:model];
        [self.showCollection reloadData];
        [self.selectedCollection reloadData];
        [self.showCollection layoutIfNeeded];
        [self.selectedCollection layoutIfNeeded];
        if (self.selectedCollection.contentSize.height > 168.f) {
            self.selectedHeight.constant = self.selectedCollection.contentSize.height;
        }else{
            self.selectedHeight.constant = 168.f;
        }
        self.showHeight.constant = self.showCollection.contentSize.height;
    }
}
- (IBAction)completedAction:(UIButton *)sender {
    BTBackupSuccessVC *success = [[BTBackupSuccessVC alloc]init];
    [self.navigationController pushViewController:success animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
