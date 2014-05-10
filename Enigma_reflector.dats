(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

assume reflector_type = map

(* ****** ****** *)

implement
reflector_create() = map_create()

(* ****** ****** *)

implement
reflector_setup(rf, param) = 
    if      param = "B" then (
	map_setup(rf, "YRUHQSLDPXNGOKMIEBFZCWVJAT");
	println!("setting reflector to type B"))
    else if param = "C" then (
	map_setup(rf, "FVPJIAOYEDRZXWGCTKUQSBNMHL");
	println!("setting reflector to type C"))
    else 
	(map_setup(rf, param);
	println!("setting reflector to ", param))

(* ****** ****** *)

implement
reflector_rand_setup(rf) =
    (map_rand_setup(rf); println!("setting reflector to a random map"))

(* ****** ****** *)

implement
reflector_encode(rf, shft, c) = let
    val shifted = subltr(c, shft)
    val ret = map_getpair(rf, shifted)
    (*
    val () = println!("REFLECTOR: GIVEN=", ltr2ch(c), " | MAPPING=",
		      ltr2ch(shifted), "->", ltr2ch(ret))
    *)
in ret end

(* ****** ****** *)

implement
reflector_print(rf) = (map_print(rf); println!())

(* ****** ****** *) 

(* end of [Enigma_reflector.dats] *)
