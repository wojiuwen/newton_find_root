pub fn min(d1:Double,d2:Double)->Double{
    if(d1>d2){
        return d2
    }else{
        return d1
    }
}

pub fn max(d1:Double,d2:Double)->Double{
   if(d1>d2){
      return d1
   }else{
      return d2
   }
}
//数值微分+外推，后面可以考虑增加自动微分
pub fn derivative(f: (Double) -> Double, x: Double, h: Option[Double]) -> Double {
    // 设置外推级别（越高精度越高，计算量越大）
    let levels = 4  // 推荐4级外推，精度可达O(h^8)
    
    // 确定初始步长
    let initial_step = match h {
        Some(value) => value
        None => {
            // 自适应初始步长，基于x的大小
            let abs_x = if x < 0.0 { -x } else { x }
            let min_step = 0.000000001  // 1e-9
            if abs_x < 0.000000000000001 { min_step } else { max(abs_x * 0.00000001, min_step) }
        }
    }
    
    // 创建外推表格
    let  table = Array::make(levels + 1, Array::make(levels + 1, 0.0))
    
    let mut current_step = initial_step
    
    // 填充第一列（基本中心差分近似）
    for i in 0..=levels {
        table[i][0] = (f(x + current_step) - f(x - current_step)) / (2.0 * current_step)
        current_step = current_step / 2.0  // 步长减半
    }
    
    // Richardson 外推过程
    for j in 1..=levels {
        let factor = @math.pow(4.0,j.to_double())  // 外推因子
        
        for i in j..=levels {
            table[i][j] = (factor * table[i][j-1] - table[i-1][j-1]) / (factor - 1.0)
        }
    }
    
    // 返回最高精度的结果（表格右下角的值）
    table[levels][levels]
}