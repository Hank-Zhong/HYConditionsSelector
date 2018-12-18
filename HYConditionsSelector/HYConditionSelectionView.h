//
//  HYConditionSelectionView.h
//  QianBoLe
//
//  Created by 钟汉耀 on 2018/4/19.
//  Copyright © 2018年 Hank. All rights reserved.
//  github:https://github.com/Hank-Zhong/HYConditionsSelector


#import <UIKit/UIKit.h>

@class HYConditionSelectionView;

@protocol HYConditionSelectionViewDelegate <NSObject>

@optional
- (void)conditionSelectionView:(HYConditionSelectionView *)conditionSelectionView didSelectIndex:(NSInteger)index text:(NSString *)text;//选中时回调
- (void)conditionSelectionView:(HYConditionSelectionView *)conditionSelectionView didDeselectIndex:(NSInteger)index text:(NSString *)text;//取消选中时回调

@end

IB_DESIGNABLE
@interface HYConditionSelectionView : UIView
typedef NS_ENUM (NSInteger, HYConditionSelectionSwitchState){
    HYConditionSelectionSwitchUnfold,
    HYConditionSelectionSwitchShut
};

/**
 选项数组，不可为空，数量必须大于0
 */
@property (nonnull, nonatomic, strong) NSArray <NSString *>*items;
/**
 选项字符串，英文逗号（,）隔开，不可为空，数量必须大于0。（推荐使用items，此属性仅为了可视化使用）
 */
@property (nonnull, nonatomic, strong) IBInspectable NSString *itemsString;

/**
 不可点击的选项集合，可为空
 */
@property (nullable, nonatomic, strong) NSSet <NSString *>*unclickableItems;

/**
 选项文字的颜色，默认blackColor
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *textColor;
/**
 选项被点击后的文字颜色，默认blackColor
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *selectTextColor;
/**
 指示图案的颜色，默认lightGrayColor
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *indicatorColor;
/**
 选项被点击后的指示图案的颜色，默认lightGrayColor
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *selectIndicatorColor;
/**
 分割线的颜色。默认lightGrayColor
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *separatorColor;
/**
 底边线颜色，默认“colorWithWhite:0.8 alpha:1”
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *baselineColor;
/**
 选项文字字体大小，默认12
 */
@property (null_resettable, nonatomic, strong) UIFont *textFont;
/**
 选项文字字体大小，默认12。（推荐使用textFont，此属性仅为了可视化使用）
 */
@property (nonatomic, assign) IBInspectable CGFloat textFontSize;

/**
 点击选项的时间间隔（防止暴力点击），单位秒，默认0.35秒
 */
@property (nonatomic, assign) IBInspectable CGFloat touchesTimeInterval;

@property (nonatomic, weak) id<HYConditionSelectionViewDelegate> delegate;

/**
 初始化，创建并返回一个ConditionSelectionView

 @param frame frame
 @param items 选项数组，不可为空，数量必须大于0
 @return 实例化对象
 */
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *>* _Nonnull)items;

/**
 设置某一个选项的文字

 @param index 选项下标
 @param text 文字
 */
-(void)alterTextWithIndex:(NSUInteger)index text:(NSString *_Nonnull)text;

/*!
 改变某一个选项的状态

 @param index 选项下标 
 @param state 状态
 */
-(void)alterSwitchWithIndex:(NSUInteger)index switchState:(HYConditionSelectionSwitchState)state;

/**
 关闭当前选中的选项
 */
-(void)closeSwitch;
@end

