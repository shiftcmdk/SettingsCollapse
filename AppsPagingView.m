#import "AppsPagingView.h"
#import "AppIconCell.h"

@implementation AppsPagingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.appImages = [NSMutableArray array];

        UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;

        self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] autorelease];
        self.collectionView.pagingEnabled = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.bounces = YES;
        self.collectionView.alwaysBounceHorizontal = YES;
        ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;

        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;

        [self.collectionView registerClass:[AppIconCell class] forCellWithReuseIdentifier:@"AppIconCell"];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];

        [self addSubview:self.collectionView];

        self.enabledToggles = [NSSet set];
        self.disabledToggles = [NSSet set];
    }

    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppIconCell *cell= (AppIconCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AppIconCell" forIndexPath:indexPath];

    cell.iconImageView.image = self.appImages[indexPath.item];

    cell.dotView.hidden = YES;

    /*if ([self.enabledToggles containsObject:[NSNumber numberWithInt:indexPath.item]]) {
        cell.dotView.hidden = NO;

        cell.dotView.backgroundColor = [UIColor colorWithRed:76.0 / 255.0 green:217.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
    } else if ([self.disabledToggles containsObject:[NSNumber numberWithInt:indexPath.item]]) {
        cell.dotView.hidden = NO;

        cell.dotView.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.dotView.hidden = YES;
    }*/

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate didSelectItemAtIndex:indexPath.item];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.collectionView.frame = CGRectMake(
        0.0,
        0.0,
        self.bounds.size.width,
        self.bounds.size.height
    );
}

-(void)setImages:(NSMutableArray *)images {
    self.appImages = images;

    [self.collectionView reloadData];
}

-(void)setImage:(UIImage *)image atIndex:(int)index {
    if (self.appImages) {
        if (index < self.appImages.count) {
            [self.appImages replaceObjectAtIndex:index withObject:image];

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];

            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

            if (cell) {
                ((AppIconCell *)cell).iconImageView.image = self.appImages[indexPath.item];
            }
        }
    }
}

-(void)updateToggles:(NSSet *)enabledToggles disabledToggles:(NSSet *)disabledToggles {
    /*self.enabledToggles = enabledToggles;
    self.disabledToggles = disabledToggles;

    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

        if (cell) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

            if ([self.enabledToggles containsObject:[NSNumber numberWithInt:indexPath.item]]) {
                ((AppIconCell *)cell).dotView.hidden = NO;

                ((AppIconCell *)cell).dotView.backgroundColor = [UIColor colorWithRed:76.0 / 255.0 green:217.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
            } else if ([self.disabledToggles containsObject:[NSNumber numberWithInt:indexPath.item]]) {
                ((AppIconCell *)cell).dotView.hidden = NO;

                ((AppIconCell *)cell).dotView.backgroundColor = [UIColor lightGrayColor];
            } else {
                ((AppIconCell *)cell).dotView.hidden = YES;
            }
        }
    }*/
}

-(CGSize)cellSize {
    return CGSizeMake(59.0, 59.0 + 1.0 / [UIScreen mainScreen].scale);
}

-(void)dealloc {
    self.appImages = nil;

    self.enabledToggles = nil;

    self.disabledToggles = nil;

    [self.collectionView removeFromSuperview];

    self.collectionView = nil;

    [super dealloc];
}

@end