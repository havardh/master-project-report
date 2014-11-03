---
layout: page
title: Implementation
permalink: /report/implementation/
order: 5
---

# Introduction #

This chapter describes the implementation of the GPU support for Julia
presented in this report.  The implementation consists of two parts,
the generation of OpenCL compliant functions based on Julia code and
the translation of these functions to code executable on a Nvidia
GPU. The first part is realizes as a part of the __Julia
compiler__. As the compiler utilizes LLVM the steps are implemented as
LLVM compiler passes. The second part is implemented as a device
backend on the portable OpenCL compiler __pocl__. The OpenCL.jl
library is used as a glue between these two components. 

## OpenCL compliant Julia code ##

## A Nvidia backend for pocl ##

