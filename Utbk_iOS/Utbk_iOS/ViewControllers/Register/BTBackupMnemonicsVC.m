//
//  BTBackupMnemonicsVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBackupMnemonicsVC.h"
#import "BTBackupMnemonicsCell.h"
#import "BTComfirmMnemonicsVC.h"
#import "BTMnemonisModel.h"
#import "YLTabBarController.h"

#define KItemHeight  40.f
@interface BTBackupMnemonicsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (strong, nonatomic) BTMnemonisModel *mnemonisModel;

@end

@implementation BTBackupMnemonicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"备份助记词");
    [self setupLayout];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction{
    if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setupBind{
    WeakSelf(weakSelf)
    if (self.userInfo) {//本地取
        self.nextStepBtn.hidden = YES;
        self.mnemonisModel = [[BTMnemonisModel alloc]init];
        self.mnemonisModel.mnemonicWordsList = [self.userInfo.mnemonicWords componentsSeparatedByString:@","];
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];;
        self.collectionHeight.constant = self.collectionView.contentSize.height;
    }else{
        [[XBRequest sharedInstance]postDataWithUrl:MnemonicWordsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
            if (NetSuccess) {
                StrongSelf(strongSelf)
                strongSelf.mnemonisModel = [BTMnemonisModel mj_objectWithKeyValues:responseResult[@"data"]];
                [strongSelf.collectionView reloadData];
                [strongSelf.collectionView layoutIfNeeded];;
                strongSelf.collectionHeight.constant = self.collectionView.contentSize.height;
            }else{
                ErrorToast
            }
        }];
    }
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

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mnemonisModel.mnemonicWordsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTBackupMnemonicsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BTBackupMnemonicsCell class]) forIndexPath:indexPath];
    [cell configureCellWithMnemonicsModel:self.mnemonisModel.mnemonicWordsList[indexPath.row]];
    return cell;
}
//下一步
- (IBAction)nextStep:(UIButton *)sender {
    BTComfirmMnemonicsVC *comfirm = [[BTComfirmMnemonicsVC alloc]init];
    comfirm.mnemonisModel = self.mnemonisModel;
    [self.navigationController pushViewController:comfirm animated:YES];
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
