---
layout: page
title: Introduction
permalink: /report/introduction/
order: 2
---

This report describes the state of the art in programming a
hetreogeneous system.

# Tackling a GPU efficiently in a modern language #

Writing efficient code has been in the domain of low level, static
languages for decades.  With the recent developments in dynamic
languages through the LLVM compiler infrastructure this truth has been
challanged. Comparable perforamance has been achived while retaining
the expressive powers of a dynamic language. In this report I explore
these new powers in the context of a heterogeneous computer system.

## Heterogeneous Computing ##

### Architectures ###

Heterogeneous Computing referes to computing on a computer system that
consisits of accelerators that are specialized for certain tasks. The
most well known accelerator is the GPU which consists of a large
number of simple computing cores and can compute SPMD programs highly
efficient. A different example is the ARM big.LITTLE
architecture. This architecure combines two differnet core types, one
small (low power) and one big (high performance) into one chip.

### Programming environments ###

Programming a hetrogeneous system is more complex than programming a
homogeneous system. Primarly the memory hierarchy has to be taken into
account as bandwidth is one of the largest limiting factor when it
comes to performance. Secondly the abstraction we are used to when
programming a CPU does not always translate into efficient code on a
different architecture. This complexity has to be dealt with by the
programmer. In current solution these are made accesible through
software libraries and low-level languages subsets, mostly based on
C/C++.

#### OpenCL ####

OpenCL, Open Computing Language, is a open standard for parallel
programming of hetrogeneous systems. OpenCL runs on all three major OS
(Linux, OS X and Windows) and is supported by numerous architectures
including products from nVidia, AMD and ARM.

#### CUDA ####

CUDA, Compute Unified Device Architecture, referes to both a parallel
computing platform and a programming model. It is used by nVidia on
its line of GPUs. Although part of the software constituting the CUDA
framework has been open sourced this model is solely supported by
nVidia.

#### DirectCompute ####

DirectCompute is Microsofts API to support GPGPU programming. It is
included in DirectX API collection. It runs solely on Microsoft
platforms such as Windows and Xbox.

#### C++ AMP ####

The C++ extension Accelerated Massive Parallelism by Microsoft is a
abstract layer over DirectX. This makes the implementation Platform
dependent, but Microsoft has released the specification of C++ AMP and
Intel has made an proof of concept platform independent
implementation. This implementation is unfortunely not released.

## Language Implementation ##

### The old fashion ###

The current way of writing efficient code for a GPU is to use a low
level language like C, write kernels in a subset of the language and
compiling them with a separate compiler in the case of CUDA and by
linking to a library for OpenCL.

### Hybrid approach ###

Some recent projects [PyOpenCL, JuliaGPU] strives to provide support
for executing kernels from within a high level dynamic language. This
is done by wrapping the low level C libraries in the high level
languages, then the kernels are passed to the underlying libraries
within string variables. The kernels are compiled by a separated
compilation step and library routines are called from the high level
language to execute the kernels on the hardware.

### The proposed approach ###

The method explored in this report is to write both the kernels and the
dispatching calls in a high level language. This approach is similar
to the one used in the numba python compiler.

## The Julia programming language. ##

The Julia [http://arxiv.org/abs/1209.5145] language is a dynamic
programming language for technical computing, built on LLVM. It
provides a high level abstraction with comparable performance to low
level languages like C and C++. One of the main goals of the language
is to provide high level abstractions but also enabling the programmer
to dive into low level optimization without having to resort to a
low-level language. This makes Julia stand aside from languages like
Matlab, Python or R, where you will have to go into C in order to peal
away the abstractions. 

{% highlight julia %}
a = b + c
{% endhighlight %}

JuliaGPU


## The LLVM Compiler Infrastructure ##

The LLVM compiler infrastructure provides a robust basis on which
compilers for both dynamic and static programming languages can be
implemented. This infrastructure consists of an intermediate
representation, a number of compiler optimization passes and code
generation for numerous targets. All of this sums up into a good
foundation to target inorder to get great performance on a lot of
platforms for the language in question. It also promotes code sharing
between different communities as improvements done to the
infrastructure is usually upstreamed back to the LLVM repository, so
all users of project can benefit.
