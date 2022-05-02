---
title: Advanced code presentation with reveal.js
author: Aleksandar Topuzovic
css:
 - css/tomorrow-night.css
 - css/tweaks.css
---

# Using highlight.js

::: notes

https://highlightjs.org/static/demo/

:::

## Requirements

1. --no-highlight
2. Custom template to include hljs
3. css for the highlight theme
4. hljs and lng-* on code

# Markdown code blocks

---

Quicksort in haskell

~~~ {#quicksort .lang-haskell}
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
~~~

<small>Using fenced code blocks ~~~</small>

---

Quicksort in haskell

```{.lang-haskell}
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
```

<small>Using fenced code blocks ```</small>

---

# Html pre/code blocks

---

Quicksort in haskell

<pre class="lang-haskell">
<code data-line-numbers data-trim data-noescape>
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
</code></pre>

<small>Line numbers</small>

::: notes

Pandoc adds classes to pre insted of code
https://github.com/jgm/pandoc/issues/3858

:::

---

Quicksort in haskell

[Function signature]{.fragment .fade-in fragment-index=1}

<pre class="lang-haskell">
<code data-line-numbers="1" data-trim data-noescape>
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
</code></pre>

<small>Line highlighting</small>

---

Quicksort in haskell

[Function body]{.fragment .fade-in fragment-index=1}

<pre class="lang-haskell">
<code data-line-numbers="2-4" data-trim data-noescape>
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
</code></pre>

<small>Multiple line highlighting</small>

---

# Html + custom css

---

Quicksort in haskell

<pre class="lang-haskell">
<code data-line-numbers data-trim data-noescape>
<span class="fragment fade-in-then-semi-out" data-fragment-index="1">qsort :: Ord a => [a] -> [a]</span>
<span class="fragment fade-in-then-semi-out" data-fragment-index="2">qsort []     = []</span>
<span class="fragment fade-in" data-fragment-index="3">qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++</span>
<span class="fragment fade-in" data-fragment-index="3">               qsort (filter (>= x) xs)</span>
</code></pre>

[Function signature]{.fragment .step-fade-in-then-out fragment-index=1}

[Base case]{.fragment .step-fade-in-then-out fragment-index=2}

[Recursive case]{.fragment .step-fade-in fragment-index=3}

::: notes

Had to wrap the 4th line in fragment with the same index as the 3rd line otherwise it's always displayed
For replacing the fragment used the code from:
https://github.com/hakimel/reveal.js/issues/745#issuecomment-422507012

:::

---

# Thanks!
