# HYConditionsSelector
[![CocoaPods](https://img.shields.io/cocoapods/v/HYConditionsSelector.svg?style=flat)](https://github.com/banchichen/TZImagePickerController)

一个简易的条件选择器控件

<img src="https://github.com/Hank-Zhong/HYConditionsSelector/blob/master/HYConditionsSelector_%20screenshot1.png" width="40%" height="40%"><img src="https://github.com/Hank-Zhong/HYConditionsSelector/blob/master/HYConditionsSelector_%20screenshot2.png" width="40%" height="40%">

## 一. Installation 安装

#### CocoaPods
> pod 'HYConditionsSelector'

#### 手动安装
> 将HYConditionsSelector文件夹拽入项目中，导入头文件：#import "HYConditionSelectionView.h"

## 二. Example 例子
    //初始化
    self.conditionSelectionView = [[HYConditionSelectionView alloc]
                                    initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 30)
                                    items:@[@"全部",@"附近",@"智能排序",@"筛选"]];
    //设置子控件颜色
    self.conditionSelectionView.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.conditionSelectionView.selectTextColor = [UIColor colorWithRed:0.25f green:0.87f blue:0.85f alpha:1];
    self.conditionSelectionView.selectIndicatorColor = [UIColor colorWithRed:0.25f green:0.87f blue:0.85f alpha:1];

    [self.view addSubview:self.conditionSelectionView];
    
## 三. Requirements 要求
iOS8及以上系统可使用. ARC环境.

## 四. More 更多
如果你发现了bug，请提一个issue。 
欢迎给我提pull requests。  
更多信息详见代码，也可查看[我的博客](https://www.hlzhy.com "Hank")或者[我的简书](https://www.jianshu.com/u/2955cdafd186 "Hank_Zhong - 简书")

### 关于issue: 
请尽可能详细地描述**系统版本**、**手机型号**、**库的版本**、**崩溃日志**和**复现步骤**，**请先更新到最新版再测试一下**，如果新版还存在再提~如果已有开启的类似issue，请直接在该issue下评论说出你的问题


