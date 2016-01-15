//
//  viewHeight.m
//  kuWeiBo
//
//  Created by csip on 15/3/9.
//  Copyright (c) 2015年 zh. All rights reserved.
//

#import "ViewHeight.h"
@implementation ViewHeight
+(CGSize)setViewSize:(NSString *)title font:(UIFont *)font RectSize:(CGSize)viewSize{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *d=@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [[NSString stringWithFormat:@"%@",title] boundingRectWithSize:viewSize options:NSStringDrawingUsesLineFragmentOrigin attributes:d context:nil].size;
    return size;
}
@end
