# arrayseparating

For an array with several 1D points, the functions adjust the points in that array such that for any two adjacent points, the distance between them is greater than or equal to a specified value. The adjustment for the points in the array should be as small as possible.

- `arrsepoptim.m`: the MATLAB file that separates the points in the input array using the optimization toolbox in MATLAB
- `arrsep4m.m`: the MATLAB file that separates the points in the input array using the method introduced below
- `arrsep.cpp`: C++ implementation of arrsep4m.m that can be compiled for MATLAB to call
- `arrsep.m`: the file that describes the arrsep.cpp

# How to compute the adjustment

Let the input array be $\bf{x}$ sorted in ascending order and the smallest distance between any two adjacent points is $*\delta*$. Denote the adjustment for $\bf{x}$ as $\bf{a}$, which we want the distance between any two points in the array after adjustment, i.e. $\bf{x}+\bf{a}$, is greater than $*\delta*$.

Assume that $\bf{x}\in\R^n$ . The adjustment is determined by the following optimization problem:

$$
\begin{matrix} 
minimize & \left \| \bf{a} \right \|^2 \\ 
s.t & \bf{D}\left (\bf{x} + \bf{a} \right ) \geq \delta\bf{1}
\end{matrix}
$$

where

$$
\bf{D}=
\begin{bmatrix} -1 & 1  &         &        & \\
& -1 & 1       &        & \\
&    & \ddots  & \ddots & \\
&    &         & -1     & 1 \\
\end{bmatrix}
$$

is an $(n-1)\times n$ submatrix formed by that last $n-1$ rows of the difference matrix and

$$
\bf{1}=
\begin{bmatrix}
1 \\
1 \\
\vdots \\
1
\end{bmatrix}\in R^{n-1}
$$

The above optimization problem can be solved by using the optimization toolbox in MATLAB. The file `arrsepoptim.m` is using the built-in optimization toolbox in MATLAB to compute the adjustment $\bf{a}$.

# Algorithm

Solving the above optimization problem using the built-in optimization toolbox in MATLAB is quite time-consuming.

## Pseudo-code

Let `points` be the array of points.

```jsx
let arr = empty array
let minimal_distance = user's input

for point in points do
	// insert point into arr in the position that keeps arr sorted in ascending order
	insertion(arr, point)

	let res = find_too_close_points(arr)
	while res is not "not found" do
		let n_l = count_left_points(arr, idx1)
		let n_r = count_right_points(arr, idx2)

		let distance_need_to_adjust = minimal_distance - (x2 - x1)
		let push_l = n_r / (n_l + n_r) * distance_need_to_adjust
		let push_r = n_l / (n_l + n_r) * distance_need_to_adjust

		for i (0 to n_l) do
			let arr[idx1-i] = arr[idx1-i] - push_l 
		end for

		for i (0 to n_r) do
			let arr[idx2+i] = arr[idx2+i] + push_r 
		end for

		let res = find_too_close_points(arr)
end for

func insertion(arr, x){
	for idx (0 to (length of arr)) do
		if arr[idx] >= x do
			return idx
	end for
}

func find_too_close_points(arr){
	// find two adjacent points x1 and x2 in arr with x1 <= x2 such that x2-x1 < minimal_distance
	let idx1 = 0
	for idx (0 to (length of arr) - 1) do
		if arr[idx+1] - arr[idx] < minimal_distance do
			break
		end if
	end for

	let x1 = arr[idx]
	let x2 = arr[idx+1]

	if found do
		let idx1 = index of x1 in arr
		let idx2 = index of x2 in arr
		return idx1 and idx2
	else do
		return "not found"
	end if
}

func count_left_points(arr, idx1){
	let n = 1
	for idx (idx1 to 1) do
		if arr[idx] - arr[idx-1] < minimal_distance do
			let n = n + 1
		else do
			break
		end if
	end for
	return n
}

func count_right_points(arr, idx2){
	let n = 1
	for idx (idx2 to (length of arr) - 1) do
		if arr[idx+1] - arr[idx] < minimal_distance do
			let n = n + 1
		else do
			break
		end if
	end for
	return n
}
```

## Explanation

Firstly, we can use Cauchy–Schwarz inequality to find the minimal adjustment. Consider the following two cases:

1. $x=[1, 2]$ and $\delta=2$:
Before:
    
    ```jsx
               x_1   x_2
    ------------X-----X--------->
          0     1     2     3
    ```
    
    Let the adjustment for $x_1$ and $x_2$ are $a_1$ and $a_2$, respectively. Clearly, we need to minimize $a_1^2+a_2^2$ while satisfying $(x_2+a_2)-(x_1+a_1)=\delta$.
    
    The total adjustment is $a_1^2+a_2^2$. Then, by Cauchy–Schwarz inequality,
    
    $$
    (a_1^2+a_2^2)((-1)^2+1^2)\geq(-a_1+a_2)^2=(\delta-(x_2-x_1))^2
    $$
    
    The equality holds when $-a_1=a_2$.
    
    Hence, the adjustment $a_2=-a_1=\frac{1}{2}(\delta-(x_2-x_1))$, which implies that the shifted distance for both points are equal.
    
    After:
    
    ```jsx
            x_1         x_2
    ---------X-----------X------>
          0     1     2     3
             ^           ^
            0.5         2.5
    ```
    
2. $x=[0, 2, 3]$ and $\delta=2$:
Before:
    
    ```jsx
         x_1         x_2   x_3
    ------X-----------X-----X-------->
          0     1     2     3
    ```
    
    Let the adjustment for $x_1$, $x_2$, and $x_3$ are $a_1$, $a_2$, and $a_3$, respectively. In this case, we see that $x_2-x_1=\delta$, which implies that we should move $x_1$ and $x_2$ together, i.e., $a_1=a_2$. The constraint needed to be satisfied is $(x_3+a_3)-(x_2+a_2)=\delta$.
    
    The total adjustment is $a_1^2+a_2^2+a_3^2=2a_2^2+a_3^2$. Then, by Cauchy–Schwarz inequality,
    
    $$
    (2a_2^2+a_3^2)\left(\left(-\frac{1}{\sqrt{2}}\right)^2+1^2\right)\geq(-a_2+a_3)^2=(\delta-(x_3-x_2))^2
    $$
    
    The equality holds when $-2a_2=a_3$.
    
    Hence, the adjustments
    
    $$
    \begin{align*}
    a_2 &= -\frac{1}{3}\left(\delta-(x_3-x_2)\right) \\
    a_3 &= \frac{2}{3}\left(\delta-(x_3-x_2)\right)
    \end{align*},
    $$
    
    which implies that the shifted distances are weighted.
    
    After:
    
    ```jsx
       x_1         x_2        x_3
    ----X-----------X----------X----->
          0     1     2     3
        ^           ^          ^
      -0.33        1.67        3.67
    ```
    

---

Secondly, the problem is a convex optimization problem with a inequality constraint.

The Lagrangian

$$
L(\bf{a},\bf{\lambda})=\left \| \bf{a} \right \|^2 + \bf{\lambda}^T \left(\delta\bf{1}-
 \bf{D}\left (\bf{x} + \bf{a} \right )\right)

$$

The Karush-Kuhn-Tucker (KKT) conditions:

1. primal feasibility: $\bf{D}\left (\bf{x} + \bf{a} \right ) \geq \delta\bf{1}$
2. dual feasibility: $\bf{\lambda}\geq0$
3. complementary slackness: $\lambda_i \left(\delta\bf{1}-
 \bf{D}\left (\bf{x} + \bf{a} \right )\right)_i=0,\quad i=1, 2, ..., n-1$
4. $\nabla L(\bf{a}, \lambda)=0$

The strong duality holds when the inequality constraints are convex, the equality constraints are affine, and the $\bf{a}$ and $(\lambda, \nu)$ satisfy the KKT conditions.

---

From the KKT conditions, we have

$$
\nabla L(\mathbf{a}, \lambda)=2\mathbf{a}^T-\mathbf{D}^T\mathbf{\lambda}=0
$$

and

$$
\begin{matrix} 
a_1 &=& -\frac{1}{2}\lambda_1 \\
a_2 &=& \frac{1}{2}(\lambda_1-\lambda_2) \\
a_3 &=& \frac{1}{2}(\lambda_2-\lambda_3) \\
\vdots && \vdots \\
a_i &=& \frac{1}{2}(\lambda_{i-1}-\lambda_i) \\
\vdots && \vdots \\
a_{n-1} &=& \frac{1}{2}(\lambda_{n-2}-\lambda_{n-1}) \\
a_n &=& \frac{1}{2}\lambda_{n-1}
\end{matrix}.
$$

By the above equations, we can let $\lambda_i$ be the distance that we want the i-th gap to grow. Note that it is not the true or final distance that the gap grows. For example, to enlarge the first gap (between $x_1$ and $x_2$) by $\lambda_1$, the adjustment for $x_1$ and $x_2$ are $-\frac{1}{2}\lambda_1$ and $\frac{1}{2}\lambda_1$, respectively. Also, in order to enlarge the second gap (between $x_2$ and $x_3$) by $\lambda_2$, the adjustment for $x_2$ is $-\frac{1}{2}\lambda_2$, that is why we have $a_2 = \frac{1}{2}(\lambda_1-\lambda_2)$.

Then, we have the following conditions of complementary slackness:

$$
\begin{matrix} 
\lambda_1\left(\delta-(x_2-x_1)-(a_2-a_1) \right) &=& 0\\
\lambda_2\left(\delta-(x_3-x_2)-(a_3-a_2) \right) &=& 0\\
\lambda_3\left(\delta-(x_4-x_3)-(a_4-a_3) \right) &=& 0\\
\vdots && \vdots\\
\lambda_i\left(\delta-(x_{i+1}-x_i)-(a_{i+1}-a_i) \right) &=& 0\\
\vdots && \vdots\\
\lambda_{n-2}\left(\delta-(x_{n-1}-x_{n-2})-(a_{n-1}-a_{n-2}) \right) &=& 0\\
\lambda_{n-1}\left(\delta-(x_{n}-x_{n-1})-(a_{n}-a_{n-1}) \right) &=& 0\\\end{matrix}\ .
$$

Therefore, we can either enlarge the i-th gap by $\lambda_i$ and make sure the resulting gap is $0$, or do not enlarge the i-th gap ($\lambda_i=0$).