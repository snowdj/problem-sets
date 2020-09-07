---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.5.0
  kernelspec:
    display_name: Julia 1.5.1
    language: julia
    name: julia-1.5
---

<!-- #region Collapsed="false" -->
## Linear Algebra Practice

#### *14 September 2020*
#### *DATA 1010*

Today we'll do some linear algebra review. The pre-class preparation assignment is to watch the [linear algebra review video](https://www.youtube.com/watch?v=pz0WmaOU9Xg). Note that this video is very fast-paced, so you should prepare to use the pause button extensively. It's probably also worthwhile to have a tab open to the [course cheatsheet](https://data1010.github.io/docs/cheatsheets/data1010-cheatsheet.pdf) so you can reference the green linear algebra panels.
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 1** 

Consider a three-column spreadsheet of numerical data, with each entry in the third column computed to be the sum of the corresponding entries in the first two columns. Find a basis for the span of the three columns (assuming the first two columns are not multiples of one another), and find the coefficients all three columns with respect to this basis.

| col1 | col2 | col3 |
| -----:| -----:| -----:|
| $0.7$ | $1.0$ | $1.7$ |
| $1.3$ | $0.6$ | $1.9$ |
| $0.4$ | $1.3$ | $1.7$ |
| $1.4$ | $1.3$ | $2.7$ |
| $0.7$ | $1.3$ | $2.0$ |
| $0.7$ | $0.3$ | $1.0$ |
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#worksheet  
*Solution*. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#solution  
*Solution*. The first two columns form a basis of the space spanned by all three columns. The coordinates of col1 are $[1,0]$. The coordinates of col2 are $[0,1]$. The coordinates of the third column are $[1,1]$. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 2** 

Find the rank of the linear transformation $L$ which maps each vector $[x,y]$ to the closest point $[a,2a]$ on the line $y = 2x$. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#worksheet  
*Solution*. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#solution  
*Solution*. The rank of a linear transformation is the dimension of its range. The range of $L$ is the line $y = 2x$. The dimension of a vector space is the number of vectors in any basis of that space. A line is spanned by (a set containing) one vector, so its dimension is 1. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 3** 

Suppose that $V$ and $W$ are subspaces of $\mathbb{R}^{3}$ and that $V$ has dimension 1 and $W$ has dimension 1. What are the possible values of the dimension of $V \cap W$? What if $V$ and $W$ each have dimension 2?

Suppose that $V$ and $W$ are subspaces of $\mathbb{R}^{10}$ and that $V$ has dimension 4 and $W$ has dimension 8. What are the possible values of the dimension of $V \cap W$?
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#worksheet  
*Solution*. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#solution  
*Solution*. Two one-dimensional spaces can intersect in a space of dimension 0 or 1. Two 2-dimensional spaces can intersect in a space of dimension 1 or 2.

The intersection can't have dimension larger than 4. It can have dimension 2, 3, or 4, by taking a basis of $\mathbb{R}^{10}$ and defining $V$ to be the span of the first four vectors and $W$ to be the span of the first 8, or 2 through 9, or 3 through 10. 

The dimension can't be smaller than 2, because if we apply the multiple extension principle assuming the intersection has dimension $d$, we find that $d + (8-d) + (4-d) \leq 10$. Therefore $d \geq 2$. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 4** 

In Julia, a set of 5 column vectors in $\mathbb{R}^7$ with entries selected uniformly at random from $[0,1]$ may be generated using `rand(7,5)`. The dimension of the span of the columns of a matrix may then by computed using the function `rank`. What can you say about the rank of such a matrix?
<!-- #endregion -->

```julia Collapsed="false"
using LinearAlgebra, StatsBase
Set([rank(rand(0:1,7,5)) for _ in 1:100_000]) #solution
```

<!-- #region Collapsed="false" -->
Next, try `rand(0:1,7,5)` in place of `rand(7,5)`. This generates random matrices whose entries are independent random elements of $\{0,1\}$. Try using the `countmap` function from `StatsBase`, which tallies the entries of an array.
<!-- #endregion -->

```julia Collapsed="false"

```

```julia Collapsed="false"
#solution
countmap([rank(rand(0:1,7,5)) for _ in 1:100_000])
```

<!-- #region Collapsed="false" -->
---

##### **Problem 5** 

The vectors $[1,1,\sqrt{2}]$, $[1,1,-\sqrt{2}]$, $[1,-1,0]$ meet at right angles at the origin (like the standard basis vectors in $\mathbb{R}^3$). 

(a) Find the coordinates of the vector $[4,4,0]$ with respect to this basis. 

(b) Find the coordinates of $[3, -2, 7]$ with respect to this basis.
<!-- #endregion -->

```julia Collapsed="false"
B = [[1,1,√(2)],[1,1,-√(2)],[1,-1,0]]
[u ⋅ [4, 4, 0] / norm(u)^2 for u in B] #solution
```

```julia Collapsed="false"
#solution
[u ⋅ [3, -2, 7] / norm(u)^2 for u in B]
```

<!-- #region Collapsed="false" -->
#solution  
Here's a solution involving directly solving the linear system:
<!-- #endregion -->

```julia Collapsed="false"
A = [1     1    1
     1     1   -1
     √(2) -√(2) 0]
A \ [3, -2, 7]
```

<!-- #region Collapsed="false" -->
---

##### **Problem 6**

Show that for any $m\times n$ matrix $A$, the matrices $A'A$ and $A$ have the same null space and therefore also the same rank.
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#worksheet  
*Solution*. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#solution  
*Solution*. If $A x = 0$, then $A'(Ax) = A'0 = 0$. 

If $A'A x = 0$, then $x'A'A x = 0$, which implies that $(Ax)'(Ax) = 0$. This implies that $(Ax) \cdot (Ax) = 0$. Therefore $Ax = 0$. 

This shows that the nullspace of $A'A$ and $A$ are the same. By the rank-nullity theorem, this implies that their ranks are also equal. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 7**

The orthogonal complement of the span of the columns of a matrix $A$ is equal to the [   ] of [   ]. Fill in the first blank with "range" or "null space" and the second with $A$ or $A'$. Explain.
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#worksheet
*Solution*. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
#solution
*Solution*. The correct answers are "null space" and "$A'$". To see this, note that the matrix product formula implies that $A'x = 0$ if and only if $x$ is orthogonal to every row of $A'$. Since $A'$'s rows are the columns of $A$, this shows that the vectors orthogonal to all of the columns of $A$ are the vectors in the null space of $A'$. 
<!-- #endregion -->

<!-- #region Collapsed="false" -->
---

##### **Problem 8**

The *normal equation* specifies the vector $x$ which makes $A\mathbf{x}$ as close as possible to a given matrix $\mathbf{b}$. It says that the minimizing vector $\mathbf{x}$ is given by $\mathbf{x} = (A'A)^{-1}A'\mathbf{b}$. This formula assumes that the columns of $A$ are linearly independent.

Use the code below to build a random 100 × 6 matrix whose first five columns are linearly dependent and whose sixth column is not in the span of the first five. Use the normal equation to try to solve for the weights of the linear combination of the first five columns which gets closest to the sixth column. Does anything break in the code? What should you bear in mind when interpreting the results?

Note: `A \ b` finds the vector `x` which minimizes $|A\mathbf{x} - \mathbf{b}|^2$ if $A$ is non-square, and it solves the equation $A\mathbf{x} = \mathbf{b}$ if $A$ is square.  
<!-- #endregion -->

```julia Collapsed="false"
M = rand(0:2, 100, 6)
M[:,5] = M[:,4] + M[:,3];
```

<!-- #region Collapsed="false" -->
*Solution*.

<!-- #endregion -->
