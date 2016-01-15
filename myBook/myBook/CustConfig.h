
//
//  CustConfig.h
//  Mall
//
//  Created by csip on 15/5/27.
//  Copyright (c) 2015年 com. All rights reserved.
//

#ifndef Mall_CustConfig_h
#define Mall_CustConfig_h

/**
 *  RGB颜色
 */
#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBA(r, g, b,a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

///屏幕宽度
#define ViewWidth [UIScreen mainScreen].applicationFrame.size.width
///屏幕高度
#define Viewheight [UIScreen mainScreen].applicationFrame.size.height

///计算位置X+宽
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
///计算位置Y+高
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)

///控件位置X
#define FRAME_TX(view)  (view.frame.origin.x)
///控件位置Y
#define FRAME_TY(view)  (view.frame.origin.y)

///控件宽度
#define FRAME_W(view)  (view.frame.size.width)
///控件高度
#define FRAME_H(view)  (view.frame.size.height)

///两个控件的距离
#define DistanceBTF(frame1,frame2) (frame2.origin.x - frame1.origin.x - frame1.size.width)
#endif
