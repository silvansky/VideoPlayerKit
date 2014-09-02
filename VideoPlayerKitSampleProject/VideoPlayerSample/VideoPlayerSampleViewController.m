/* Copyright (C) 2012 IGN Entertainment, Inc. */

#import "VideoPlayerSampleViewController.h"
#import "VideoPlayerSampleView.h"

@interface VideoPlayerSampleViewController ()

@property (nonatomic, strong) VideoPlayerKit *videoPlayerViewController;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) VideoPlayerSampleView *videoPlayerSampleView;
@end

@implementation VideoPlayerSampleViewController

- (id)init
{
    if ((self = [super init])) {
        
        // Optional Top View
        _topView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, 200, 40.0);
        [button addTarget:self
                   action:@selector(fullScreen)
         forControlEvents:UIControlEventTouchDown];
        
        [button setTitle:@"Full Screen!" forState:UIControlStateNormal];
        [_topView addSubview:button];

		self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingViewController:self optionalTopView:nil hideTopViewWithControls:YES];
		// Need to set edge inset if top view is inserted
		[self.videoPlayerViewController setControlsEdgeInsets:UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0)];
		self.videoPlayerViewController.delegate = self;
		self.videoPlayerViewController.allowPortraitFullscreen = YES;
		self.videoPlayerViewController.videoPlayerView.fullScreenButton.hidden = YES;
		self.videoPlayerViewController.videoPlayerView.shareButton.hidden = YES;
    }
    return self;
}

// Fullscreen / minimize without need for user's input
- (void)fullScreen
{
    if (!self.videoPlayerViewController.fullScreenModeToggled) {
        [self.videoPlayerViewController launchFullScreen];
    } else {
        [self.videoPlayerViewController minimizeVideo];
    }
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)loadView
{
    self.videoPlayerSampleView = [[VideoPlayerSampleView alloc] initWithTopView:nil videoPlayerView:self.videoPlayerViewController.view];
//    [self.videoPlayerSampleView.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self setView:self.videoPlayerSampleView];
}

- (void)playVideo
{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/tmp.songsterr.com/change-D-C.mp4"];
    
//    [self.view addSubview:self.videoPlayerViewController.view];
    
    [self.videoPlayerViewController playVideoWithTitle:@"D -> C" URL:url videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.bounds.size.width, 44);
	[self playVideo];
}

@end
