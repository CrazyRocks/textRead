//
//  CatalogText.h
//  WFReader
//
//  Created by csip on 15/7/27.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogText : NSObject
/**
 *  单例
 */
+(id)siged;
/**
 *  对txt分段保存
 *
 *  @param path txt路径
 */
-(void)loadText:(NSString *)path;
/**
 *  获取 图书名称
 *
 *  @return 图书名称
 */
-(NSString *)getBookName;
/**
 *  获取分成了多少本书
 */
-(int)NumBook;
@end
