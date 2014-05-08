//
//  ImageViewController.m
//  MyGamesTracker
//
//  Created by MIMO on 20/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.

#import "ImageViewController.h"
#import "NetworkAPIEngine.h"

static const float kMinimumZoomScale = 1.0;
static const float kMaximumZoomScale = 4.0;

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Properties

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;   // does not change the frame of the UIImageView

    // To fix a bug in "reusing" ImageViewController's MVC
    self.scrollView.zoomScale = kMinimumZoomScale;
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // self.scrollView could be nil on the next line if outlet-setting has not happened yet
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;

    [self.spinner stopAnimating];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // Zooming
    _scrollView.minimumZoomScale = kMinimumZoomScale;
    _scrollView.maximumZoomScale = kMaximumZoomScale;
    _scrollView.delegate = self;

    // In case self.image gets set before self.scrollView
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Setting the Image from the Image's URL

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    [self getCoverWithURL];
}

- (void)getCoverWithURL
{
    
    self.image = nil;
    if (self.imageURL)
    {
        [self.spinner startAnimating];
    
        // Fetch Cover from API
        [[NetworkAPIEngine sharedInstance] fetchImageWithURL:self.imageURL
                                                onCompletion:^(UIImage *image, NSError *error) {
                                                    if (!error) {
                                                        self.image = image;
                                                    } else {
                                                        self.image = [UIImage imageNamed:@"coverHI.png"];
                                                    }
                                                    
                                                }];
    }
    
}

@end
