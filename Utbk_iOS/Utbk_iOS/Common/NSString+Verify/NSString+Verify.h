//
//  NSString+Verify.h
//  IeyeDoctor
//
//  Created by Pizza on 16/4/29.
//  Copyright © 2016年 SuperVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Verify)

BOOL kVerifyStringSuccess(NSString *string);

- (BOOL)verifyAccountInput;

- (BOOL)verifyPhoneNumberInput;

- (BOOL)verifyVerifyCodeInput;

- (BOOL)verifyPasswordInput;

- (BOOL)verifyTelephoneInput;

//- (BOOL)verifyPersonNoInput;

- (BOOL)verifyCouponCode;

- (BOOL)verifyGraphicCode;

//身份证号码
+ (BOOL)verifyIDCardNumber:(NSString *)value;

+ (BOOL)objectIsNotNullString:(id)object;

/*
 将不可识别的字符串改成可在url中识别的unicode
 */
+(NSString *)changeBadString:(NSString *)str;

//省略手机号和邮箱
- (NSString *)leaveOutPhone;
- (NSString *)leaveOutEmail;
@end
