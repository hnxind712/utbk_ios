//
//  UtbkRequestUrl.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#ifndef UtbkRequestUrl_h
#define UtbkRequestUrl_h

#ifdef DEBUG

//#define   HOST     @"http://8.129.19.4:20080/"//测试环境地址
#define   HOST     @"http://47.242.6.150:80/"//正式环境地址

#else

//#define   HOST     @"http://8.129.19.4:20080/"//测试环境地址
#define   HOST     @"http://47.242.6.150:80/"

#endif

//创建地址
#define   CreateAddressAPI   @""HOST@"\
uc/address/createAddress"

//获取助记词
#define   MnemonicWordsAPI   @""HOST@"\
uc/address/mnemonicWords"

//校验助记词
#define   checkMnemonicWordsAPI   @""HOST@"\
uc/address/checkMnemonicWords"

//导入助记词
#define   importMnemonicAPI   @""HOST@"\
uc/address/importAddress"


//矿池相关配置
#define   getMinConfigsAPI   @""HOST@"\
mine/getMinConfigs"

//获取用户空投矿池get
#define   getMineWalletAPI   @""HOST@"\
mine/getMineWallet"

//获取空投收益记录、划转记录
#define   getMineLogsAPI   @""HOST@"\
mine/getMineLogs"

//资产划转
#define   transferWalletAPI   @""HOST@"\
mine/transferWallet"

//获取用户共享矿池
#define   getMineShareAPI   @""HOST@"\
mine/getMineShare"

//获取用户共享矿池记录
#define   getMineShareLogsAPI   @""HOST@"\
mine/getMineShareLogs"

//贡献值转入
#define   addMineShareAPI   @""HOST@"\
mine/addMineShare"

//团队持仓
#define   getTeamInfoAllAPI   @""HOST@"\
uc/mine/getTeamInfoAll"

#define   getTeamMembersAPI   @""HOST@"\
uc/mine/getTeamMembers"

//激活第一步
#define   activeOneAPI   @""HOST@"\
uc/member/activeOne"

//获取母币
#define   getMotherCoinWalletAPI   @""HOST@"\
uc/member/getMotherCoinWallet"

//母币划转
#define   motherCoinWalletTransferAPI   @""HOST@"\
uc/transfer/huazhuan"

//母币转账
#define   mothertransferAPI   @""HOST@"\
uc/transfer/mothertransfer"

//母币转账记录
#define   pageMotherCoinLogsAPI   @""HOST@"\
uc/transfer/pageMotherCoinLogs"

//上币
#define   saveUpCoinApplyAPI   @""HOST@"\
uc/transfer/saveUpCoinApply"

//查询空投排名
#define   getAirdropTopAPI   @""HOST@"\
mine/getAirdropTop"

//币种汇率转换
#define   exchangeRateAPI   @""HOST@"\
market/exchange-rate"

//关联相关币种
#define   getCoinRelationAPI   @""HOST@"\
/mine/getCoinRelation"

//获取用户激活状态
#define   getMemberStatusAPI   @""HOST@"\
uc/member/getMemberStatus"

//验证交易密码
#define   verifyTradepsswordAPI   @""HOST@"\
/member/getMnemonicWords"

#endif /* UtbkRequestUrl_h */
