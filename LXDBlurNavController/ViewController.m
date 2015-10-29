//
//  ViewController.m
//  LXDBlurNavController
//
//  Created by 林欣达 on 15/10/29.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "ViewController.h"

#define MAX_BLUR 0.7
#define MAX_ALPHA 0.2

@interface ViewController ()

@property (nonatomic, assign) CGFloat imageHeight;

@property (nonatomic, strong) UIImage * originImage;

@property (nonatomic, strong) UIVisualEffectView * blurView;

@property (nonatomic, strong) UIImageView * headerImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.view insertSubview: self.headerImage belowSubview: self.navigationController.navigationBar];
    [_headerImage addSubview: self.blurView];
    [self.tableView addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueObservingOptionNew context: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _originImage = [UIImage imageNamed: @"Tutorial-2"];
        CGFloat scale = _originImage.size.height / _originImage.size.width;
        CGFloat imageWidth = CGRectGetWidth(self.view.bounds);
        _imageHeight = imageWidth * scale;
        
        _headerImage = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, imageWidth, _imageHeight)];
        _headerImage.image = _originImage;
        self.tableView.contentInset = UIEdgeInsetsMake(_imageHeight, 0, 0, 0);
    }
    return _headerImage;
}

- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark]];
        _blurView.frame = _headerImage.bounds;
        _blurView.alpha = 0.f;
    }
    return _blurView;
}

- (void)setupNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"bigShadow"] forBarMetrics: UIBarMetricsCompact];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
}


#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat offsetY = self.tableView.contentOffset.y + _imageHeight;
    if (offsetY < 0 || offsetY > _imageHeight - 64.f) { return; }
    
    CGRect frame = _headerImage.frame;
    frame.origin.y = -offsetY;
    _headerImage.frame = frame;
    
    CGFloat delta = offsetY / (_imageHeight - 64.f);
    _blurView.alpha = delta * MAX_BLUR;
    _headerImage.alpha = 1 - delta * MAX_ALPHA;
    NSLog(@"%f", delta);
}


@end
