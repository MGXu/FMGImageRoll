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
  #import "FMGVideoPlayView.h" 
  #import "FullViewController.h"
  ```
  2.FMGAVPlayer.bundle文件放在Assets.xcassets里面
  
  ```objc
  - (void)viewDidLoad {
    [super viewDidLoad];

    FMGVideoPlayView *playView = [FMGVideoPlayView videoPlayView];
    // 视频资源路径
    [playView setUrlString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
    // 播放器显示位置（竖屏时）
    playView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    // 添加到当前控制器的view上
    [self.view addSubview:playView];

    // 指定一个作为播放的控制器
    playView.contrainerViewController = self;
    
}

  ```


