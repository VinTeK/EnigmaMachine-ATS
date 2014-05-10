(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

infix (mod) %
#define % (x, d) (x mod d)

(* ****** ****** *)
//
#include
"share/HATS/atslib_staload_libc.hats"
#include
"share/HATS/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)

extern
fun{}
randint{n:pos}(int(n)): natLt(n)
implement{}
randint{n}(n) = let
  val x = $STDLIB.random() in $UNSAFE.cast{natLt(n)}(x mod g0i2i(n))
end // end of [randint]

(* ****** ****** *)

extern
fun randint2 (n: int): int
implement
randint2 (n) = let
  val n = g1ofg0 (n) in if n > 0 then randint (n) else 0
end // end of [randint2]

(* ****** ****** *)

extern
fun{}
srandom_with_time((*void*)): void
implement{}
srandom_with_time () = $STDLIB.srandom($UNSAFE.cast{uint}($TIME.time_get()))

(* ****** ****** *)

(* end of [CS320-2014-Spring.hats] *)
