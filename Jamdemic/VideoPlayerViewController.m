//
//  VideoPlayerViewController.m
//  Jamdemic
//
//  Created by Matt Amerige on 8/18/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "XCDYouTubeKit/XCDYouTubeKit.h"

static void *kMoviePlayerContentURLContext = &kMoviePlayerContentURLContext;
static NSString *kKeyPath = @"moviePlayer.contentURL";

@interface VideoPlayerViewController ()

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;


@end

@implementation VideoPlayerViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    
    _currentVideoIndex = 0;
    _videoIDs = [[NSArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _playVideos];
}

- (void)_playVideos
{
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.videoIDs[self.currentVideoIndex]];
    [[NSNotificationCenter defaultCenter] removeObserver:self.videoPlayerViewController name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
    [self.videoPlayerViewController presentInView:self.view];
    [self _registerNotifications];
    [self.videoPlayerViewController addObserver:self forKeyPath:kKeyPath options:0 context:kMoviePlayerContentURLContext];
    [self.videoPlayerViewController.moviePlayer play];
}

- (void)_moviePlayerDidFinish:(NSNotification *)notification
{
    if ([self _hasNextVideo]) {
        self.videoPlayerViewController.videoIdentifier = [self _nextVideoIdentifier];
    }
}

- (void)_registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_moviePlayerDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoPlayerViewController.moviePlayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == kMoviePlayerContentURLContext) {
        [self.videoPlayerViewController.moviePlayer play];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (BOOL)_hasNextVideo
{
    self.currentVideoIndex += 1;
    return self.currentVideoIndex < self.videoIDs.count;
}

- (NSString *)_nextVideoIdentifier
{
    return self.videoIDs[self.currentVideoIndex];
}

- (void)dealloc
{
    [self.videoPlayerViewController removeObserver:self forKeyPath:kKeyPath context:kMoviePlayerContentURLContext];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.videoPlayerViewController.moviePlayer];
}

@end
