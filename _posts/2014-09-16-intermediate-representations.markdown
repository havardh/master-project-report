---
layout: post
title: "Intermediate Representations"
date:  2014-09-16 18:03:00
categories: ir llvm spir nvvm ptx
---

# Intermediate Representations #

Intermediate Representations, IRs, are a way to express a computer
program that does not provide the convinience of a programming
language and not the implementation details of a assembly
language. The purpose of an IR is to be a representation on which the
compiler performs optimizations on. A common structure for a compiler
is to translate the programming language into an IR, perform
optimizations on the IR, and translate the IR to an assembly
language. The LLVM project defines its own IR called LLVM IR. This has
proven to be a powerfull representation and is therefore used as the
basis for both nVidias NVVM and OpenCLs SPIR. In this post I will
describe the intermediate representations I consider when tackling my
project. 


## LLVM IR ##

LLVM IR is the LLVM compiler infrastructures intermediate
representation. It servers as the basis for the other representations
described in this post. The IR is specified in the (LLVM Language
Reference Manual)[http://llvm.org/docs/LangRef.html]. In short terms
the an LLVM IR is build up of a collection of modules which contains
functions, variables and symbol table entries.

The representation have three equivalent forms, in-memory, bit-code (.bc)
and humanreadable (.ll). The follwing add function written in C is
translated to the @add function in the next listing. Note this is not
the simples implementation of a add function and therefore the llvm ir
is a bit hairy, but its left so to compare with the next two sections.

{% include programs/add.c %}

The same function after running
`clang -S -emit-llvm -c add.c -o add.ll`

{% include programs/add.ll %}


## SPIR ##

SPIR, (The Standard Portable Intermediate Representation for Device
Programs)[http://www.khronos.org/registry/spir/specs/spir_spec-2.0.pdf],
is a standard by the Khronos Group. It aims to create a portable and
interchangeable representation of partly compiler OpenCL C programs
based on LLVM IR. A secondary target is to be an alternative to OpenCL
C as a input to OpenCL compilers. This will ensure that it is easier
to target OpenCL from a compilers perspective, expesially those
written on LLVM. The changes made to the LLVM IR to obtain SPIR is to
add new targets, and defining calling conventions for calling OpenCL
function and kernels.

{% include programs/add.cl %}

The same function after running
`clang -S -x cl -fno-builtin -target spir -emit-llvm -c add.cl -o add.spir`

{% include programs/add.spir %}


## NVVM ##

NVVM is nVidias intermediate representation used in the its LLVM based
compiler for CUDA. It does as SPIR represent device kernels that are
intended to be executed on a GPU solely. NVVM ads to LLVM IR a set of
intrinsic functions for controlling the GPU. Among these are barriers,
address space conversions, special register accessors. The NVVM Cuda
Compiler compiles NVVM IR into PTX which is loaded into a 
