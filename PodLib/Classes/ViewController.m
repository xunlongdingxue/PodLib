//
//  ViewController.m
//  GuidePage
//
//  Created by 李长青 on 15/8/18.
//  Copyright (c) 2015年 李长青. All rights reserved.
//

#import "ViewController.h"

#define k_Base_Tag  10000
#define k_Rotate_Rate 1
#define K_SCREEN_WIDHT [UIScreen mainScreen].bounds.size.width  //屏幕宽度
#define K_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height    //屏幕高
@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:140.0/255 green:1 blue:1 alpha:1];
    NSArray *imageArr = @[@"0.png",@"1.png",@"2.png",@"3.png"];
    NSArray *textImageArr = @[@"5.png",@"6.png",@"7.png",@"8.png"];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDHT, K_SCREEN_HEIGHT)];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = YES;
    mainScrollView.contentSize = CGSizeMake(K_SCREEN_WIDHT*imageArr.count, K_SCREEN_HEIGHT);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    //添加云彩图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 330, K_SCREEN_WIDHT, 170*K_SCREEN_WIDHT/1242.0)];
    imageView.image = [UIImage imageNamed:@"yun.png"];
    [self.view addSubview:imageView];
    
    
    for (int i=0; i<imageArr.count; i++) {
        UIView *rotateView = [[UIView alloc]initWithFrame:CGRectMake(K_SCREEN_WIDHT*i, 0, K_SCREEN_WIDHT, K_SCREEN_HEIGHT*2)];
        [rotateView setTag:k_Base_Tag+i];
        [mainScrollView addSubview:rotateView];
        if (i!=0) {
            rotateView.alpha = 0;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDHT, K_SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [rotateView addSubview:imageView];
        
        UIImageView *textImageView = [[UIImageView alloc]initWithFrame:CGRectMake(K_SCREEN_WIDHT*i, 50, K_SCREEN_WIDHT, K_SCREEN_WIDHT *260.0/1242.0)];
        [textImageView setTag:k_Base_Tag*2+i];
        textImageView.image = [UIImage imageNamed:textImageArr[i]];
        [mainScrollView addSubview:textImageView];
        
        //最后页面添加按钮
        if (i == imageArr.count-1) {
            UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT-80, K_SCREEN_WIDHT, 50)];
            [control addTarget:self action:@selector(ClickToRemove) forControlEvents:UIControlEventTouchUpInside];
            [rotateView addSubview:control];
        }
    }

    UIView *firstView = [mainScrollView viewWithTag:k_Base_Tag];
    [mainScrollView bringSubviewToFront:firstView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIView * view1 = [scrollView viewWithTag:k_Base_Tag];
    UIView * view2 = [scrollView viewWithTag:k_Base_Tag+1];
    UIView * view3 = [scrollView viewWithTag:k_Base_Tag+2];
    UIView * view4 = [scrollView viewWithTag:k_Base_Tag+3];
    
    UIImageView * imageView1 = (UIImageView *)[scrollView viewWithTag:k_Base_Tag*2];
    UIImageView * imageView2 = (UIImageView *)[scrollView viewWithTag:k_Base_Tag*2+1];
    UIImageView * imageView3 = (UIImageView *)[scrollView viewWithTag:k_Base_Tag*2+2];
    UIImageView * imageView4 = (UIImageView *)[scrollView viewWithTag:k_Base_Tag*2+3];
    
    CGFloat xOffset = scrollView.contentOffset.x;
    
    //根据偏移量旋转
    CGFloat rotateAngle = -1 * 1.0/K_SCREEN_WIDHT * xOffset * M_PI_2 * k_Rotate_Rate;
    view1.layer.transform = CATransform3DMakeRotation(rotateAngle, 0, 0, 1);
    view2.layer.transform = CATransform3DMakeRotation(M_PI_2*1+rotateAngle, 0, 0, 1);
    view3.layer.transform = CATransform3DMakeRotation(M_PI_2*2+rotateAngle, 0, 0, 1);
    view4.layer.transform = CATransform3DMakeRotation(M_PI_2*3+rotateAngle, 0, 0, 1);
    
    //根据偏移量位移（保证中心点始终都在屏幕下方中间）
    view1.center = CGPointMake(0.5 * K_SCREEN_WIDHT+xOffset, K_SCREEN_HEIGHT);
    view2.center = CGPointMake(0.5 * K_SCREEN_WIDHT+xOffset, K_SCREEN_HEIGHT);
    view3.center = CGPointMake(0.5 * K_SCREEN_WIDHT+xOffset, K_SCREEN_HEIGHT);
    view4.center = CGPointMake(0.5 * K_SCREEN_WIDHT+xOffset, K_SCREEN_HEIGHT);
    
    //当前哪个视图放在最上面
    if (xOffset<K_SCREEN_WIDHT*0.5) {
        [scrollView bringSubviewToFront:view1];
        
    }else if (xOffset>=K_SCREEN_WIDHT*0.5 && xOffset < K_SCREEN_WIDHT*1.5){
        [scrollView bringSubviewToFront:view2];
      
        
    }else if (xOffset >=K_SCREEN_WIDHT*1.5 && xOffset < K_SCREEN_WIDHT*2.5){
        [scrollView bringSubviewToFront:view3];
      
    }else if (xOffset >=K_SCREEN_WIDHT*2.5)
    {
        [scrollView bringSubviewToFront:view4];

    }
    
    //调节其透明度
    CGFloat xoffset_More = xOffset*1.5>K_SCREEN_WIDHT?K_SCREEN_WIDHT:xOffset*1.5;
    if (xOffset < K_SCREEN_WIDHT) {
        view1.alpha = (K_SCREEN_WIDHT - xoffset_More)/K_SCREEN_WIDHT;
        imageView1.alpha = (K_SCREEN_WIDHT - xOffset)/K_SCREEN_WIDHT;;
        
    }
    if (xOffset <= K_SCREEN_WIDHT) {
        view2.alpha = xoffset_More / K_SCREEN_WIDHT;
        imageView2.alpha = xOffset / K_SCREEN_WIDHT;
    }
    if (xOffset >K_SCREEN_WIDHT && xOffset <= K_SCREEN_WIDHT*2) {
        view2.alpha = (K_SCREEN_WIDHT*2 - xOffset)/K_SCREEN_WIDHT;
        view3.alpha = (xOffset - K_SCREEN_WIDHT)/ K_SCREEN_WIDHT;
        
        imageView2.alpha = (K_SCREEN_WIDHT*2 - xOffset)/K_SCREEN_WIDHT;
        imageView3.alpha = (xOffset - K_SCREEN_WIDHT)/ K_SCREEN_WIDHT;
    }
    if (xOffset >K_SCREEN_WIDHT*2 ) {
        view3.alpha = (K_SCREEN_WIDHT*3 - xOffset)/K_SCREEN_WIDHT;
        view4.alpha = (xOffset - K_SCREEN_WIDHT*2)/ K_SCREEN_WIDHT;
        
        imageView3.alpha = (K_SCREEN_WIDHT*3 - xOffset)/K_SCREEN_WIDHT;
        imageView4.alpha = (xOffset - K_SCREEN_WIDHT*2)/ K_SCREEN_WIDHT;
    }

    //调节背景色
    if (xOffset <K_SCREEN_WIDHT && xOffset>0) {
        self.view.backgroundColor = [UIColor colorWithRed:(140-40.0/K_SCREEN_WIDHT*xOffset)/255.0 green:(255-25.0/K_SCREEN_WIDHT*xOffset)/255.0 blue:(255-100.0/K_SCREEN_WIDHT*xOffset)/255.0 alpha:1];
        
    }else if (xOffset>=K_SCREEN_WIDHT &&xOffset<K_SCREEN_WIDHT*2){
        
        self.view.backgroundColor = [UIColor colorWithRed:(100+30.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT))/255.0 green:(230-40.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT))/255.0 blue:(155-5.0/320*(xOffset-K_SCREEN_WIDHT))/255.0 alpha:1];
        
    }else if (xOffset>=K_SCREEN_WIDHT*2 &&xOffset<K_SCREEN_WIDHT*3){
        
        self.view.backgroundColor = [UIColor colorWithRed:(130-50.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*2))/255.0 green:(190-40.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*2))/255.0 blue:(150+50.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*2))/255.0 alpha:1];
        
    }else if (xOffset>=K_SCREEN_WIDHT*3 &&xOffset<K_SCREEN_WIDHT*4){
        
        self.view.backgroundColor = [UIColor colorWithRed:(80-10.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*3))/255.0 green:(150-25.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*3))/255.0 blue:(200-90.0/K_SCREEN_WIDHT*(xOffset-K_SCREEN_WIDHT*3))/255.0 alpha:1];
    }


}

-(void)ClickToRemove
{
    NSLog(@"点击事件");
    [self.view removeFromSuperview];

}
-(BOOL)shouldAutorotate
{
    return YES;
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
