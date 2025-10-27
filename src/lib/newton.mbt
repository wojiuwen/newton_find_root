//0.总的要加入错误处理

//----给牛顿法加入自动寻找初始点的方法

//1.如果导数为0的时候需要放回ERROR
pub fn newton(f: (Double) -> Double, x: Double) -> Double {
    let fx = f(x);
    let dfx = derivative(f, x,None); 
    if(dfx==0){
        //错误处理如果dfx==0时会返回错误
        return 0.0
    }

    return x - fx / dfx;
}



//2.加入一个二分法求根
// 二分法求根
pub fn bisection(f: (Double) -> Double,a: Double, b: Double) -> Double {
    // 确保区间有效
    let mut a_1=a
    let mut b_1=b
    if f(a_1) * f(b_1) > 0.0 {
        // 尝试扩大搜索范围
        a_1 = a- 1.0;
        b_1 = b+ 1.0;
        if f(a_1) * f(b_1) > 0.0 {
            //返回错误
            return 0.0
        }
    }
    
    let mut mid = (a_1 + b_1) / 2.0;
    while ((b_1 - a_1).abs() >0.0000000001){
        if f(mid).abs() <0.00000000001{
            break;
        }
        
        if f(a_1) * f(mid) < 0.0 {
            b_1 = mid;
        } else {
            a_1 = mid;
        }
        mid = (a_1 + b_1) / 2.0;
    }
    return mid;
}


//3.把find_root 改成混合计算，牛顿法迭代到一定次数后如果还不收敛就切换成二分法，如果二分法还不行，就返回ERROR
//单牛顿法
pub fn find_root(f:(Double)->Double,x:Double)->Double{
   let mut count=0
   let mut number=newton(f,x)
   while(f(number)>0.00000001){
    count=count+1
    // if(count==30){
    //     //如果迭代次数超过30，返回错误
    //     return 0.0
    // }
    number=newton(f,number)
   }
   
   return number
}

//混合牛顿法
pub fn find_root_2(f: (Double) -> Double, x0: Double) -> Double {
    let max_count= 30 ;
     
    let totlerance = 0.0000000001;   // 收敛阈值
    let mut x = x0;
    let mut safe_interval_1=(x0-1.0)
    let mut safe_interval_2=(x0+1.0)
    let mut count=0
    let mut find=false
    while(count<max_count) {
        let result = newton(f, x);
        x = result;
        safe_interval_1 = min(safe_interval_1,x-1.0)
        safe_interval_2 = max(safe_interval_2,x+1.0);

        // 检查收敛
        if f(x).abs() < totlerance {
            find=true
            return x;
        }

        count=count+1
    }
    
    // 牛顿法失效时切换到二分法
    if(!find){
         return bisection(f, safe_interval_1, safe_interval_2);
    }
        
    
    return x;
}


