# arrayseparating

For an array stored several 1D points, the functions adjust the points in that array such that for any two adjacent points, the distance between them is greater than or equal to a sepcified value. The adjustment for the points in the array should be as small as possible.

+ `arrsepoptim.m`: the MATLAB file that separates the points in the input array using the optimization toolbox in MATLAB
+ `arrsep4m.m`: the MATLAB file that separates the points in the input array 
+ `arrsep.cpp`: C++ implementation of arrsep4m.m that can be compiled for MATLAB to call
+ `arrsep.m`: the file that describes the arrsep.cpp

# How to compute the adjustment
`I don't know whether or not there is any algorithm to do the same job. If yes, please tell me...`

Let the input array be $\bf{x}$ and the smallest distance between any two adjacent points is $g$. Denote the adjustment for $\bf{x}$ as $\bf{v}$, which we want the distance between any two points in the array after adjustment, i.e. $\bf{x}+\bf{v}$, is greater than $g$.

The adjustment is determined by the following optimization problem:

Assume that $\bf{x}$ is sorted in ascending order.

$$
\begin{matrix} 
minimize & \left \| \bf{v} \right \|^2 \\ 
s.t & \bf{A}\left (\bf{x} + \bf{v} \right ) \geq g\bf{1}
\end{matrix}
$$

where

$$\bf{A}=
\begin{bmatrix} -1 & 1  &         &        & \\
& -1 & 1       &        & \\
&    & \ddots  & \ddots & \\
&    &         & -1     & 1 \\
\end{bmatrix}
$$

and

$$
\bf{1}=
\begin{bmatrix}
1 \\
1 \\
\vdots \\
1
\end{bmatrix}
$$

The above optimization problem can be solved by using the optimization toolbox in MATLAB. The file `arrsepoptim.m` is using the built-in optimization toolbox in MATLAB to compute the result.

## Another method
Since solving the optimization problem is quite time-consuming, I came up with a method to solve the above problem. I haven't proved that the method can achieve the same result as the optimization problem yet. Maybe there are some errors in the functions.

To be continued...
