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

#define   HOST     @"http://8.129.19.4:20080/"//正拓测试

#else

#define   HOST     @"http://8.129.19.4:20080/"//正拓测试

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
uc/import/address"


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
//激活第一步
#define   activeOneAPI   @""HOST@"\
uc/member/activeOne"

//获取母币
#define   getMotherCoinWalletAPI   @""HOST@"\
uc/member/getMotherCoinWallet"

//查询空投排名
#define   getAirdropTopAPI   @""HOST@"\
mine/getAirdropTop"

//币种汇率转换
#define   exchangeRateAPI   @""HOST@"\
market/exchange-rate"

#endif /* UtbkRequestUrl_h */
