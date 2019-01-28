#import "AppIconCell.h"

@implementation AppIconCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGSize imageSize = CGSizeMake(29.0, 29.0);

        self.iconImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(
            0.0, 
            0.0, 
            imageSize.height, 
            imageSize.width
        )] autorelease];

        [self.contentView addSubview:self.iconImageView];

        CGSize dotSize = CGSizeMake(6.0, 6.0);

        self.dotView = [[[UIView alloc] initWithFrame:CGRectMake(
            0.0,
            0.0,
            dotSize.width,
            dotSize.height
        )] autorelease];

        self.dotView.layer.cornerRadius = dotSize.height / 2.0;

        self.dotView.backgroundColor = [UIColor colorWithRed:76.0 / 255.0 green:217.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];

        [self.contentView addSubview:self.dotView];
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.iconImageView.center = CGPointMake(
        self.contentView.bounds.size.width / 2.0,
        self.contentView.bounds.size.height / 2.0
    );

    CGFloat imageBottom = self.iconImageView.frame.origin.y + self.iconImageView.bounds.size.height;

    self.dotView.center = CGPointMake(
        self.iconImageView.center.x,
        imageBottom + (self.contentView.bounds.size.height - imageBottom) / 2.0
    );
}

-(void)dealloc {
    [self.iconImageView removeFromSuperview];
    
    self.iconImageView = nil;
    
    [self.dotView removeFromSuperview];
    
    self.dotView = nil;
    
    [super dealloc];
}

@end