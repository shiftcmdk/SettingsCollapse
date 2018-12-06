#import "CustomHeaderFooterView.h"

@interface UITableView ()

@property (getter=_sectionContentInset,nonatomic,readonly) UIEdgeInsets sectionContentInset;

@end

@implementation CustomHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		
		self.visualEffectView = [[[UIVisualEffectView alloc] initWithEffect:blurEffect] autorelease];

		[self.contentView addSubview:self.visualEffectView];
		
		NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

		UIColor *textColor = LCPParseColorString([defaults objectForKey:@"textColor"], @"#FFFFFF");
		UIColor *backgroundColor = LCPParseColorString([defaults objectForKey:@"backgroundColor"], @"#007AFF");

		NSString *showMore = @"Show More";

		NSBundle *widgetsBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Widgets.framework"];

		if (widgetsBundle) {
			showMore = [widgetsBundle localizedStringForKey:@"SHOW_MORE_TITLE" value:@"Show More" table:@"Widgets"];
		}

		self.expandHideButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[self.expandHideButton setTitle:showMore forState:UIControlStateNormal];
		[self.expandHideButton setTitleColor:textColor forState:UIControlStateNormal];
		[self.expandHideButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
		[self.expandHideButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
		[self.expandHideButton setBackgroundColor:backgroundColor/*[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]*/];
		[self.expandHideButton setTintColor:textColor];

		[self.visualEffectView.contentView addSubview:self.expandHideButton];

		self.visualEffectView.clipsToBounds = YES;

		self.useChevron = NO;
	}

	return self;
}

-(void)buttonTapped {
	if (self.delegate) {
		[self.delegate didTapButtonAtIndex:self.index];
	}
}

-(void)layoutSubviews {
	[super layoutSubviews];

	UIUserInterfaceLayoutDirection direction = [UIApplication sharedApplication].userInterfaceLayoutDirection;

	BOOL isRightToLeft = direction == UIUserInterfaceLayoutDirectionRightToLeft;

	CGFloat leftMargin = self.contentView.layoutMargins.left;

	UITableView *tableView = [self valueForKey:@"tableView"];

	if (tableView && tableView.sectionContentInset.left > leftMargin) {
		leftMargin = tableView.sectionContentInset.left;
	}

	self.expandHideButton.imageEdgeInsets = UIEdgeInsetsMake(12.0, 9.0, 12.0, 9.0);

	CGFloat intrinsicWidth = self.useChevron ? 32.0 : self.expandHideButton.intrinsicContentSize.width;
	CGFloat intrinsicHeight = self.useChevron ? 32.0 : self.expandHideButton.intrinsicContentSize.height;
	CGFloat buttonPadding = self.useChevron ? 0.0 : 12.0;
	CGFloat blurViewHeight = self.useChevron ? 32.0 : intrinsicHeight;

	self.visualEffectView.frame = CGRectMake(
		isRightToLeft ? leftMargin : self.contentView.bounds.size.width - leftMargin - 2.0 * buttonPadding - intrinsicWidth,
		self.contentView.bounds.size.height / 2.0 - blurViewHeight / 2.0,
		intrinsicWidth + 2.0 * buttonPadding,
		blurViewHeight
	);

	self.visualEffectView.layer.cornerRadius = blurViewHeight / 2.0;

	self.expandHideButton.frame = CGRectMake(
		0.0,
		0.0,
		intrinsicWidth + 2.0 * buttonPadding,
		blurViewHeight
	);
}

-(void)dealloc {
	[self.expandHideButton removeFromSuperview];

	self.expandHideButton = nil;

	[self.visualEffectView removeFromSuperview];

	self.visualEffectView = nil;

	[super dealloc];
}

@end