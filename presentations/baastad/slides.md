---
title: Monads for functional programming (paper by Philip Wadler)
author: Aleksandar Topuzovic
css:
 - css/tomorrow-night.css
 - css/tweaks.css
---

WORK IN PROGRESS

---

[Paper](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf)

---

```
data Term = Con Int
  | Div Term Term deriving Show

answer, error :: Term
answer = (Div (Div (Con 1972 ) (Con 2 )) (Con 23 ))
error = (Div (Con 1 ) (Con 0 ))
```

---

```
eval :: Term -> Int
eval (Con a)   = a
eval (Div t u) = (eval t) `div` (eval u)
```

---

# Exceptions

```
data M a = Raise Exception
  | Return a deriving Show

type Exception = String
```


```
eval (Con a) = Return a
eval (Div t u) =
  case eval t of
    Raise e -> Raise e
    Return a ->
      case eval u of
        Raise e -> Raise e
        Return b ->
          if b == 0
          then Raise "divide by zero"
          else Return (a `div` b)
```

---

```
ifOk :: M a -> (a -> M b) -> M b
ifOk op k = case op of
  Raise e -> Raise e
  Return a -> k a
```

```
safeDiv a 0 = Raise "divide by zero"
safeDiv a b = Return $ a `div` b
```

---

```
eval (Con a) = Return a
eval (Div t u) =
  eval t `ifOk` \a ->
  eval u `ifOk` \b ->
  safeDiv a b

```

---

# State

count the number of division performed during evaluation


```
type M a = State -> (a, State)
type State = Int

```

Vale of type M a is a function that accepts the initial state and returns the computed value paied with the final state

```
eval (Con a) x = (a, x)
eval (Div t u) x =
  let (a, y) = eval t x
      (b, z) = eval u y in
    (a `div` b, z + 1)

```

---

```
andThen op k = \x ->
  let (a, y) = op x
      (b, z) = (k a) y
  in (b, z)
```

A few other helper functions

```
returnState x = \s -> (x, s)
getState = \s -> (s, s)
putState s = \_ -> ((), s)
```

---

```
eval (Con a)   = returnState a
eval (Div t u) =
  eval t         `andThen` \a ->
  eval u         `andThen` \b ->
  getState       `andThen` \z ->
  putState (z+1) `andThen` \_ ->
  returnState (a `div` b)
```

---

# Output

```
type M a = (Output, a)

type Output = String

```

```
eval (Con a) = (line (Con a) a, a)
eval (Div t u) =
  let (x, a) = eval t
      (y, b) = eval u in
    (x ++ y ++ line (Div t u) (a `div` b), a `div` b)
```

And display it in the reverse order

```
(line (Div t u) (a `div` b) ++ y + x, a `div` b)
```

---

```
withLog op k =
  let (x, a) = op
      (y, b) = k a
  in (x ++ y, b)

```

```
returnLog x = ("", x)
printLine s = (s, ())
```

---


---

```
eval (Con a) =
  printLine (line (Con a) a)             `withLog` \_ ->
  returnLog a

eval (Div t u) =
  eval t                                 `withLog` \a ->
  eval u                                 `withLog` \b ->
  printLine (line (Div t u) (a `div` b)) `withLog` \_ ->
  returnLog $ a `div` b
```

---


```
ifOk    :: M a -> (a -> M b) -> M b
andThen :: M a -> (a -> M b) -> M b
withLog :: M a -> (a -> M b) -> M b

```

```
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```

---

```
class Applicative m => Monad m where
    -- | Sequentially compose two actions, passing any value produced
    -- by the first as an argument to the second.
    (>>=) :: forall a b. m a -> (a -> m b) -> m b

    -- | Inject a value into the monadic type.
    return      :: a -> m a
    return      = pure

```

---

## Questions?

---

## Thank you!

github.com/atopuzov

twitter.com/atopuzov
