//
//  FMGImageRol.m
//  FMG
//
//  Created by MG F on 16/6/12.
//  Copyright © 2016年 FMG. All rights reserved.
//


#import "FMGImageRoll.h"
#import "UIImageView+WebCache.h"

#define totalImageViewCount 3

@interface FMGImageRoll ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *myRollScrollView;
@property (assign, nonatomic) NSInteger imagesCount;
@property (strong, nonatomic) UIPageControl *myPageControl;
@property (strong, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) BOOL notFirstLoadImage;
@property (weak, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) RollImagesResourceType resourceType;
@end


@implementation FMGImageRoll

- (instancetype)initWithFrame:(CGRect)frame withImagesArray:(NSArray *)images resourceType:(RollImagesResourceType)resourceType
{
    if (self = [super initWithFrame:frame]) {
        self.imagesCount = images.count;
        self.imageArray = images;
        self.resourceType = resourceType;
        [self setupImageRoll];
        [self addImageViewWithImages:images];
        [self addTapGesture];
        [self displayImageForRoll];
        [self startTimer];
        [self searchPageControl];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myRollScrollView.frame = self.bounds;
    
    if (self.isScrollDirectionVertical) {//竖向滚动
        self.myRollScrollView.contentSize = CGSizeMake(0, totalImageViewCount * self.bounds.size.height);
    } else {
        self.myRollScrollView.contentSize = CGSizeMake(totalImageViewCount * self.bounds.size.width, 0);
    }
    
    for (int i = 0; i<totalImageViewCount; i++) {
        UIImageView *imageView = self.myRollScrollView.subviews[i];
        if (self.isScrollDirectionVertical) {//竖向滚动时imageview的frame
            imageView.frame = CGRectMake(0, i * self.myRollScrollView.frame.size.height, self.myRollScrollView.frame.size.width, self.myRollScrollView.frame.size.height);
        } else {//横向滚动时imageview的frame
            imageView.frame = CGRectMake(i * self.myRollScrollView.frame.size.width, 0, self.myRollScrollView.frame.size.width, self.myRollScrollView.frame.size.height);
        }
    }
    
    CGFloat width;
    CGFloat height;
    
    self.pageControlWidth >0 ? (width = self.pageControlWidth) : (width = 88);
    self.pageControlHeight > 0 ? (height = self.pageControlHeight) : (height = 22);
    self.myPageControl.frame = CGRectMake(0, 0, width, height); 
    self.myPageControl.center = CGPointMake(self.center.x, self.frame.size.height - height);

}

- (void)setupImageRoll
{
    if (!_myRollScrollView) {
        _myRollScrollView = ({
            UIScrollView *scroll = [UIScrollView new];
            [self addSubview:scroll];
            scroll.showsVerticalScrollIndicator = NO;
            scroll.showsHorizontalScrollIndicator = NO;
            scroll.pagingEnabled = YES;
            scroll.delegate = self;
            
            scroll;
        });
    }
    
    if (!_myPageControl) {
        _myPageControl = ({
            UIPageControl *control = [UIPageControl new];
            [self addSubview:control];
            control.numberOfPages = self.imagesCount;
            control.currentPage = 0;
            control.pageIndicatorTintColor = [UIColor lightGrayColor];
            control.currentPageIndicatorTintColor = [UIColor redColor];
            control;
        });
    }
}

#pragma mark 访问pageControl私有属性
- (void)searchPageControl
{
    //KVC 对私有变量的更改
    
    UIImage *normalImage = _normalPageImage ? _normalPageImage : [UIImage imageNamed:@"tweet_btn_share"];
    UIImage *currentPageImage = _currentPageImage ? _currentPageImage : [UIImage imageNamed:@"tweet_btn_liked"];
    
    [self.myPageControl setValue:normalImage forKeyPath:@"pageImage"];
    [self.myPageControl setValue:currentPageImage forKeyPath:@"currentPageImage"];
    
}

- (void)addImageViewWithImages:(NSArray *)images
{
    for (int i = 0; i<totalImageViewCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.myRollScrollView addSubview:imageView];
    }
    
}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:_myTimerInterval ? _myTimerInterval : 1 target:self selector:@selector(showNextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.myTimer = timer;
    
}

- (void)stopTimer
{
    
    // 销毁定时器
    [self.myTimer invalidate];
    
}

- (void)showNextImage
{
    
    if (self.isScrollDirectionVertical) {
        [self.myRollScrollView setContentOffset:CGPointMake(0, 2 * self.myRollScrollView.frame.size.height) animated:YES];
    } else {
        [self.myRollScrollView setContentOffset:CGPointMake(2 * self.myRollScrollView.frame.size.width, 0) animated:YES];
    }
}

- (void)displayImageForRoll
{
    for (int i = 0; i< totalImageViewCount; i++) {
        UIImageView *imageV = self.myRollScrollView.subviews[i];
        NSInteger currentIndex = self.myPageControl.currentPage;
        
        if (i == 0 && self.notFirstLoadImage) {
            currentIndex--;
        }else if (i == 2) {//滚到最后一张图片，index加1
            currentIndex++;
        }
        
        if (currentIndex < 0) {
            currentIndex = self.imagesCount - 1;
        } else if (currentIndex >= self.imagesCount) {
            currentIndex = 0;
        }
        imageV.tag = currentIndex;
        
        switch (self.resourceType) {
            case RollImagesFromLocal:
                imageV.image = self.imageArray[currentIndex];
                break;
            case RollImagesFromNetwork:
                [imageV sd_setImageWithURL:self.imageArray[currentIndex] placeholderImage:self.rollPlaceholdImage];
                break;

            default:
                break;
        }
        
        
    }
    
    
    self.notFirstLoadImage = YES;

    if (self.isScrollDirectionVertical) {
        self.myRollScrollView.contentOffset = CGPointMake(0, self.myRollScrollView.frame.size.height);
    } else {
        self.myRollScrollView.contentOffset = CGPointMake(self.myRollScrollView.frame.size.width, 0);
    }

}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    
    for (int i = 0; i<self.myRollScrollView.subviews.count; i++) {
        UIImageView *imageView = self.myRollScrollView.subviews[i];
        CGFloat distance = 0;
        if (self.isScrollDirectionVertical) {
            distance = ABS(imageView.frame.origin.y - self.myRollScrollView.contentOffset.y);
        } else {
            distance = ABS(imageView.frame.origin.x - self.myRollScrollView.contentOffset.x);
        }
        
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    
    self.myPageControl.currentPage = page;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self displayImageForRoll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self displayImageForRoll];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

#pragma mark - 添加点击手势
-(void)addTapGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageBack)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

-(void)clickImageBack
{
    if (_delegate && [self.delegate respondsToSelector:@selector(imageRoll:clickRollImageWithIndex:)])
    {
        [_delegate imageRoll:self clickRollImageWithIndex:self.myPageControl.currentPage];
    }
}

- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}


-(void)dealloc
{
    [self.myTimer invalidate];
}

@end
