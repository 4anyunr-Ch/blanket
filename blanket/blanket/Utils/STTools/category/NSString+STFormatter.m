//
//  NSString+Format.m
//  STTools
//
//  Created by stoneobs on 16/10/8.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "NSString+STFormatter.h"

@implementation NSString (STFormatter)
/// 用时间拽string调用 并传入时间格式 返回对应时间格式string e.g: yyyy-MM-dd HH:mm:ss
- (NSString *)st_stringByFormatString:(NSString *)formatStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:formatStr];
    NSTimeInterval time = [self doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [fmt stringFromDate:date];
}
//时间转时间戳
- (NSString*)st_timeWithString:(NSString*)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate * date =[formatter dateFromString:self];
    NSTimeInterval time =[date timeIntervalSince1970];
    NSInteger num =time;
    NSString * finsh =[NSString stringWithFormat:@"%ld",num];
    return finsh;
}
//字典转JSON格式字符串
+ (NSString*)st_dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSDictionary *)st_dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return [NSDictionary dictionary];
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"JSON解析失败：%@",err);
        
        return [NSDictionary dictionary];
        
    }
    return dic;
}

- (BOOL)st_isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
- (NSString *)st_underlineFromCamel
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)st_camelFromUnderline
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

- (NSString *)st_firstCharLower
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)st_firstCharUpper
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}
-(NSDate*)st_dateWithString:(NSString*)formatStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate * date =[formatter dateFromString:self];
    
    return date;
    
}
- (BOOL)st_isPureNumandCharacters
{
    NSString *  string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (NSString *)st_getMailNameDefaultChar{
    NSMutableArray *zhStringArray = [NSMutableArray arrayWithCapacity:0];
    NSString *copyStr = [self copy];
    NSMutableString *realStr = [[NSMutableString alloc] init];
    NSInteger length = self.length;
    for(int i = 0; i < copyStr.length; i++){
        if(length == 0){
            break;
        }
        unichar ch = [copyStr characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff)//如何判断是汉字
        {
            //如果是汉子需要做其他处理 可以在这里做处理
            [zhStringArray addObject:[copyStr substringWithRange:NSMakeRange(i,1)]];
        }
        [realStr appendString:[copyStr substringWithRange:NSMakeRange(i,1)]];
        
        length = length - 1;
    }
    if (zhStringArray.count > 0) { //有中文取最后一个
        realStr = [zhStringArray lastObject];
    } else {//纯字母的取第一个
        realStr = [[realStr substringToIndex:1] mutableCopy];
    }
    return realStr;
}
//计算s剩余时间时长,分。秒
- (NSString*)st_timeForduration:(NSTimeInterval)time
{
    NSInteger num = time;
    NSString * hour = [NSString stringWithFormat:@"%ld",num/3600];
    NSString * minte =[NSString stringWithFormat:@"%ld",num/60];
    NSString * secend = [NSString stringWithFormat:@"%ld",num];
    if (hour.integerValue>=1) {
        hour = [self st_format:hour];
        minte = [NSString stringWithFormat:@"%ld",num%3600/60];
        minte = [self st_format:minte];
        
        secend = [NSString stringWithFormat:@"%ld",num%3600%60];
        secend = [self st_format:secend];
        return [NSString stringWithFormat:@"%@:%@:%@",hour,minte,secend];
    }
    hour = @"00";
    minte = [NSString stringWithFormat:@"%ld",num/60];
    minte = [self st_format:minte];
    
    secend = [NSString stringWithFormat:@"%ld",num%60];
    secend = [self st_format:secend];
    return [NSString stringWithFormat:@"%@:%@:%@",hour,minte,secend];
}
- (NSString*)st_format:(NSString*)one
{
    if (one.integerValue<10) {
        return [NSString stringWithFormat:@"0%@",one];
    }
    return one;
}
- (CGFloat)st_heigthWithwidth:(CGFloat)width font:(CGFloat)font
{
    
    NSString * str =self ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}
- (CGFloat)st_widthWithheight:(CGFloat)height font:(CGFloat)font
{
    NSString * str =self ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}
+ (void)lableAutoAdjustWitdhWithLabel:(UILabel *)lable{
    CGFloat witdh = [lable.text st_widthWithheight:lable.frame.size.height font:lable.font.pointSize];
    lable.width = witdh;
}
+ (void)lableAutoAdjustheightWithLabel:(UILabel *)lable{
    CGFloat height = [lable.text st_heigthWithwidth:lable.frame.size.width font:lable.font.pointSize];
    lable.height = height;
}
- (NSString *)st_disable_emojiSrting
{
    NSString * text = self;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
//安全手机号
- (NSString*)st_safetyPhone
{
    if (self.length != 11) {
        // NSLog(@"电话号码不是11位,修改失败");
        return self;
    }
    NSString * beginStr = [self substringToIndex:3];
    NSString * lastStr = [self substringFromIndex:7];
    return  [NSString stringWithFormat:@"%@****%@",beginStr,lastStr];
}
//安全邮箱 56****@qq.com
- (NSString *)st_safetyEmail
{
    NSArray * array = [self componentsSeparatedByString:@"@"];
    if (array.count != 2) {
        //NSLog(@"邮箱格式错误");
        return self;
    }
    NSString * begin = array.firstObject;
    NSString * first = [begin substringToIndex:2];
    
    NSString * headStr = [NSString stringWithFormat:@"%@****",first];
    NSString * footStr = array.lastObject;
    
    NSString * finsh = [[NSString stringWithFormat:@"%@@%@",headStr ,footStr ] lowercaseString];
    
    return finsh;
}
// 判断邮箱格式
- (BOOL)st_isValidateEmail;
{
    NSString * email = self;
    if (!email) {
        return NO;
    }
    // [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
    NSString *emailRegex = @"^[0-9a-zA-Z][0-9a-zA-Z_.-]{0,31}@([0-9a-zA-Z][0-9a-zA-Z-]{0,30}[0-9A-Za-z]\\.){1,4}[a-zA-Z]{2,4}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

// 判断是否为电话号码
- (BOOL)st_isValidatePhoneNumber;
{
    NSString * phoneNumber = self;
    if (phoneNumber.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[07]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 判断是否3~20为电话号码
- (BOOL)st_isValidateTelephoneNumber
{
    NSString * phoneNumber = self;
    NSString *MOBILE = @"[0-9]{3,20}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:phoneNumber] == YES) {
        return  YES;
    } else {
        return NO;
    }
}

// 判断url格式
- (BOOL)st_isValidateUrl
{
    NSString * url = self;
    // [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
    static NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlPredicate evaluateWithObject:url];
}

- (BOOL)st_isBlank
{
    NSString * string = self;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (NSString *)st_transformToChinese
{
    NSString *pinyin = [self copy];
    if (!pinyin.length) {
        return @"";
    }
    
    if (CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO)) {
        
    }
    // NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}
- (NSDate *)st_dateByFormatString:(NSString *)formatStr
{
    return [NSDate date];
}

/*- (NSAttributedString *)convertAttributeStringWithKeyWord:(NSString *)keyword
 attributes:(NSDictionary *)optins{
 
 NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
 NSRange range = [self rangeOfString:keyword];
 if (range.location != NSNotFound) {
 [attributeString addAttributes:optins range:range];
 }
 return attributeString;
 }*/

/**
 将字符串中所有匹配结果进行高亮显示
 */
- (NSAttributedString *)st_convertAttributeStringWithKeyWord:(NSString *)keyword
                                                  attributes:(NSDictionary *)optins{
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range;
    if ((range = [[self uppercaseString] rangeOfString:[keyword uppercaseString] ]).location != NSNotFound) {
        [attributeString addAttributes:optins range:range];
        return attributeString;
        
    }else if((range = [[[self st_getPinYinLetter] uppercaseString] rangeOfString:[keyword uppercaseString]]).location != NSNotFound){
        [attributeString addAttributes:optins range:range];
        return attributeString;
    }else{
        return attributeString;
    }
    
}

- (NSAttributedString *)st_convertAttributeStringWithKeyWords:(NSArray *)keywords
                                                   attributes:(NSArray<NSDictionary *> *)options{
    NSAssert(keywords.count == options.count, @"属性与关键字的数量保持一致");
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (int i = 0; i < keywords.count; i ++) {
        @autoreleasepool {
            NSString *keyword = keywords[i];
            NSRange range = [self rangeOfString:keyword];
            if (range.location != NSNotFound) {
                NSDictionary *option = options[i];
                [attributeString addAttributes:option range:range];
            }
        }
    }
    return attributeString;
}
- (BOOL)st_isIncludeSpecialCharacters{
    
    NSString * content = self;
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}
//获取首字母
-(NSString *)st_getPinYinLetter{
    NSMutableString *temp = [[NSMutableString alloc]initWithString:@""];
    for(int i =0; i < [self length]; i++)
    {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:[self substringWithRange:NSMakeRange(i, 1)]];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        if (ms.length<1)continue;
        [temp appendString:[[ms substringToIndex:1] uppercaseString]];
    }
    return temp;
}
@end

