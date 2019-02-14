/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImagePrefetcher.h"

@interface SDWebImagePrefetcher ()

@property (strong, nonatomic, nonnull) SDWebImageManager *manager;
@property (strong, atomic, nullable) NSArray<NSURL *> *prefetchURLs; // may be accessed from different queue
@property (assign, nonatomic) NSUInteger requestedCount;//请求的数目
@property (assign, nonatomic) NSUInteger skippedCount;//忽略的请求数目（没有图片）
@property (assign, nonatomic) NSUInteger finishedCount;//完成的请求数目
@property (assign, nonatomic) NSTimeInterval startedTime;
@property (copy, nonatomic, nullable) SDWebImagePrefetcherCompletionBlock completionBlock;
@property (copy, nonatomic, nullable) SDWebImagePrefetcherProgressBlock progressBlock;

@end

@implementation SDWebImagePrefetcher

+ (nonnull instancetype)sharedImagePrefetcher {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    return [self initWithImageManager:[SDWebImageManager new]];
}

- (nonnull instancetype)initWithImageManager:(SDWebImageManager *)manager {
    if ((self = [super init])) {
        _manager = manager;
        _options = SDWebImageLowPriority;
        _prefetcherQueue = dispatch_get_main_queue();
        self.maxConcurrentDownloads = 3;
    }
    return self;
}

- (void)setMaxConcurrentDownloads:(NSUInteger)maxConcurrentDownloads {
    self.manager.imageDownloader.maxConcurrentDownloads = maxConcurrentDownloads;
}

- (NSUInteger)maxConcurrentDownloads {
    return self.manager.imageDownloader.maxConcurrentDownloads;
}


/**
 根据索引预取图片

 @param index 索引值
 */
- (void)startPrefetchingAtIndex:(NSUInteger)index {
    NSURL *currentURL;
    @synchronized(self) {
        if (index >= self.prefetchURLs.count) return;//越界了
        currentURL = self.prefetchURLs[index];
        self.requestedCount++;//请求数加一
    }
    [self.manager loadImageWithURL:currentURL options:self.options progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!finished) return;
        self.finishedCount++;//完成数加一

        if (self.progressBlock) {//完成了，回调
            self.progressBlock(self.finishedCount,(self.prefetchURLs).count);
        }
        if (!image) {
            // Add last failed
            self.skippedCount++;//加载完了，但没有图片，忽略数加一
        }
        if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didPrefetchURL:finishedCount:totalCount:)]) {//该图片加载完成
            [self.delegate imagePrefetcher:self
                            didPrefetchURL:currentURL
                             finishedCount:self.finishedCount
                                totalCount:self.prefetchURLs.count
             ];
        }
        if (self.prefetchURLs.count > self.requestedCount) {//预加载总数目大于请求数，继续预加载
            dispatch_async(self.prefetcherQueue, ^{//异步递归，防止堆栈溢出
                // we need dispatch to avoid function recursion call. This can prevent stack overflow even for huge urls list
                [self startPrefetchingAtIndex:self.requestedCount];//调用本身
            });
        } else if (self.finishedCount == self.requestedCount) {//请求数等于完成数，该图片加载完成，且所有的图片都加载完成（else）
            [self reportStatus];//报告完成状态
            if (self.completionBlock) {
                self.completionBlock(self.finishedCount, self.skippedCount);
                self.completionBlock = nil;
            }
            self.progressBlock = nil;
        }
    }];
}


/**
 报告图片完成状态
 */
- (void)reportStatus {
    NSUInteger total = (self.prefetchURLs).count;
    if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didFinishWithTotalCount:skippedCount:)]) {//所有图片加载完成
        [self.delegate imagePrefetcher:self
               didFinishWithTotalCount:(total - self.skippedCount)
                          skippedCount:self.skippedCount
         ];
    }
}

- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls {
    [self prefetchURLs:urls progress:nil completed:nil];
}

- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls
            progress:(nullable SDWebImagePrefetcherProgressBlock)progressBlock
           completed:(nullable SDWebImagePrefetcherCompletionBlock)completionBlock {
    [self cancelPrefetching]; // Prevent duplicate prefetch request 取消图片预取，防止重复操作
    self.startedTime = CFAbsoluteTimeGetCurrent();
    self.prefetchURLs = urls;
    self.completionBlock = completionBlock;
    self.progressBlock = progressBlock;

    if (urls.count == 0) {
        if (completionBlock) {
            completionBlock(0,0);
        }
    } else {
        // Starts prefetching from the very first image on the list with the max allowed concurrency
        NSUInteger listCount = self.prefetchURLs.count;
        for (NSUInteger i = 0; i < self.maxConcurrentDownloads && self.requestedCount < listCount; i++) {//取图片
            [self startPrefetchingAtIndex:i];
        }
    }
}


/**
取消图片预加载
 */
- (void)cancelPrefetching {
    @synchronized(self) {
        self.prefetchURLs = nil;
        self.skippedCount = 0;
        self.requestedCount = 0;
        self.finishedCount = 0;
    }
    [self.manager cancelAll];
}

@end
