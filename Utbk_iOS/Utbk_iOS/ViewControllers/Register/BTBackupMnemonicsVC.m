//
//  BTBackupMnemonicsVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBackupMnemonicsVC.h"
#import "BTBackupMnemonicsCell.h"

#define KItemHeight  40.f
@interface BTBackupMnemonicsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation BTBackupMnemonicsVC
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"SEEN",@"WED",@"DOVE",@"ROOF",@"CURB",@"WHEN",@"BARE",@"MARY",@"RIOE",@"BARE",@"MARY",@"RIOE"];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"备份助记词");
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    CGFloat itemWidth = (SCREEN_WIDTH - 24)/3;
    self.layout.itemSize = CGSizeMake(floor(itemWidth), KItemHeight);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.sectionInset = UIEdgeInsetsZero;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BTBackupMnemonicsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BTBackupMnemonicsCell class])];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView layoutIfNeeded];
    self.collectionHeight.constant = self.collectionView.contentSize.height;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTBackupMnemonicsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BTBackupMnemonicsCell class]) forIndexPath:indexPath];
    [cell configureCellWithMnemonicsModel:self.dataSource[indexPath.row]];
    return cell;
}
//下一步
- (IBAction)nextStep:(UIButton *)sender {
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
