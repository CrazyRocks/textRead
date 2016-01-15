//
//  CatalogText.m
//  WFReader
//
//  Created by csip on 15/7/27.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "CatalogText.h"
static CatalogText *cata;
static NSString *TextStr;
static NSString *bookName;
static int bookNumber;
@implementation CatalogText
+(id)siged{
    if (cata==nil) {
        cata = [[CatalogText alloc] init];
    }
    return cata;
}
-(void)loadText:(NSString *)path{
    
    NSArray *paths = [path componentsSeparatedByString:@"/"];
    NSString *b = [paths lastObject];
    bookName = [b componentsSeparatedByString:@"."][0];
    
    NSMutableString *str = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (str == nil || [str isEqualToString:@""]) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        str =[NSMutableString stringWithContentsOfFile:path encoding:enc error:NULL];
    }
    NSString *n = [NSString stringWithFormat:@"%lu",(unsigned long)str.length];
    NSString *str1;
    bookNumber = 0;
    int t;
    switch (n.length) {
        case 9:
            t = 10000;
            str1 = [str substringToIndex:str.length/10000];
            break;
        case 8:
            t = 1000;
            str1 = [str substringToIndex:str.length/1000];
            break;
        case 7:
            t = 100;
            str1 = [str substringToIndex:str.length/100];
            break;
        case 6:
            t = 10;
            str1 = [str substringToIndex:str.length/10];
            break;
        case 5:
            {
                t = 1;
                str1=str;
                
                NSString *bName = [NSString stringWithFormat:@"%@%d.txt",bookName,bookNumber];
                [self creatTextName:bName context:str1];
            }
            return;
            break;
        default:
            t = 1;
            str1=str;
            break;
    }
    NSString *bName = [NSString stringWithFormat:@"%@%d.txt",bookName,bookNumber];
    [self creatTextName:bName context:str1];
//    [text addObject:str1];
    int strlen=str1.length;
    bookNumber++;
    [str deleteCharactersInRange:[str rangeOfString:str1]];
    for (int i=1; i<t; i++) {
        NSString *cv = [str substringToIndex:strlen];
//        [text addObject:cv];
        NSString *bName = [NSString stringWithFormat:@"%@%d.txt",bookName,bookNumber];
        [self creatTextName:bName context:cv];
        
        [str deleteCharactersInRange:[str rangeOfString:cv]];
        cv = nil;
        bookNumber++;
    }
}
-(NSString *)bookPath{
    NSArray *cacesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [cacesPath objectAtIndex:0];
    NSString *bookPath = [documentsDirectory stringByAppendingPathComponent:@"book"];
    return bookPath;
}
/**
 *  添加文件
 *
 *  @param name 文件名称
 *  @param con  内容
 */
-(void)creatTextName:(NSString *)name context:(NSString *)con{
    NSString *bookPath = [self bookPath];
    NSString *filePath= [bookPath stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *fileContent = con;
    NSData *fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
}
-(NSString *)getBookName{
    return bookName;
}
-(int)NumBook{
    return bookNumber;
}

@end
