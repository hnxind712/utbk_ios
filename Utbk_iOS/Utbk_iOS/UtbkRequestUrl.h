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

//矿池相关配置
#define   getMinConfigsAPI   @""HOST@"\
mine/getMinConfigs"

//获取用户空投矿池get  获取空投记录post
#define   getMineWalletAPI   @""HOST@"\
mine/getMineWallet"

//资产划转
#define   transferWalletAPI   @""HOST@"\
mine/transferWallet"

//获取用户共享矿池
#define   transferWalletAPI   @""HOST@"\
mine/transferWallet"

#endif /* UtbkRequestUrl_h */
