//
//  clientViewController.m
//  LearnSocket
//
//  Created by zc on 2017/12/14.
//  Copyright © 2017年 IMpBear. All rights reserved.
//

#import "clientViewController.h"
#import "SocketManager.h"
@interface clientViewController ()<GCDAsyncSocketDelegate>
{
    NSString *logMessage ;
}
@property (weak, nonatomic) IBOutlet UITextField *ipText;
@property (weak, nonatomic) IBOutlet UITextField *portTxt;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UITextField *sendTxt;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextView *logTxtView;
@property(nonatomic,strong) SocketManager *sockManager ;
@property(nonatomic,strong) GCDAsyncSocket *clientSocket ;
@end

@implementation clientViewController


-(SocketManager *)sockManager{
    if (!_sockManager) {
        _sockManager = [SocketManager SharedManager] ;
    }
    return _sockManager ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"客户端";
    logMessage = @"客户端日志系统:" ; 
    [self inputBtn:self.connectBtn];
    [self inputBtn:self.sendBtn];
}



- (IBAction)connetSocket:(id)sender {
    
    // 1. 创建socket
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 与服务器的socket链接起来
    NSError *error = nil;
    BOOL result = [self.clientSocket connectToHost:self.ipText.text onPort:self.portTxt.text.integerValue error:&error];
    
    if (error) {
        NSLog(@"连接失败: %@", error.description);
    }else{
        NSLog(@"连接成功") ;
    }
    
    // 3. 判断连接是否成功
    if (result) {
        [self inputLogStr:@"client端sock连接服务器成功!"];
    } else {
        [self inputLogStr:@"client端sock连接服务器失败!"];
    }
    [self regisnKeyBoard];
    
}

#pragma mark - GCDAsyncSocketDelegate
// 客户端连接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self inputLogStr:[NSString stringWithFormat:@"socket 连接成功 ip == %@，port -- %d", host,port]];
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
    self.sockManager.impBearSocket = self.clientSocket;
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"客户端接收到的内容") ;
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (content.length) {
        [self inputLogStr:content];
    }else{
        NSLog(@"data ---  %@",data) ;
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"心跳包已发送Tag: %ld", tag);
    if (sock.isConnected) {
        [sock readDataWithTimeout:-1 tag:tag];
    }
}

#pragma mark --连接失败
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socket 连接失败error   --  %@",err) ;
    // 可以做重连处理
}


- (IBAction)sendTxt:(id)sender {
    NSData *data = [self.sendTxt.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
   
    [self.sockManager.impBearSocket readDataWithTimeout:-1 tag:0];
    [self regisnKeyBoard];
}


-(void)inputBtn:(UIButton *)btn {
    btn.layer.cornerRadius = 10 ;
    btn.clipsToBounds = YES ;
}

// 输出日志
-(void)inputLogStr:(NSString *)logStr{
    
    logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",logStr]] ;
    
    self.logTxtView.text = logMessage ;
}

-(void)regisnKeyBoard{
    [self.portTxt resignFirstResponder];
    [self.sendTxt resignFirstResponder];
    [self.logTxtView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self regisnKeyBoard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
