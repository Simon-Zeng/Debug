//
//  NSString+eLongExtension.m
//  eLongFramework
//
//  Created by Dawn on 15/5/2.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "NSString+eLongExtension.h"
#import "RegexKitLite.h"
#import "JSONKit.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access



#define REGULATION_PHONE		@"((\\d{10,11})|(\\d{7,8})|(\\d{4}|\\d{3})-+(\\d{7,8})|(\\d{4}|\\d{3})-+(\\d{7,8}|\\d{4}|\\d{3})-+(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-+(\\d{4}|\\d{3}|\\d{2}|\\d{1}))"


@implementation NSString (eLongExtension)
- (BOOL)empty {
    if (!self) {
        return YES;
    }
    return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty {
    if (!self) {
        return NO;
    }
    return [self length] > 0 ? YES : NO;
}

- (BOOL)isNumber {
    return [[NSString stringWithFormat:@"%lld", [self longLongValue]] isEqualToString:self];
}

- (NSString *)sensitiveWord{
    static NSString *const sensitiveWord = @"发轮功,张三,李四,王五,SB,逼,傻逼,傻冒,王八,王八蛋,混蛋,你妈,你大爷,操你妈,你妈逼,先生,小姐,男士,女士,测试,小沈阳,丫蛋,男人,女人,骚,騒,搔,傻,逼,叉,瞎,屄,屁,性,骂,疯,臭,贱,溅,猪,狗,屎,粪,尿,死,肏,骗,偷,嫖,淫,呆,蠢,虐,疟,妖,腚,蛆,鳖,禽,兽,屁股,畸形,饭桶,脏话,可恶,吭叽,小怂,杂种,娘养,祖宗,畜生,姐卖,找抽,卧槽,携程,无赖,废话,废物,侮辱,精虫,龟头,残疾,晕菜,捣乱,三八,破鞋,崽子,混蛋,弱智,神经,神精,妓女,妓男,沙比,恶性,恶心,恶意,恶劣,笨蛋,他丫,她丫,它丫,丫的,给丫,删丫,山丫,扇丫,栅丫,抽丫,丑丫,手机,查询,妈的,犯人,垃圾,死鱼,智障,浑蛋,胆小,糙蛋,操蛋,肛门,是鸡,无赖,赖皮,磨几,沙比,智障,犯愣,色狼,娘们,疯子,流氓,色情,三陪,陪聊,烤鸡,下流,骗子,真贫,捣乱,磨牙,磨积,甭理,尸体,下流,机巴,鸡巴,鸡吧,机吧,找日,婆娘,娘腔,恐怖,穷鬼,捣乱,破驴,破罗,妈必,事妈,神经,脑积水,事儿妈,草泥马,杀了铅笔,1,2,3,4,5,6,7,8,9,10,J8,s.b,sb,sbbt,Sb＋Sb,sb＋bt,bt＋sb, saorao,SAORAO,Fuck,shit,0,\\*,\\/,\\.,\\(,\\),（,）,:,;,-,_,－,谢先生,谢小姐,蔡先生,蔡小姐,常先生,常小姐,陈先生,陈小姐,陈女士,崔先生,崔小姐,高先生,高小姐,高女士,郭先生,郭小姐,郭女士,黄先生,黄小姐,黄女士,刘先生,刘小姐,刘女士,李先生,李小姐,李女士,王先生,王小姐,王女士,朱先生,朱小姐,朱女士,周先生,周小姐,周女士,郑先生,郑小姐,郑女士,赵先生,赵小姐,赵女士,张先生,张小姐,张女士,章先生,章小姐,杨先生,杨小姐,杨女士,徐先生,徐小姐,徐女士,许先生,许小姐,许女士,贾先生,贾小姐,季先生,季小姐,康先生,康小姐,路先生,路小姐,马先生,马小姐,马女士,彭先生,彭小姐,秦先生,秦小姐,任先生,任小姐,孙先生,孙小姐,谭先生,谭小姐,吴先生,吴小姐,叶先生,叶小姐,应先生,应小姐,于先生,于小姐,白先生,白小姐,包先生,包小姐,毕先生,毕小姐,曹先生,曹小姐,成先生,成小姐,程先生,程小姐,戴先生,戴小姐,邓先生,邓小姐,丁先生,丁小姐,董先生,董小姐,窦先生,窦小姐,杜先生,杜小姐,段先生,段小姐,方先生,方小姐,范先生,范小姐,冯先生,冯小姐,顾先生,顾小姐,古先生,古小姐,关先生,关小姐,管先生,管小姐,韩先生,韩小姐,潘先生,潘小姐,钱先生,钱小姐,齐先生,齐小姐,沈先生,沈小姐,石先生,石小姐,史先生,史小姐,宋先生,宋小姐,苏先生,苏小姐,唐先生,唐小姐,test,ceshi, ,郝先生,郝小姐,何先生,何小姐,贺先生,贺小姐,侯先生,侯小姐,胡先生,胡小姐,华先生,华小姐,江先生,江小姐,姜先生,姜小姐,蒋先生,蒋小姐,焦先生,焦小姐,金先生,金小姐,孔先生,孔小姐,梁先生,梁小姐,林先生,林小姐,罗先生,罗小姐,孟先生,孟小姐,牛先生,牛小姐,";
    if ([self notEmpty]) {
        NSString *regexStr = [self stringByAppendingString:@","];   // 加上逗号，匹配时变为绝对匹配
        BOOL isMatch = NO;
        if ([sensitiveWord empty]) {
            isMatch = NO;
        }
        
        NSError* error = NULL;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSInteger matchCnt = [regex numberOfMatchesInString:sensitiveWord options:0 range:NSMakeRange(0, sensitiveWord.length)];
        isMatch = (matchCnt > 0);
        
        if (isMatch) {
            return self;
        }
    }
    return nil;
}

- (NSString *)stringByReplaceWithAsteriskToIndex:(NSInteger)length {
    return [NSString stringWithFormat:@"%@%@",[@"**********************************************" substringToIndex:length],
            [self substringFromIndex:length]];
}

- (NSString *)stringByReplaceWithAsteriskFromIndex:(NSInteger)length {
    return [[self substringToIndex:length] stringByPaddingToLength:self.length withString:@"*" startingAtIndex:0];
}

- (NSString *)stringByReplaceWithAsteriskWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:range.location] stringByPaddingToLength:range.location + range.length withString:@"*" startingAtIndex:0], [self substringFromIndex:range.location + range.length]];
}

- (id)JSONValue {
    return [self mutableObjectFromJSONStringWithParseOptions:JKParseOptionValidFlags];
}

- (NSString *)stringByPattern:(NSString *)format {
    return [self stringByMatching:format];
}

- (NSString *)md5Coding
{
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)stringWithCreditFromat {
    NSMutableString *mString = [NSMutableString stringWithCapacity:2];
    for (int i = 0; i < self.length; i ++) {
        unichar character = [self characterAtIndex:i];
        if ((i + 1) % 4 == 0) {
            [mString appendFormat:@"%c   ",character];
        }
        else {
            [mString appendFormat:@"%c ", character];
        }
    }
    
    return mString;
}

// 手机号部分隐藏
- (NSString *)stringPhoneCodeHidden
{
    NSRange range = NSMakeRange(3, 4);
    if ([self length] < (range.location+range.length))
    {
        return self;
    }
    else
    {
        return  [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
}

- (NSString *)stringByInsertingWithFormat:(NSString *)format perDigit:(NSInteger)digit {
    NSMutableString *mString = [NSMutableString stringWithCapacity:2];
    for (int i = 0, count = 0; i < self.length; i ++) {
        unichar character = [self characterAtIndex:i];
        if ((i + 1) % digit == 0) {
            // 除最后一位外，都加上分隔符
            [mString appendFormat:@"%c%@", character, format];
            count ++;
        }
        else {
            [mString appendFormat:@"%c", character];
        }
    }
    
    return mString;
}

- (NSString *)addHtmlPhoneMark {
    NSMutableString *htmlStr = [NSMutableString stringWithString:self];
    NSArray *phoneArray = [htmlStr componentsMatchedByRegex:REGULATION_PHONE];
    
    for (NSString *str in phoneArray) {
        [htmlStr replaceOccurrencesOfString:str
                                 withString:[NSString stringWithFormat:@"<a href=\"tel:%@\" tel:%@>%@</a>", str, str, str]
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, htmlStr.length)];
    }
    
    return htmlStr;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


- (NSString *)htmlStringWithFont:(NSString *)family textSize:(CGFloat)size textColor:(NSString *)color {
    return [NSString stringWithFormat:@"<html><style type=\"text/css\">body {font-family: \"%@\";font-size: %f;color: %@}</style><body>%@</body></html>",
            family, size, color, self];
}

- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange
{
    if ([NSStringFromClass([self class]) isEqualToString:@"NSTaggedPointerString"] || [NSStringFromClass([string class]) isEqualToString:@"NSTaggedPointerString"]) {
        NSUInteger wordNum1 = self.length;
        NSUInteger wordNUm2 = string.length;
        NSInteger minWordNum = MIN(wordNum1, wordNUm2);
        NSRange newRange = compareRange;
        if (compareRange.location >= minWordNum) {
            newRange = NSMakeRange(minWordNum, 0);
        }else {
            if ((compareRange.location + compareRange.length) > minWordNum) {
                newRange = NSMakeRange(compareRange.location, (minWordNum - compareRange.location));
            }
        }
        NSComparisonResult result = [self compare:string options:mask range:newRange locale:nil];
        if (result == NSOrderedSame) {
            if (compareRange.length > newRange.length) {
                if (wordNum1 > wordNUm2) {
                    result = NSOrderedDescending;
                }else if (wordNum1 < wordNUm2) {
                    result = NSOrderedAscending;
                }
            }
        }
        return result;
    }else {
        NSComparisonResult result = [self compare:string options:mask range:compareRange locale:nil];
        return result;
    }
}

+ (NSString *)reverse:(NSString *)str {
    unsigned long len;
    len = [str length];
    unichar a[len];
    for(int i = 0; i < len; i++) {
        unichar c = [str characterAtIndex:len-i-1];
        a[i] = c;
    }
    NSString *str1 = [NSString stringWithCharacters:a length:len];
    return str1;
}

@end
