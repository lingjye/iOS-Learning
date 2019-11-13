//
//  ViewController.swift
//  iOS_Learning
//
//  Created by txooo on 2019/1/3.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.队列
//        queue()
        //2.QoS队列
//        queueOfQos()
        //3. QoSConcurrent
//        queueOfQosConcurrent()
//        queueOfQosConcurrent2()
        //4. 不活跃队列
//        let queue =
//        qosInitiallyInactive()
        //通过activate()激活, 否则会崩溃
//        queue.activate()
        //5.延时
//        delayQueue()
        //DispatchWorkItem
//        queueDispatchWorkItem()
        //5
        queueUpdateUI()
        
        var a = 0
        while a <= 5 {
            DispatchQueue.global(qos: .userInitiated).async {
                a += 1;
            }
            
        }
        print("a=%i",a)
    }
    
    func queue() {
        //1 创建队列
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier!)
        //2 创建任务
        queue.async {
            for i in 0..<10 {
                print("同步队列执行",i)
            }
            //number可能在某一值(async时 例如3 sync 为主线程)后不变 说明线程没有被重新创建, 线程执行完不被销毁, 而是放入线程池, 待下次创建新任务时直接取出
            print(Thread.current)
        }
        
        for j in 0..<10 {
            print("同步执行----", j)
        }
    }
    
    func queueOfQos() {
        //创建一个QoS队列
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier!, qos: DispatchQoS.unspecified)
        //QoS默认串行执行, 即使QoS队列中的方法是异步的还是会被顺序串行执行
        queue.async {
            for i in 0..<10 {
                print("Qos队列---",i)
            }
        }
        queue.async {
            for k in 100 ..< 110 {
                print("Qos队列++", k)
            }
        }
    }
    
    func queueOfQosConcurrent() {
        //同个队列同等级 并行输出 对比
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier!, qos:.utility, attributes:.concurrent)
        queue.async {
            for i in 0 ..< 10 {
                print("Concurrent---", i)
            }
        }
        
        queue.async {
            for k in 100 ..< 110 {
                print("Concurrent+++", k)
            }
        }
        
    }
    
    func queueOfQosConcurrent2() {
        //不同队列不同等级对比 高低等级交叉进行输出, 并非等级越高队列会先追星玩
        let queue1 = DispatchQueue(label: Bundle.main.bundleIdentifier!, qos: .userInteractive)
        let queue2 = DispatchQueue(label: Bundle.main.bundleIdentifier! + "1", qos: .utility)
        
        queue1.async {
            for i in 0 ..< 10 {
                print("Qos异步不同等级", i)
                sleep(1)
            }
            print(Thread.current)
        }
        
        queue2.async {
            for k in 0 ..< 10 {
                print("Qos异步不同等级---", k)
                sleep(1)
            }
        }
        
        //同步主队列执行 main queue先执行
        for j in 0 ..< 10 {
            print("主队列:", j)
            sleep(1)
        }
    }
    
    func qosInitiallyInactive() -> DispatchQueue {
        //qos不活跃的队列 需要调用DispatchQue类的activate()让任务执行
        //attributes参数设置为initiallyInactive
        //同个队列同等级 不活跃 输出
        //设置 initiallys需要调用DispatchQueue类的activate()方法
        //激活后队列默认串行输出 , 并行输出可采用attributes:[initiallyInactive, .concurrent]
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier!, qos: .utility, attributes: [.initiallyInactive, .concurrent])
        queue.async(execute:  {
            for i in 0 ..< 10 {
                print("不活跃队列", i)
            }
        })
        queue.async {
            for k in 100 ..< 110 {
                print("不活跃队列----", k)
            }
        }
        
        return queue
    }
    
    func delayQueue() {
        //延迟执行
        let delayQueue = DispatchQueue(label: Bundle.main.bundleIdentifier!, qos: .userInteractive)
        
        
        /*
         secods(Int)/秒
         milliseconds(Int)/毫秒
         nanoseconds(Int)/纳秒
         */
        let delayTime: DispatchTimeInterval = .seconds(5)
        print("delay:", Date())
        delayQueue.asyncAfter(deadline:.now() + delayTime) {
            print("Now", Date())
        }
        
    }
    
    func queueDispatchWorkItem() {
        //代码块 可以被分到任何队列 包含的代码可以在后台后者主线程中被执行,简单来说:他被用于替换前面写的代码block来调用
        var num = 9
        let workItem = DispatchWorkItem(block: {
            num = num + 5
        })
        workItem.perform() //激活workitem代码块
        let queue = DispatchQueue.global(qos: .utility)
        
        
        //可能是19也可能是14
        workItem.notify(queue: DispatchQueue.main) {
            print("workItem完成后的通知:", num)
        }
        //异步队列执行 同步sync时必定是19
        queue.async(execute: workItem)
    }
    
    func queueUpdateUI() {
        if (self.photo.image != nil) {
            return
        }
        view.addSubview(self.photo)
        //主线程更新UI
        let imageUrl = URL(string: "https://cdn2.jianshu.io/assets/default_avatar/12-aeeea4bedf10f2a12c0d50d626951489.jpg")
        let session = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: imageUrl!, completionHandler: { (imageData, respnse, error) in
            if imageData != nil {
                print("Download image data complete")
                DispatchQueue.main.async(execute: {
                    self.photo.image = UIImage(data: imageData!)
                })
            }
        })
        session.resume()
    }
    
    lazy var photo:UIImageView = {
       let photo = UIImageView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        return photo
    }()
    
}

