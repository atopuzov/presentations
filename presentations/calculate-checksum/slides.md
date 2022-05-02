---
title: Calculate checksum
author: Aleksandar Topuzović
theme: beige
---

Given an 2D array representing a spreadsheet calculate
the checksum of the spreadsheet. The checksum is calculated
by summing up the checksum of each row. Row checksum is the
difference between the largest and the smallest number.

------------

#### Given the following spreadsheet

```
5 1 9 5
7 5 3
2 4 6 8
```

We calculate the checksum

. . .

First row: 9 - 1 = 8

. . .

Second row: 7 - 3 = 4

. . .

Third row: 8 - 2 = 6

. . .

Checksum = 8 + 4 + 6 = 18

------------

### A simple solution

```haskell
rowCksum :: (Num a, Ord a) => [a] -> a
rowCksum xs = rmax - rmin
  where
    rmin = minimum xs
    rmax = maximum xs

cksum :: (Num a, Ord a) => [[a]] -> a
cksum = sum . map rowCksum
```

------------

#### Drawbacks

* We iterate twice trough the row
  * Once to find the minimum
  * and once to find the maximum

* No error handling
  * Does not handle empty rows
  * or an empty spreadsheet

------------

### A better solution

We implement our own min max finder using a fold

. . .

```haskell
findMinMax (x:xs) = foldr helper (x, x) xs
  where
    helper x (cmin, cmax) =
      let nmin = if x < cmin then x else cmin
          nmax = if x > cmax then x else cmax in
        (nmin, nmax)

rowCksum :: (Num a, Ord a) => [a] -> a
rowCksum xs = rmax - rmin
  where
    (rmin, rmax) = findMinMax xs

cksum :: (Num a, Ord a) => [[a]] -> a
cksum = sum . map rowCksum
```
------------

## But can we do better?

------------

## Semigroup

In mathematics, a semigroup is an algebraic structure consisting of a set together with an associative binary operation.

Laws

(A ⊕ B) ⊕ C = A ⊕ (B ⊕ C)

<small><https://en.wikipedia.org/wiki/Semigroup></small>

------------

## Semigroup in Haskell

Implemented as a typeclass

```haskell
class Semigroup a where
  (<>) :: a -> a -> a
```

Laws

```haskell
x <> (y <> z) = (x <> y) <> z
```

<small><https://hackage.haskell.org/package/base/docs/Data-Semigroup.html></small>


------------

## Monoid

It is a semigroup with an identity element

Laws

A ⊕ E = E ⊕ A = A

(A ⊕ B) ⊕ C = A ⊕ (B ⊕ C)

<small><https://en.wikipedia.org/wiki/Monoid></small>

------------

## Monoid in Haskell

```haskell
class Semigroup a => Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mappend = (<>)
```

Laws

```haskell
x <> mempty = x
mempty <> x = x
x <> (y <> z) = (x <> y) <> z
```

<small><https://hackage.haskell.org/package/base/docs/Data-Monoid.html></small>

------------

### Some of the monoids available in base

Num monoids

 * Min
 * Max
 * Sum
 * Product

Bool monoids

 * All
 * Any

------------

### Let's build our own semigroup

We can reuse `Min`, `Max` and `Sum`

```haskell
newtype Min a = Min { getMin :: a }
newtype Max a = Max { getMax :: a }
newtype Sum a = Sum { getSum :: a }
```

. . .

We define our data type

```haskell
data MinMax a = MinMax {
    myMin :: Min a
  , myMax :: Max a
  } deriving Show

```
------------

#### We define how we smash the elements together

```haskell
instance Ord a => Semigroup (MinMax a) where
  a <> b = MinMax (myMin a <> myMin b) (myMax a <> myMax b)
```

. . .

#### And a function that lifts normal types into our special type

```haskell
mkMinMax :: (Num a, Ord a) => a -> MinMax a
mkMinMax x = MinMax (Min x) (Max x)
```

------------

#### We calculate the difference

```haskell
calcDiff :: Num a => MinMax a -> a
calcDiff x = (getMax . myMax $ x) - (getMin . myMin $ x)
```

. . .

#### And checksum for each row

```haskell
rowCksum :: (Num a, Ord a) => [a] -> Maybe (Sum a)
rowCksum xs = fmap (Sum . calcDiff) res
  where
    res = foldMap (Just . mkMinMax) xs
```

------------

#### And for the entire spreadsheet

```haskell
cksum :: (Num a, Ord a) => [[a]] -> Maybe a
cksum xs = fmap getSum $ foldMap (rowCksum) xs
```

------------

## Results

We iterate trough the row only once and combine the elements of the row by using the custom monoid.

For the row checksum we use the Sum monoid which we combine with other rows to obtain the spreadsheet checksum.

. . .

We wrap our semigroup in a Maybe to obtain a monoid.

It makes the handling of empty rows/spreadsheets trivial.


------------

## But can we do better?


------------

### We can reuse the Semigrup instance for pair (,)

#### We need a new lift function

```haskell
mkMinMax :: a -> (Maybe (Min a), Maybe (Max a))
mkMinMax x = (Just $ Min x, Just $ Max x)
```

------------

#### Checksum calculation remains similar

```haskell
calcDiff :: (Applicative f, Num a) => (f a, f a) -> f a
calcDiff x = (-) <$> (snd x) <*> (fst x)

rowCksum :: (Num a, Ord a) => [a] -> Maybe (Sum a)
rowCksum xs = fmap Sum $ calcDiff res'
  where
    res' = bimap (fmap getMin) (fmap getMax) res
    res = foldMap mkMinMax xs

cksum :: (Num a, Ord a) => [[a]] -> Maybe a
cksum xs = fmap getSum $ foldMap (rowCksum) xs
```

------------

[Repository with code](https://github.com/atopuzov/haskellstuff/tree/master/calcchecksum)

[Algebra cheatsheet](https://argumatronic.com/posts/2019-06-21-algebra-cheatsheet.html)

------------

## Questions?

------------

## Thank you!

github.com/atopuzov

twitter.com/atopuzov
