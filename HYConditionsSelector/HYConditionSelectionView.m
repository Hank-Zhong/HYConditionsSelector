//
//  HYConditionSelectionView.m
//  QianBoLe
//
//  Created by 钟汉耀 on 2018/4/19.
//  Copyright © 2018年 天下会. All rights reserved.
//
/**
 ╔═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
 ║                   textLayerWidth                                    separator                                       ║
 ║                     ____/\___                                           █                                           ║
 ║                    /         \               indicatorWidth             █     intervalWidth                         ║
 ║                   ┏━━━━━━━━━━━┓                ___/\____                █    ↗  ┏━━━━━━━━━━━┓                       ║
 ║                   ┃           ┃               /         \               █       ┃           ┃                       ║
 ║                   ┃ textLayer ┃               ███████████               █       ┃ textLayer ┃      ███████████      ║
 ║                   ┃           ┃\______  _____/     ↓     \______  _____/█       ┃           ┃                   ↙   ║
 ║\_______  ________/┗━━━━━━━━━━━┛       ╲╱       indicator        ╲╱      █       ┗━━━━━━━━━━━┛  separatorInterval    ║
 ║        ╲╱                       intervalWidth             intervalWidth █                                           ║
 ║ separatorInterval                                                         } separatorInterval                       ║
 ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
 |→                              itemWidth                                ←|
 */

#import "HYConditionSelectionView.h"

@interface HYConditionSelectionView ()
/**
 每一项 的宽度
 */
@property (nonatomic, assign) NSInteger itemWidth;
/**
 textLayer 的宽度
 */
@property (nonatomic, assign) NSInteger textLayerWidth;
/**
 textLayer数组
 */
@property (nonatomic, strong) NSMutableArray <CATextLayer *>* textLayers;
/**
 指示图标数组
 */
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>* indicators;
/**
 separator数组
 */
@property (nonatomic, strong) NSMutableArray <CALayer *>* separators;
/**
 底部的边线
 */
@property (nonatomic, strong) CALayer *baseline;
/**
 上次选中的 index + 1, 默认0：未选择任何选项
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HYConditionSelectionView

static const CGFloat indicatorWidth    = 8;   //指示图标的宽度
static const CGFloat separatorWidth    = 0.5; //分隔线的宽度
static const CGFloat separatorInterval = 10;  //分隔线和边界的间隔
static const CGFloat contentInterval   = 8;   //内容和边界的间隔（左右两边）
static const CGFloat intervalWidth     = 5;   //文本与指示图标的间隔

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    _textColor = [UIColor blackColor];
    _selectTextColor = [UIColor blackColor];
    _indicatorColor = [UIColor lightGrayColor];
    _selectIndicatorColor = [UIColor lightGrayColor];
    _separatorColor = [UIColor lightGrayColor];
    _textFont = [UIFont systemFontOfSize:12];
    _textFontSize = 12;
    _touchesTimeInterval = 0.35f;
    _textLayers = [NSMutableArray array];
    _indicators = [NSMutableArray array];
    _separators = [NSMutableArray array];
    
    self.baseline = [CALayer layer];
    self.baseline.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
    self.baseline.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    [self.layer addSublayer:self.baseline];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *_Nonnull)items{
    if (self = [self initWithFrame:frame]) {
        [self initView];
        self.items = items;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

#pragma mark - Properties

-(void)setItems:(NSArray<NSString *> *)items{
    if (_items.count > 0) {
        //如果之前有添加过则先清除所有子视图
        [self removeAllSublayer];
    }
    _items = items;
    //分隔线的数量
//    NSInteger separatorNumber = items.count - 1;
    //每个选项的宽度
    self.itemWidth = (self.bounds.size.width - contentInterval * 2) / (items.count * 1.0);
    //textLayer 的宽度
    self.textLayerWidth = self.itemWidth - indicatorWidth - separatorWidth - intervalWidth * 2;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        NSString *text = self.items[i];
        [self createLayerWithIndex:i text:text];
    }
}

-(void)setItemsString:(NSString *)itemsString{
    if (!itemsString) {
        return;
    }
    if ([_itemsString isEqualToString:itemsString]) {
        return;
    }
    _itemsString = itemsString;
    self.items = [itemsString componentsSeparatedByString:@","];
}

-(void)setTextColor:(UIColor *)textColor{
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    if (_textColor == textColor || [_textColor isEqual:textColor]) {
        return;
    }
    _textColor = textColor;
    for (NSInteger i = 0; i < _textLayers.count; i++) {
        if (_selectIndex - 1 != i) {
            CATextLayer *textLayer = _textLayers[i];
            textLayer.foregroundColor = textColor.CGColor;
        }
    }
}

-(void)setSelectTextColor:(UIColor *)selectTextColor{
    if (!selectTextColor) {
        selectTextColor = [UIColor blackColor];
    }
    if (_selectTextColor == selectTextColor || [_selectTextColor isEqual:selectTextColor]) {
        return;
    }
    _selectTextColor = selectTextColor;
    if (_selectIndex == 0) {
        return;
    }
    CATextLayer *textLayer = self.textLayers[_selectIndex];
    textLayer.foregroundColor = selectTextColor.CGColor;
} 

-(void)setIndicatorColor:(UIColor *)indicatorColor{
    if (!indicatorColor) {
        indicatorColor = [UIColor lightGrayColor];
    }
    if (_indicatorColor == indicatorColor || [_indicatorColor isEqual:indicatorColor]) {
        return;
    }
    _indicatorColor = indicatorColor;
    for (NSInteger i = 0; i < _indicators.count; i++) {
        if (_selectIndex - 1 != i) {
            CAShapeLayer *indicator = _indicators[i];
            indicator.strokeColor = indicatorColor.CGColor;
        }
    }
}

-(void)setSelectIndicatorColor:(UIColor *)selectIndicatorColor{
    if (!selectIndicatorColor) {
        selectIndicatorColor = [UIColor lightGrayColor];
    }
    if (_selectIndicatorColor == selectIndicatorColor || [_selectIndicatorColor isEqual:selectIndicatorColor]) {
        return;
    }
    _selectIndicatorColor = selectIndicatorColor;
    if (_selectIndex == 0) {
        return;
    }
    CAShapeLayer *indicator = self.indicators[_selectIndex];
    indicator.strokeColor = selectIndicatorColor.CGColor;
}

-(void)setSeparatorColor:(UIColor *)separatorColor{
    if (!separatorColor) {
        separatorColor = [UIColor lightGrayColor];
    }
    if (_separatorColor == separatorColor || [_separatorColor isEqual:separatorColor]) {
        return;
    }
    _separatorColor = separatorColor;
    if (self.separators.count != 0) {
        for (CALayer *separator in self.separators) {
            separator.backgroundColor = separatorColor.CGColor;
        }
    }
}

-(void)setTextFont:(UIFont *)textFont{
    if (!textFont) {
        textFont = [UIFont systemFontOfSize:12];
    }
    if (_textFont == textFont || [_textFont isEqual:textFont]) {
        return;
    }
    _textFont = textFont;
    for (NSInteger i = 0; i < _textLayers.count; i++) {
        [self updateTextWithIndex:i text:nil];
    }
}

-(void)setTextFontSize:(CGFloat)textFontSize{
    if (_textFontSize == textFontSize) {
        return;
    }
    _textFontSize = textFontSize;
    self.textFont = [UIFont systemFontOfSize:textFontSize];
}

#pragma mark - Private

/**
 移除所有Sublayer（除了baseline）
 */
-(void)removeAllSublayer{
    [self.textLayers enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.indicators enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.separators enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.textLayers removeAllObjects];
    [self.indicators removeAllObjects];
    [self.separators removeAllObjects];
}

/**
 创建 textLayer、分隔线separator 和 指示图标indicator
 */
-(void)createLayerWithIndex:(NSUInteger)index text:(NSString *)text{
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    //set text attributes
    textLayer.foregroundColor = _textColor.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
//    textLayer.wrapped = self.isWrapped;
    
    [self.layer addSublayer:textLayer];
    [self.textLayers addObject:textLayer];
    //set layer
    [self updateTextWithIndex:index text:text];
    
    //create a shapeLayer
    CAShapeLayer *indicator = [CAShapeLayer layer];
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(textLayer.frame) + intervalWidth, self.bounds.size.height * 0.5);
    CGPoint endPoint = CGPointMake(startPoint.x + indicatorWidth, startPoint.y);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:CGPointMake(startPoint.x + (indicatorWidth * 0.5), startPoint.y)];
    [bezierPath addLineToPoint:endPoint];
    
    indicator.lineWidth = 2.0f;
    indicator.fillColor = [UIColor clearColor].CGColor;
    indicator.strokeColor = self.indicatorColor.CGColor;
    indicator.lineCap = kCALineCapRound;
    indicator.lineJoin = kCALineJoinRound;
    
    indicator.path = bezierPath.CGPath;
    [self.layer addSublayer:indicator];
    [self.indicators addObject:indicator];
    
    //create a separator
    if (index != 0) {
        CALayer *separator = [CALayer layer];
        separator.frame = CGRectMake(index * self.itemWidth + contentInterval - separatorWidth, separatorInterval, separatorWidth, self.bounds.size.height - separatorInterval * 2);
        separator.backgroundColor = self.separatorColor.CGColor;
        [self.layer addSublayer:separator];
        [self.separators addObject:separator];
    }
}

//更新textLayer 文字 和 字体
-(void)updateTextWithIndex:(NSUInteger)index text:(NSString *_Nullable)text{
    if (index >= self.textLayers.count) {
        return;
    }
    CATextLayer *textLayer = self.textLayers[index];
    if (text) {
        textLayer.string = text;
    }
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)_textFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = _textFont.pointSize;
    CGFontRelease(fontRef);
    
    //计算剩余可显示文字的宽度
    CGFloat otherWidth = indicatorWidth + separatorWidth + intervalWidth * 2;//一项中除了文字外的宽度
    CGFloat surplusWidth = self.itemWidth - otherWidth;//一项中文字可用的宽度
    //计算文字长度
    CGFloat textLayerWidth = [textLayer.string sizeWithAttributes:@{NSFontAttributeName:self.textFont}].width;
    if (textLayerWidth > surplusWidth) {
        textLayerWidth = surplusWidth;
    }
    
    textLayer.frame = CGRectMake((index * self.itemWidth) + (self.itemWidth - textLayerWidth - otherWidth) * 0.5 + contentInterval, (self.height - self.textFont.lineHeight) * 0.5, textLayerWidth, self.textFont.lineHeight);
    
    if (index < self.indicators.count) {
        HYConditionSelectionSwitchState state = (self.selectIndex - 1 == index) ? HYConditionSelectionSwitchUnfold : HYConditionSelectionSwitchShut;
        [self alterIndicatorWithIndex:index switchState:state];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.userInteractionEnabled = NO;
    UITouch *touch= [[touches allObjects] firstObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger index = (touchPoint.x - contentInterval) / self.itemWidth;
    if (index >= self.items.count) {
        index = self.items.count - 1;
    }
    
    if (self.selectIndex - 1 == index) {
        //点击了上次选中的，取消选中
        self.selectIndex = 0;
        [self alterSwitchWithIndex:index switchState:(HYConditionSelectionSwitchShut)];
        
    }else if (self.selectIndex != 0){
        //存在已经选中的，取消上次选中的，把现在点击的置为选中
        [self alterSwitchWithIndex:self.selectIndex - 1 switchState:(HYConditionSelectionSwitchShut)];
        self.selectIndex = index + 1;
        [self alterSwitchWithIndex:index switchState:(HYConditionSelectionSwitchUnfold)];
        
    }else if (self.selectIndex == 0){
        //不存在选中的，直接置为选中
        self.selectIndex = index + 1;
        [self alterSwitchWithIndex:index switchState:(HYConditionSelectionSwitchUnfold)];
    }
//    NSLog(@"点击了第 %ld 项", index);
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, _touchesTimeInterval * NSEC_PER_SEC);//GCD单次执行,延迟修改userInteractionEnabled，防止暴力点击
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        weakSelf.userInteractionEnabled = YES;
    });
}

/**
 改变某一个textLayer 状态
 */
-(void)alterTextLayerWithIndex:(NSUInteger)index switchState:(HYConditionSelectionSwitchState)state{
    if (index >= self.textLayers.count) {
        return;
    }
    CATextLayer *textLayer = self.textLayers[index];
    
    if (state == HYConditionSelectionSwitchUnfold) {
        textLayer.foregroundColor = self.selectTextColor.CGColor;
    }else{
        textLayer.foregroundColor = self.textColor.CGColor;
    }
}
/**
 改变某一个indicator 状态
 */
-(void)alterIndicatorWithIndex:(NSUInteger)index switchState:(HYConditionSelectionSwitchState)state{
    if (index >= self.indicators.count) {
        return;
    }
    CAShapeLayer *indicator = self.indicators[index];
    CATextLayer *textLayer = self.textLayers[index];
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(textLayer.frame) + intervalWidth, self.bounds.size.height * 0.5);
    CGPoint endPoint = CGPointMake(startPoint.x + indicatorWidth, startPoint.y);
    CGFloat indicatorMiddleY = startPoint.y;
    CGFloat duration = 0.2f;
    CGFloat lineWidth = 2.0f;
    
    if (state == HYConditionSelectionSwitchUnfold) {
        indicatorMiddleY = startPoint.y + 3.0f;
        duration = 0.07f;
        lineWidth = 1.0f;
        indicator.strokeColor = self.selectIndicatorColor.CGColor;
    }else{
         indicator.strokeColor = self.indicatorColor.CGColor;
    }
    
    UIBezierPath *toBezierPath = [UIBezierPath bezierPath];
    [toBezierPath moveToPoint:startPoint];
    [toBezierPath addLineToPoint:CGPointMake(startPoint.x + (indicatorWidth * 0.5), (state == HYConditionSelectionSwitchUnfold) ? startPoint.y + 3.0f : startPoint.y )];
    [toBezierPath addLineToPoint:endPoint];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = duration;
    animation.fromValue = (__bridge id)indicator.path;
    animation.toValue = (__bridge id)toBezierPath.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [indicator addAnimation:animation forKey:@"animation"];
    indicator.path = toBezierPath.CGPath;
    indicator.lineWidth = lineWidth;
}

#pragma mark - Public

/**
 改变某一个选项的状态
 */
-(void)alterSwitchWithIndex:(NSUInteger)index switchState:(HYConditionSelectionSwitchState)state{
    
    [self alterTextLayerWithIndex:index switchState:state];
    [self alterIndicatorWithIndex:index switchState:state];
    
    if (state == HYConditionSelectionSwitchUnfold) {
        if ([self.delegate respondsToSelector:@selector(conditionSelectionView:didSelectIndex:text:)]) {
            CATextLayer *textLayer = self.textLayers[index];
            [self.delegate conditionSelectionView:self didSelectIndex:index text:textLayer.string];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(conditionSelectionView:didDeselectIndex:text:)]) {
            CATextLayer *textLayer = self.textLayers[index];
            [self.delegate conditionSelectionView:self didDeselectIndex:index text:textLayer.string];
        }
    }
}

/**
 修改某个选项的文字内容
 */
-(void)alterTextWithIndex:(NSUInteger)index text:(NSString *_Nonnull)text{
    [self updateTextWithIndex:index text:text];
}

/**
 关闭当前选中的选项
 */
-(void)closeSwitch{
    NSInteger i = self.selectIndex - 1;
    self.selectIndex = 0;
    if (i < 0) {
        return;
    }
    [self alterSwitchWithIndex:i switchState:(HYConditionSelectionSwitchShut)];
}

@end
