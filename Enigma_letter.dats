(*
// HX-2014-04:
// an implementation of ENIGMA
*)

(* ****** ****** *)

#define
ATS_PACKNAME "Enigma"

(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

staload "./Enigma.sats"

(* ****** ****** *)

assume letter_type = int

(* ****** ****** *)

implement ltr2ch (c) = int2char0(ltr2i(c) + char2int0('A'))

(* ****** ****** *)

implement ltr2i (c) = c

(* ****** ****** *)

implement ch2ltr (c) = i2ltr(c - 'A')

(* ****** ****** *)

implement i2ltr (c) = (assertloc (c < MAX_NALPHA); assertloc (c >= 0); c)

(* ****** ****** *)

implement ltrint2ch (c) = int2char0(c + char2int0('A'))

(* ****** ****** *)

implement eqltr (c1, c2) = ltr2i(c1) = ltr2i(c2)

(* ****** ****** *)

implement addltr (c1, c2) = i2ltr((ltr2i(c1) + ltr2i(c2)) mod MAX_NALPHA)

(* ****** ****** *)

implement subltr (c1, c2) = let
    val res = ltr2i(c1) - ltr2i(c2)
in
    (* Operation result is positive. *)
    if res >= 0 then res mod MAX_NALPHA
    (* Operation result is negative. *)
    else i2ltr(MAX_NALPHA - (abs(res) mod MAX_NALPHA))
end

(* ****** ****** *)

(* end of [Enigma_letter.dats] *)

