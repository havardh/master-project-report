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
optimizations on the IR, and translate the IR to and assembly
language. The LLVM project defines its own IR called LLVM IR. This has
proven to be a powerfull representation and is therefore used as the
basis for both nVidias NVVM and OpenCLs SPIR.

## LLVM IR ##
