(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

assume plugboard_type = map

(* ****** ****** *)

implement
plugboard_create() = map_create()

(* ****** ****** *)

implement
plugboard_setup(pb, param) =
    (map_setup(pb, param); println!("setting plugboard to ", param))

(* ****** ****** *)

implement
plugboard_rand_setup(pb) =
    (map_rand_setup(pb); println!("setting plugboard to a random map"))

(* ****** ****** *)

implement
plugboard_encode(pb, shft, c) = let
    val shifted = subltr(c, shft)
    val ret = map_getpair(pb, shifted)
    (*
    val () = println!("PLUGBOARD: GIVEN=", ltr2ch(c), " | MAPPING=",
		      ltr2ch(shifted), "->", ltr2ch(ret))
    *)
in ret end

(* ****** ****** *)

implement
plugboard_print(pb) = (map_print(pb); println!())

(* ****** ****** *) 

(* end of [Enigma_plugboard.dats] *)
