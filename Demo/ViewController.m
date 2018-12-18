//
//  ViewController.m
//  Demo
//
//  Created by 钟汉耀 on 2018/8/16.
//  Copyright © 2018年 Hank. All rights reserved.
//

#import "ViewController.h"
#import "HYConditionSelectionView.h"

@interface ViewController ()<HYConditionSelectionViewDelegate>
@property (strong, nonatomic) HYConditionSelectionView *conditionSelectionView;
@property (weak, nonatomic) IBOutlet HYConditionSelectionView *conditionSelectionView1;
@property (weak, nonatomic) IBOutlet HYConditionSelectionView *conditionSelectionView2;
@property (weak, nonatomic) IBOutlet HYConditionSelectionView *conditionSelectionView3;
@property (weak, nonatomic) IBOutlet HYConditionSelectionView *conditionSelectionView4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"HYConditionSelectionView";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化
    self.conditionSelectionView = [[HYConditionSelectionView alloc]
                                    initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 30)
                                    items:@[@"全部",@"附近",@"智能排序",@"筛选"]];
    //设置子控件颜色
    self.conditionSelectionView.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.conditionSelectionView.selectTextColor = [UIColor colorWithRed:0.25f green:0.87f blue:0.85f alpha:1];
    self.conditionSelectionView.selectIndicatorColor = [UIColor colorWithRed:0.25f green:0.87f blue:0.85f alpha:1];
    self.conditionSelectionView.unclickableItems = [NSSet setWithObjects:@"0", @"2", nil];
    
    [self.view addSubview:self.conditionSelectionView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.conditionSelectionView.delegate  = self;
    self.conditionSelectionView1.delegate = self;
    self.conditionSelectionView2.delegate = self;
    self.conditionSelectionView3.delegate = self;
    self.conditionSelectionView4.delegate = self;
}

#pragma mark - HYConditionSelectionViewDelegate
-(void)conditionSelectionView:(HYConditionSelectionView *)conditionSelectionView didSelectIndex:(NSInteger)index text:(NSString *)text{
    NSLog(@"%@\n选择了第%ld个，文字是：%@", conditionSelectionView, (long)index, text);
}

- (void)conditionSelectionView:(HYConditionSelectionView *)conditionSelectionView didDeselectIndex:(NSInteger)index text:(NSString *)text{
    NSLog(@"%@\n取消选择第%ld个，文字是：%@", conditionSelectionView, (long)index, text);
}


@end
