//
//  serverViewController.m
//  LearnSocket
//
//  Created by zc on 2017/12/14.
//  Copyright © 2017年 IMpBear. All rights reserved.
//

#import "serverViewController.h"
#import "SocketManager.h"
@interface serverViewController ()<GCDAsyncSocketDelegate>
{
    NSString *logMessage ;
}
@property (weak, nonatomic) IBOutlet UITextField *portTxt;   // 端口号
@property (weak, nonatomic) IBOutlet UITextField *sendTxt;   // 内容
@property (weak, nonatomic) IBOutlet UIButton *montiorBtn;   // 监听按钮
@property (weak, nonatomic) IBOutlet UIButton *sendTxtBtn;   // 发送内容
@property (weak, nonatomic) IBOutlet UIButton *sendFileBtn;  // 发送文件
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;   // 接收按钮
@property (weak, nonatomic) IBOutlet UITextView *logTxtView; // 日志

@property(nonatomic,strong) GCDAsyncSocket *serverSocket ;

@property(nonatomic,strong) GCDAsyncSocket *clientSocket ;

@property(nonatomic,strong) SocketManager *sockManager ;


@end

@implementation serverViewController

-(SocketManager *)sockManager{
    if (!_sockManager) {
        _sockManager = [SocketManager SharedManager] ;
    }
    return _sockManager ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"服务端";
    logMessage = @"欢迎来到IMpBear的Socket服务端" ;
    
    [self inputBtn:self.montiorBtn];
    [self inputBtn:self.sendTxtBtn];
    [self inputBtn:self.sendFileBtn];
    [self inputBtn:self.receiveBtn];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self regisnKeyBoard];
}


-(void)inputBtn:(UIButton *)btn {
    btn.layer.cornerRadius = 10 ;
    btn.clipsToBounds = YES ;
}

#pragma mark -- 监听
- (IBAction)monitorBtn:(id)sender {
    // 1. 创建服务器socket
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 开放哪些端口
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portTxt.text.integerValue error:&error];
    
    // 3. 判断端口号是否开放成功
    if (result) {
        NSString *ip = [IMpBearSockHelper deviceIPAdress] ;
        [self inputLogStr:[NSString stringWithFormat:@"端口号开放成功,ip地址：%@",ip]];
    } else {
        [self inputLogStr:@"端口号开放失败"];
    }
    
    [self regisnKeyBoard];
}

// 输出日志
-(void)inputLogStr:(NSString *)logStr{
   
    logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",logStr]] ;
    
    self.logTxtView.text = logMessage ;
}

#pragma mark -- SocketDelegate

// 当客户端链接服务器端的socket, 为客户端单生成一个socket
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [self inputLogStr:@"sock连接成功"];
    [self inputLogStr:[NSString stringWithFormat:@"连接的ip地址:%@", newSocket.connectedHost]];
    //[self inputLogStr:[NSString stringWithFormat:@"客户端连接的端口号:%tu", newSocket.connectedPort]];
    self.clientSocket = newSocket;
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

// 服务端接收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"这是接收到client 发送的包数据 ---- %@",data) ;
}

-(void)regisnKeyBoard{
    [self.portTxt resignFirstResponder];
    [self.sendTxt resignFirstResponder];
    [self.logTxtView resignFirstResponder];
}

#pragma mark -- 发送文本内容
- (IBAction)sendTxt:(id)sender {
    
    // 文本字符串转化为data数据
    NSData *data = [self.sendTxt.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];

    [self.sockManager.impBearSocket readDataWithTimeout:-1 tag:0];
    
    [self regisnKeyBoard];
}
#pragma mark -- 发送文件
- (IBAction)sendFile:(id)sender {
    
    NSString *localPath = [[NSBundle mainBundle]pathForResource:@"客户端" ofType:@"png"];
    NSData *imgData = [NSData dataWithContentsOfFile:localPath] ;
    
    [self.clientSocket writeData:imgData withTimeout:-1 tag:0];
    
    [self.sockManager.impBearSocket readDataWithTimeout:-1 tag:0];
    [self regisnKeyBoard];
}
#pragma mark -- 接收按钮
- (IBAction)receiveBtn:(id)sender {
    [self.clientSocket readDataWithTimeout:-1 tag:0];
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
