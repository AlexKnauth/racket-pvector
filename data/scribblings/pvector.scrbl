#lang scribble/manual

@(require
   racket/require
   (for-label (subtract-in
               (combine-in
                racket/base)
               data/collection)
              data/collection
              racket/contract
              data/pvector)
   scribble/eval)

@(define pvector-evaluator
  (make-eval-factory
   #:lang 'racket
   '(data/collection
     data/pvector)))

@(define-syntax-rule (pvector-interaction . body)
   (interaction #:eval (pvector-evaluator) . body))

@(define-syntax-rule (pvector-examples . body)
   (examples #:eval (pvector-evaluator) . body))

@title{Persistent Vectors}

@defmodule[data/pvector]

This provides an implementation of @deftech[#:key "persistent vector"]{persistent, immutable vectors}.
They are implemented as 32-way bitmapped tries with a tail to provide truly constant time appends to
the end of the vector. Data is shared between a vector and its subsequent functional modifications.

The @tech{persistent vectors} provided by this module implement the @racket[gen:equal+hash] generic
interface, so they may be used as keys, and @racket[equal?] will perform deep comparisons.
Additionally, they implement three interfaces from @racketmodname[data/collection],
@racket[gen:countable], @racket[gen:collection], and @racket[gen:sequence], which contain the
interface for interacting with them.

@section{Example Usage}

@tech{Persistent vectors} may be created using the @racket[pvector] constructor.

@(pvector-interaction
  (pvector 1 2 3 4))

Afterwards, they can be interacted with via the functions from @racketmodname[data/collection].

@(pvector-interaction
  (conj (pvector 1 2 3 4) 5))

It is often useful to create an empty vector using @racket[(pvector)], then extending it with some
other sequence.

@(pvector-interaction
  (extend (pvector) (take 10 (in-naturals))))

@section{Native API Reference}

The interface provided by @racketmodname[data/pvector] is small. Most of the functions for
manipulating @tech{persistent vectors} reside in @racketmodname[data/collection]. However, some
functions are specific to persistent vectors.

@defproc[(pvector? [v any/c]) boolean?]{
Returns @racket[#t] if @racket[v] is a @tech{persistent vector}, otherwise returns @racket[#f].}

@defproc[(pvector [v any/c] ...) pvector?]{
Creates a new @tech{persistent vector} with the @racket[v] arguments as its contents. Calling this
function with multiple arguments simply performs @racket[extend] on the empty vector,
@racket[(pvector)], so it is no more efficient than using @racket[extend] directly.}

@section{Comprehensions}

@deftogether[(@defform[(for/pvector (for-clause ...) body-or-break ... body)]
              @defform[(for*/pvector (for-clause ...) body-or-break ... body)])]{
Equivalent to @racket[for/sequence] or @racket[for*/sequence] combined with
@racket[(extend (pvector) ...)] to collect the results into a persistent vector.}
