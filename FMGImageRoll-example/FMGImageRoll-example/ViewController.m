//
//  ViewController.m
//  FMGImageRoll-example
//
//  Created by MG F on 16/6/13.
//  Copyright © 2016年 FMG. All rights reserved.
//

#import "ViewController.h"
#import "FMGImageRoll.h"

#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<FMGImageRollDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageRollView];
}

- (void)setupImageRollView
{
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"intro_icon_0"],[UIImage imageNamed:@"intro_icon_1"],[UIImage imageNamed:@"intro_icon_3"],[UIImage imageNamed:@"intro_icon_2"], nil];
    
    
    FMGImageRoll *imageRoll = [[FMGImageRoll alloc] initWithFrame:CGRectMake(0, 64, Screen_width, 100) withImagesArray:images resourceType:RollImagesFromLocal];
    imageRoll.delegate = self;
    [self.view addSubview:imageRoll];
}

- (void)imageRoll:(FMGImageRoll *)imageRoll clickRollImageWithIndex:(NSInteger)index
{
    NSLog(@"点击了图片：%ld",index);
}


@end
