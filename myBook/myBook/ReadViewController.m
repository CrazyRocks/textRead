//
//  ReadViewController.m
//  myBook
//
//  Created by csip on 15/7/24.
//  Copyright (c) 2015年 csip. All rights reserved.
//

#import "ReadViewController.h"
#import "ViewHeight.h"
#import "AppHelper.h"
@interface ReadViewController ()<UITextViewDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate >
{
    BOOL right;
    UIBarButtonItem *rightBarButton;
    int cont;
    CGSize winSize;
    UITextView *textView;
    int currentPage;
    int allPage;
}
@end

@implementation ReadViewController

@synthesize str;

- (void)viewDidLoad{
    [super viewDidLoad];
    [AppHelper removeHUD];
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"翻页" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    //UINavigationItem *item = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, self.view.frame.size.height)];
    [self.view addSubview:textView];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:19];
    textView.backgroundColor = [UIColor colorWithRed:0.914 green:0.902 blue:0.871 alpha:1.000];
    textView.textColor = [UIColor blackColor];
    textView.editable = NO;
    winSize = textView.contentSize;

    NSLog(@"%f",textView.contentSize.height);
    
    CGSize size = [ViewHeight setViewSize:textView.text font:[UIFont systemFontOfSize:19] RectSize:CGSizeMake(ViewWidth, 0)];
    winSize = size;
    currentPage = 1;
    textView.contentSize = self.view.frame.size;
    self.title = [NSString stringWithFormat:@"%d/%d",currentPage,allPage];
    
    //手势
    //单击手势
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.delegate=self;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];

    UISwipeGestureRecognizer* leftswipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    leftswipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    leftswipeGesture.delegate=self;
    [self.view addGestureRecognizer:leftswipeGesture];
    //右轻扫手势
    UISwipeGestureRecognizer* RightswipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    RightswipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    RightswipeGesture.delegate=self;
    [self.view addGestureRecognizer:RightswipeGesture];
    textView.text =str;
    textView.scrollEnabled = YES;
}

- (void)rightButton
{
    if (right == NO) {
        rightBarButton.title = @"下滑";
        right = YES;
        textView.contentSize = winSize;
    }else{
        rightBarButton.title = @"翻页";
        right = NO;
        textView.contentSize = self.view.frame.size;
    }
}

-(void)tapGestureAction:(UITapGestureRecognizer*)tapGesture{
    NSLog(@"tapGesture");
    if (cont++%2==0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"+++++ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    cH = scrollView.contentOffset.y;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) swipeGestureAction:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self nextPage];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        
        [self prevPage];
    }
}
- (void) prevPage {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = textView.contentOffset;
    CGSize viewSize = textView.frame.size;
    
    offset.y -= viewSize.height - 19;
    if (offset.y < 0) {
        offset.y = 0;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:textView cache:YES];
    }
    [UIView commitAnimations];
    
    textView.contentOffset = offset;
}
- (void) nextPage {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = textView.contentOffset;
    CGSize viewSize = textView.frame.size;
    CGSize contentSize = textView.contentSize;
    offset.y += viewSize.height - 19;
    if (offset.y > (contentSize.height - viewSize.height)) {
        offset.y = contentSize.height - viewSize.height;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:textView cache:YES];
    }
    
    [UIView commitAnimations];
    
    textView.contentOffset = offset;
}
@end