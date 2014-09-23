    target triple = "x86_64-apple-macosx10.9.0"
    
    define void @add(i32* %a, i32* %b, i32* %c) #0 {
      %1 = alloca i32*, align 8
      %2 = alloca i32*, align 8
      %3 = alloca i32*, align 8
      store i32* %a, i32** %1, align 8
      store i32* %b, i32** %2, align 8
      store i32* %c, i32** %3, align 8
      %4 = load i32** %1, align 8
      %5 = load i32* %4, align 4
      %6 = load i32** %2, align 8
      %7 = load i32* %6, align 4
      %8 = add nsw i32 %5, %7
      %9 = load i32** %3, align 8
      store i32 %8, i32* %9, align 4
      ret void
    }
    
    !llvm.ident = !{!0}
