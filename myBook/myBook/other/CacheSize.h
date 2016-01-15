//
//  CacheSize.h
//  PersonalCenter
//
//  Created by csip on 15/6/2.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheSize : NSObject
@property(nonatomic,copy)void(^onResult)(NSString*);
+ (instancetype)defaultCalculateFileSize;
// 计算单个文件大小
- (float)fileSizeAtPath:(NSString*)path;
// 计算目录大小
- (float)folderSizeAtPath:(NSString*)path;
// 清除文件
- (void)clearCache:(NSString *)path clearBlock:(void(^)(NSString*))a;
@end
