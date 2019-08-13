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

Given the following spreadsheet:
```
5 1 9 5
7 5 3
2 4 6 8
```

First row: 9 - 1 = 8
Second row: 7 - 3 = 4
Third row: 8 - 2 = 6
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
cksum xs = sum $ map rowCksum xs
```

------------

### A better solution
```haskell
findMinMax (x:xs) = foldr helper (x, x) xs
  where
    helper x (cmin, cmax) =
      let nmin = if x < cmin then x else cmin
          nmax = if x > cmax then x else cmax in
        (nmin, nmax)

rowCksum xs = rmax - rmin
  where
    (rmin, rmax) = findMinMax xs

cksum xs = sum $ map rowCksum xs
```

------------

## Semigroup

In mathematics, a semigroup is an algebraic structure consisting of a set together with an associative binary operation.


[1](https://en.wikipedia.org/wiki/Semigroup)

------------

```haskell
class Semigroup a where
  (<>) :: a -> a -> a
```

[1](https://hackage.haskell.org/package/base/docs/Data-Semigroup.html)


::: notes
Laws etc.
:::

------------

## Monoid

It is a semigroup with an identity element

[1](https://en.wikipedia.org/wiki/Monoid)

------------

```haskell
class Semigroup a => Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mappend = (<>)
```

[1](https://hackage.haskell.org/package/base/docs/Data-Semigroup.html)

------------

 * Min
 * Max
 * Sum
 * All
 * Any

------------

```haskell
data MinMax a = MinMax {
    myMin :: Min a
  , myMax :: Max a
  } deriving Show

```
. . .

#### Smashing the elements together
```haskell
instance Ord a => Semigroup (MinMax a) where
  a <> b = MinMax (myMin a <> myMin b) (myMax a <> myMax b)

```
. . .

```haskell
mkMinMax :: (Num a, Ord a) => a -> MinMax a
mkMinMax x = MinMax (Min x) (Max x)
```

------------

```haskell
calcDiff :: Num a => MinMax a -> a
calcDiff x = (getMax . myMax $ x) - (getMin . myMin $ x)
```
. . .

```haskell
rowCksum :: (Num a, Ord a) => [a] -> Maybe (Sum a)
rowCksum xs = fmap (Sum . calcDiff) res
  where
    res = foldMap (Just . mkMinMax) xs
```
. . .
```haskell
cksum :: (Num a, Ord a) => [[a]] -> Maybe a
cksum xs = fmap getSum $ foldMap (rowCksum) xs
```

------------

## Can we do better?
. . .

### We can reuse the `Semigrup` instance for pair `(,)`

```haskell
mkMinMax :: a -> (Maybe (Min a), Maybe (Max a))
mkMinMax x = (Just $ Min x, Just $ Max x)
```

------------

```haskell
calcDiff :: (Applicative f, Num a) => (f a, f a) -> f a
calcDiff x = (-) <$> (snd x) <*> (fst x)

rowCksum :: (Num a, Ord a) => [a] -> Maybe (Sum a)
rowCksum xs = fmap Sum $ calcDiff res'
  where
    res' = bimap (fmap getMin) (fmap getMax) res
    res = foldMap mkMinMax xs
```

------------

## Thank you

github.com/atopuzov

twitter.com/atopuzov
