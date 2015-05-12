//
//  HWYAnalysisHtml.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/17.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYAnalysisHtml.h"
#import "TFHpple.h"

@implementation HWYAnalysisHtml

+ (HWYLoginJwzxData *)getLoginJwzxDataFromHtml:(NSString *)responseString and:(id)responseObject {
    HWYLoginJwzxData *jwzx = [[HWYLoginJwzxData alloc] init];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"gb2312"];
    TFHppleElement *element = nil;
    NSString *content = nil;
    if ([responseString rangeOfString:@"alert" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        element = [xpathParser peekAtSearchWithXPathQuery:@"//script[2]/text()"];
        content = [element content];
        NSRange start = [content rangeOfString:@"alert(\""];
        NSRange end = [content rangeOfString:@"<br>\")"];
        content = [content substringToIndex:end.location];
        content = [content substringFromIndex:(start.location+start.length)];
        jwzx.success = NO;
        jwzx.content = content;
    }
    else {
        element = [xpathParser peekAtSearchWithXPathQuery:@"//table/tr[2]/td[2]/text()"];
        content = [element content];
        jwzx.success = YES;
        jwzx.content = content;
    }
    NSLog(@"%d-%@", jwzx.success, jwzx.content);
    return jwzx;
}

+ (NSArray *)getInformationArrFromHtml:(id)responseObject{
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"GBK"];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//table[1]//td/text()"];
    TFHppleElement *element = nil;
    NSString *content = nil;
    NSMutableArray *infoArr = [NSMutableArray array];
    for (int i = 0; i < elements.count; i++) {
        element = [elements objectAtIndex:i];
        content = [element content];
        [infoArr addObject:content];
    }
    [infoArr removeObjectAtIndex:5];
    [infoArr removeObjectAtIndex:5];
    [infoArr removeObjectAtIndex:0];
    NSLog(@"%@", infoArr);
    return infoArr;
}

+ (NSArray *)getScheduleArrWithHttp:(id)responseObject {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"gb2312"];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//body/script/text()"];
    TFHppleElement *element = nil;
    NSString *content = nil;
    NSMutableArray *scheduleArr = [NSMutableArray array];
    NSArray *temp =[NSArray array];
    for (int i = 0; i < elements.count; i++) {
        element = [elements objectAtIndex:i];
        content = [element content];
//        content = [content stringByReplacingOccurrencesOfString:@"InsertSchedule(\"" withString:@""];
//        NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"\""];
//        temp = [content componentsSeparatedByCharactersInSet:character];
        
        temp = [content componentsSeparatedByString:@"(\""];
        temp = [temp[1] componentsSeparatedByString:@"\")"];
        temp = [temp[0] componentsSeparatedByString:@"\",\""];
        [scheduleArr addObject:temp];
    }
    NSLog(@"%@", scheduleArr);
    return scheduleArr;
}

+ (NSArray *)getReportCountArrWithHttp:(id)responseObject {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"gb2312"];
    TFHppleElement *element = [xpathParser peekAtSearchWithXPathQuery:@"//script/text()"];
    NSString *content = [element content];
    NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"=;"];
    NSArray *count = [content componentsSeparatedByCharactersInSet:character];
    NSArray *reportCountArr = @[count[1], count[3], count[5], count[7]];
    NSLog(@"%@", reportCountArr);
    return reportCountArr;
}

+ (NSArray *)getReportCardArrWithHttp:(id)responseObject {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"gb2312"];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//body/table/tr[3]//table//td/text()"];
    TFHppleElement *element = nil;
    NSString *content = nil;
    NSMutableArray *reportCardArr = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < elements.count; i++) {
        element = [elements objectAtIndex:i];
        content = [element content];
        [tempArr addObject:content];
        if ((i+1) % 9 == 0) {
            [reportCardArr addObject:tempArr];
            tempArr = [NSMutableArray array];
        }
    }
    [reportCardArr removeObjectAtIndex:0];
    NSLog(@"%@", reportCardArr);
    return reportCardArr;
}

+ (NSString *)getLoginSzgdLtWithHttp:(id)responseObject {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"utf-8"];
    TFHppleElement *element = [xpathParser peekAtSearchWithXPathQuery:@"//div[6]/input[2]/@value"];
    NSString *lt = [element text];
    NSLog(@"%@", lt);
    return lt;
}

+ (HWYLoginSzgdData *)getLoginSzgdDataWithHttp:(id)responseObject {
    HWYLoginSzgdData *szgd = [[HWYLoginSzgdData alloc] init];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"gb2312"];
    TFHppleElement *element = [xpathParser peekAtSearchWithXPathQuery:@"//title/text()"];
    NSString *content = [element content];
    NSLog(@"%@", content);
    if ([content isEqualToString:@"CAS认证转向"]) {
        szgd.success = YES;
        element = [xpathParser peekAtSearchWithXPathQuery:@"//a/@href"];
        szgd.href = [element text];
        NSLog(@"%@", szgd.href);
    } else if ([content isEqualToString:@"单一登陆验证"]) {
        szgd.success = NO;
    } else {
        szgd.success = NO;
        xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject encoding:@"utf-8"];
        element = [xpathParser peekAtSearchWithXPathQuery:@"//div[6]/input[2]/@value"];
        szgd.lt = [element text];
        NSLog(@"%@", szgd.lt);
    }
    return szgd;
}

@end
