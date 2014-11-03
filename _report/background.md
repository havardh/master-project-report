---
layout: page
title: Background
permalink: /report/background/
order: 3
---

Programming a modern GPU is a hard problem. A lot of architecture
specific aspects has to be taken into consideration. Traditionaly
these devices can only be programmed in low level languages such as
C/C++. Software libraries and language bindings does exist for higher
level languages enabling a user of such a language make use of the
device, but the core implementation is still in a low level language.

The Julia programming language aims to unify the two worlds of high
productivity, given by abstractions, and high performance, given by a
staticaly compiled language. This will enable users of this seemingly
high level language to dive into optimizing their applications without
having to resort to a lower level language for the
implementation.

This project tries to do the same in the realm of GPU
programming. This is possible due to the fact that Julia is
implemented on top of LLVM which also is the basis for both NVVM and
SPIR, the intermediate representations of Nvidia and OpenCL compilers. 

# State of the art #

Programming a GPU started out with a fixed pipeline with programmable
steps used for rendering 3D graphics. In 2006 with the introduction of
__CUDA__ by nVidia and __APP__ by AMD in 2007, __GPGPU__ was
introduced and the pipeline fully programmable. Microsoft released
__DirectCompute__ along with DirectX11 in 2008 that exposes a API for
the GPU to the programmer in C++. In 2009 the Khronos Group released
the first specification of __OpenCL__ which tries to provide a
platform independent language for programming heterogeneous
systems. The __OpenACC__ standard was released in 2011 enabling
programmers to execute code on GPUs with directives as OpenMP enables
multiple threads. In 2012 Microsoft released __C++ AMP__, a C++
language and programming model extension. Microsoft released a
compiler for their own __DirectCompute__ framework, and Intel and AMD
has later released compilers based on the specification. __Numba__
introduced by Continuum Analytics and is still in development (2014),
it enables executing Python code on a nVidia GPU.

Out of these CUDA and OpenCL are most suited for considerations in
this projects as they can be used as compiler targets. The others
mentioned are software libraries that build on these underlying standards.

# Intermediate Representations #

In the last few years both OpenCL and CUDA has started targeting the
LLVM compiler infrastructure. Nvidia released part of their compiler
in 2009. This included the PTX backend and the libNVVM optimizing
compiler, both based on LLVM. They also introduced a new intermediate
representation called NVVM which is largely based on LLVM IR. In 2012
the Khronos Group introduced OpenCL SPIR, a intermediate
representation also based on LLVM IR. 

## LLVM IR ##

This section will introduce the LLVM intermediate representation
briefly as the representations described in the next to subsections
are extensions to it.

LLVM IR is a compiler internal intermediate representation. It is
intended as a good representation for compiler optimization and
analysis. The representation has three forms, a human readable format
(.ll), a bitcode format (.bc) and an in memory format. These three
forms are all equivalent.

The format is SSA, Static Single Assignment which makes reasoning
about the code easy. The language consists of modules that contains a
target, function declarations and implementations, types
specifications, attributes and metadata.

This is a typical LLVM program:

{% highlight llvm %}
; ModuleID = 'add.bc'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

; Function Attrs: nounwind ssp uwtable
define void @add(i64* %a, i64* %b, i64* %c) #0 {
  ; code 
  ret void
}

declare i64 @get_global_id(i32)

attributes #0 = { nounwind ssp uwtable  }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn)"}

{% endhighlight %}

The first two lines specifies the underlying target architecture with
__datalayout__ and __target triple__. Next is a function
implementation of the __add__ function, the __#0__ binds the function
to the attributes _nounwind ssp uwtable_. Next a declaration of
__get_global_id__ follows, then the mentioned metadata. The last two
lines specifies metadata. LLVM contains both named metadata and
unnamed. The unnamed section gets assigned numbers _!0_ in this case.
The _!llvm.ident_ referes to this unnamed node. We see alot of
referals in the metadata section of LLVM modules.


## SPIR ##

SPIR is OpenCLs new format for representing kernel for execution on
heterogeneous systems. The specification is a mapping from OpenCL C
into LLVM IR. SPIR does not add a lot of extra to the LLVM IR. The
notable differences are __target datalayout__ and __triple__, a named
metadata node for specifying kernels, specification of address space
qualifiers and name mangling rules. In kernel argument information is
carried in the metadata section.

{% highlight llvm %}
; ModuleID = 'OpenCL Module'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "spir64-unknown-unknown"

declare i64 @_Z13get_global_idj(i32)

define void @add(i64 addrspace(1)*, i64 addrspace(1)*, i64 addrspace(1)*) {
  ; code
  ret void
}

!llvm.ident = !{!0}
!opencl.kernels = !{!1}

!0 = metadata !{metadata !"Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn)"}
!1 = metadata !{void (i64 addrspace(1)*, i64 addrspace(1)*, i64 addrspace(1)*)* @add}
{% endhighlight %}

### The kernels metadata node ###
All SPIR modules must contain the named metadata node
__opencl.kernels__. The value of this node is a list of the kernel
functions in the module. For each kernel the signature must be
included in the metadata section. As seen above the opencl.kernels
node points to the method signature in _!1_ and this node matches the
signature of the function.

### Address Space Qualifiers ###
The qualifier used in the parameter list of the add functions shows
how address space qualifiers are utilized in SPIR. This qualifiers
denotes what type of memory is used on the device.

Qualifier | Memory   | Comment
----------|----------|-----------------------------
0         | private  | Private to each work item
1         | global   | Global for the entire device
2         | constant | Global for the entire device
3         | local    | Private to each work group
4         | generic  | TODO: I dunno 

The example above uses only the global memory space.

### Name Mangling ###

OpenCL contains many builtin overloaded functions like the math
function __sin__. Name mangling is used to distinguish between the
different implementations based on their argument types. In the
example above the _get_global_id_ is mangled into
__Z13get_global_idj_, the mangling rules are based on the rules for
the Intel Itanium.

## NVVM ##

NVVM is nVidias intermediate representation used in the its LLVM based
compiler for CUDA. It does as SPIR represent device kernels that are
intended to be executed on a GPU solely. NVVM ads to LLVM IR a set of
intrinsic functions for controlling the GPU. Among these are barriers,
address space conversions, special register accessors. The NVVM Cuda
Compiler compiles NVVM IR into PTX which is loaded into a the devices
with either the CUDA or OpenCL driver provided by nVidia. Like SPIR it
defines targets, address space qualifiers and a metadata node to
declare a function as a kernel.

{% highlight llvm %}
; ModuleID = 'OpenCL Module'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024"
target triple = "nvptx64-nvidia-cuda"

declare i32 @llvm.nvvm.read.ptx.sreg.tid.x()

define void @add(i64 addrspace(1)*, i64 addrspace(1)*, i64 addrspace(1)*) {
  ; code
  ret void
}

!llvm.ident = !{!0}
!nvvm.annotations = !{!1}

!0 = metadata !{metadata !"Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn)"}
!1 = metadata !{void (i64 addrspace(1)*, i64 addrspace(1)*, i64 addrspace(1)*)* @add, metadata !"kernel", i32 1}
{% endhighlight %}

### NVVM Annotations ###
The metadata node _nvvm.annotations_ explicitly marks the node as a
kernel node. This is done as the annontations is also used for global
variables etc. 

### Builtin Intrinsics ###
NVVM comes with a set of built in intrisics functions. The definition
of the threadIdx.x variable accessible inside CUDA kernels is
implemented as such and intrinsic. Its definition is showed in the
example above the add function. 

### Address Space Qualifiers ###
Like SPIR NVVM specifies address space qualifiers. The differ only
slightly from the OpenCL definition and is more tailored to the nVidia
GPU architecture.

Qualifier | Memory   | Comment                      | OpenCL equivalent
----------|----------|------------------------------|------------------
0         | generic  | TODO: dunno                  | generic? 
1         | global   | Global for the entire device | global
3         | shared   | Private to each work group   | local
4         | constant | Global for the entire device | constant
5         | local    | Private to each work item    | private


## Summary ## 

As the above discussion shows, SPIR and NVVM in the gist very
similar. They both define multiple address spaces, builtin
functionality and a way to distingush kernel functions.

## Support ##

Both these intermediate representations are inteded as compiler
targets for new programming languages. The NVVM is only supported by
nVidias drivers and can only be executed on nVidia GPUs. SPIR on the
other hand can potentialy execute on all platforms that execute
OpenCL. Unfortunalty at the time of writing a implementation on nVidia
is not available. But both Intel an AMD has support for SPIR.
