#import <UIKit/UIKit.h>

@protocol StatesViewControllerDelegate

- (void)didSelectState:(NSString *)state;

@end

@interface StatesViewController : UITableViewController

@property (weak) id<StatesViewControllerDelegate> delegate;
@property (strong) NSString *state;

@end
