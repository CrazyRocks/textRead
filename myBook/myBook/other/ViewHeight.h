//
//  viewHeight.h
//  kuWeiBo
//
//  Created by csip on 15/3/9.
//  Copyright (c) 2015年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ViewHeight : NSObject
/**
 *  计算字符串宽度、高度自适应
 *
 *  @param title    要计算的文字
 *  @param font     字体的大小
 *  @param viewSize 预设的宽高
 */
+(CGSize)setViewSize:(NSString *)title font:(UIFont *)font RectSize:(CGSize)viewSize;
@end
