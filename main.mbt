fn main{
   fn f_1(x:Double){
    return x*x
   }
   println(@math_lib.find_root(f_1,1))
   println(@math_lib.find_root_2(f_1,1))
   fn f_2(x:Double){
    return @math.exp(x)-5
   }
   println(@math_lib.find_root(f_2,0))
   println(@math_lib.find_root_2(f_2,0))
}

