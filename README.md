# FMGImageRoll
自定义无限图片轮播器

 ![image](https://github.com/MGXu/FMGImageRoll/raw/master/效果图.png)

####主要功能：
  1、支持本地图片展示
  
  2、支持网络图片展示
  
  3、支持将pageControl圆点改成你想要的图片
  
  4、轮播图片支持拖拽
  
  5、有代理返回你点击的是哪张图片，你可以用来做跳转
  
  6、在性能上有重用

使用说明：
  1.导入头文件
  ```objc 
  #import "FMGImageRoll.h" 
  遵守协议<FMGImageRollDelegate>
  ```
  2.FMGAVPlayer.bundle文件放在Assets.xcassets里面
  
  ```objc
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

更多属性和功能请到头文件中查看。。谢谢！
  ```


