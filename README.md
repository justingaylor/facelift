# facelift

This gem will someday process Ruby code, automatically transforming expressions which are not idiomatic Ruby to functionally-equivalent, idiomatic expressions.

## Intro

Ruby provides us many ways to do the same thing. The intention of facelift is
to help you discover when your code could be expressed easier or more simply
using built-in methods or a common Ruby idioms.

## Current functionality

Since the project is in its infancy, only very simple transformations are supported. As a proof of concept, I've implemented transforming:

```
a + b
```
to:

```
b + a
```
This is, of course, a meaningless transformation and was only selected because it is simple. This is achieved by defining the following rule to capture this faux 'idiom':

Pattern:

```
{
  pattern:        "VAR1 + VAR2",
  transformation: "VAR2 + VAR1"
}
```

Next up, some real idioms for transformation!

## Next steps

The next project goal is to transform any occurrence of:

```
if !SOMETHING
  # Anything
end
```
or:

```
if not SOMETHING
  # Anything
end
```
to:

```
unless SOMETHING
  # Anything
end
```

After the above transformation can be done to arbitrary code, I'm thinking to tackle the following idiom:

```
if x == 1 || x = 3
  # Anything
end
```
to:

```
if [1, 3].include?(x)
  # Anything
end
```

This idiom was selected from [Susan Potter's Ruby Idioms, Part 1](http://geek.susanpotter.net/2007/01/ruby-idioms-part-1.html).

A bonus will be to match any number of `x == ?` expressions and generalize the idiom, though that will require being able to define some kind of `REPEAT_MATCHER` operator for the Pattern/Transformation rule, which doesn't seem trivial.

After the second problem is tackled, I'm hoping that patterns will start emerging and I can begin generalizing the transformation code. Then the next phase, expanding the library of idioms, will be possible.

## Running specs

The specs may be run by cloning the repo and executing:

```
bundle exec rspec
```

## Random ideas

This section is for recording random ideas related to the project:

### Ideas for specifying rules

- A match anything operator is needed to match closures whose implementation doesn't matter for the idiom we are pattern matching.
- It would be nice if we can specify that a pattern repeats so one idiom rule can be generalized.

### Ideas for options

- Some people don't like some idioms. They should be able to disable them somehow. Perhaps idioms could be grouped together in the library, or labeled somehow.
- Sometimes, single-line versions of idioms are possible. People should be able to enable or disable using the single-line versions. For example:

```
if [1,2,3].include?(x)
  puts "Hello one of the first 3 natural numbers!"
end
```

could be written in a single line as

```
puts "Hello one of the first 3 natural numbers!" if [1,2,3].include?(x)
```

- People should be able to prefer using `if !x` instead of `unless x` (or prefer the `unless x` variant).

### Ideas for optimizations

- It should be possible to implement the pattern-matching without recursion.
- It should also be possibly to implement pattern-matching efficiently using divide-and-conquer.
- At some point, when pattern-matching, it might help to parallelize. This could be achieved by allowing parallel parts to process non-overlapping segments of code (possibly by inspecting the line and column numbers in the Ripper output.)

