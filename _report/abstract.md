---
layout: page
title: Abstract
permalink: /report/abstract/
order: 1
---
The race for better graphics performance has led to sophisticated
processor designes targeting the parallell behaviour of computer
graphics. These processing unit called Graphical Processing Units have
been subject to a lot of funding and therefore research causing an
accellerated development of high performance specialized systems. This
accompanied by the development of software components like CUDA and
OpenCL, have exposed these systems to the HPC community in so-called
GPGPU, General-purpose computing on graphics processing units. These
libraries exposes low level APIs and require the applications to be
designed in languages like C/C++.

In the realm of technical computing a lot of applications are
prototyped in high-level languages like Python, Matlab, R and
Mathematica. These languages enables high productivity but suffers
from low performance due to poor interpreting/compilation
processes. The prototypes must then be reimplemented in languages that
target performance but not productivity. After the introduction of the
LLVM compiler infrastructure new languages that target both these
concernes have been made possible.

This paper explores the state of the art in joining these two
efforts. It describes an effort to make the GPU programmable from a
high level language. The language chosen is the Julia programming
language that targets technical computing, built on the LLVM
infrastructure.
