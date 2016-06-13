//
//  FMGImageRol.h
//  FMG
//
//  Created by MG F on 16/6/12.
//  Copyright © 2016年 FMG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RollImagesResourceType) {
    
    RollImagesFromLocal,
    RollImagesFromNetwork

};

@class FMGImageRoll;
@protocol FMGImageRollDelegate <NSObject>

@optional

- (void)imageRoll:(FMGImageRoll *)imageRoll clickRollImageWithIndex:(NSInteger)index;

@end


@interface FMGImageRoll : UIView

/** 是否垂直显示 */
@property (assign, nonatomic) BOOL isScrollDirectionVertical;

/** 轮播器占位图 */
@property (strong, nonatomic) UIImage *rollPlaceholdImage;

/** 分页控制器宽度 */
@property (assign, nonatomic) CGFloat pageControlWidth;
/** 分页控制器高度 */
@property (assign, nonatomic) CGFloat pageControlHeight;
/** 默认pageControl图片 */
@property (strong, nonatomic) UIImage *normalPageImage;
/** 当前pageControl图片 */
@property (strong, nonatomic) UIImage *currentPageImage;


/** 定时器间隔时间 */
@property (assign, nonatomic) NSInteger myTimerInterval;

@property (weak, nonatomic) id<FMGImageRollDelegate>delegate;

/**
 *  初始化图片轮播器
 *
 *  @param frame        尺寸
 *  @param images       需要展示的图片
 *  @param resourceType 图片来源于本地还是网络
 *
 *  @return HCCommonImageRoll
 */
- (instancetype)initWithFrame:(CGRect)frame withImagesArray:(NSArray *)images resourceType:(RollImagesResourceType)resourceType;

@end
