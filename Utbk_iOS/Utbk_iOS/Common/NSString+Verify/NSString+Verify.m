//
//  NSString+Verify.m
//  IeyeDoctor
//
//  Created by Pizza on 16/4/29.
//  Copyright © 2016年 SuperVision. All rights reserved.
//

#import "NSString+Verify.h"

@implementation NSString(Verify)

BOOL kVerifyStringSuccess(NSString *string) {
    if ((string && ![string isKindOfClass:[NSNull class]] && [string isKindOfClass:[NSString class]] && string.length > 0)) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)verifyAccountInput {
    return [self verifyEmailInput] || [self verifyPhoneNumberInput];
}

- (BOOL)verifyEmailInput {
    NSString *emailRegex = @"^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)verifyPhoneNumberInput
{
    NSString *phoneRegex = @"^[1][0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)verifyVerifyCodeInput
{
    NSString *verifyCodeRegex = @"[0-9]{4}";
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyCodeRegex];
    return [verifyCodeTest evaluateWithObject:self];
}

- (BOOL)verifyPasswordInput
{
    NSString *passwordRegex = @".{6,16}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordTest evaluateWithObject:self];
}


- (BOOL)verifyTelephoneInput
{
    
    NSString *telephoneRegex = @"^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telephoneRegex];
    return [telephoneTest evaluateWithObject:self];
}

- (BOOL)verifyCouponCode {
    NSString *verifyCouponCodeRegex = @"^[a-zA-Z0-9]{8}$";
    NSPredicate *couponCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyCouponCodeRegex];
    return [couponCodeTest evaluateWithObject:self];
}

- (BOOL)verifyGraphicCode {
    NSString *verifyGraphicCodeRegex = @"^[a-zA-Z0-9]{4}$";
    NSPredicate *graphicCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyGraphicCodeRegex];
    return [graphicCodeTest evaluateWithObject:self];
}

+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

+(BOOL)objectIsNotNullString:(id)object{
    if ([object isKindOfClass:[NSString class]]) {
        if ([object length]>0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
+(NSString *)changeBadString:(NSString *)str{
    return (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)str,
                                                              
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              
                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));
}

- (NSString *)leaveOutPhone {
    if (self.length == 0 && self.length < 4) {
        return self;
    }
    return [NSString stringWithFormat:@"%@****%@", [self substringWithRange:NSMakeRange(0, 3)], [self substringWithRange:NSMakeRange(self.length-4, 4)]];
}
- (NSString *)leaveOutEmail {
    if (self.length == 0) {
        return self;
    }
    NSRange rangeA = [self rangeOfString:@"@"];
    if (rangeA.location != NSNotFound) {
        return [NSString stringWithFormat:@"%@****%@", [self substringToIndex:1], [self substringWithRange:NSMakeRange(rangeA.location-1, self.length-rangeA.location + 1)]];
    }
    return self;
}
@end
