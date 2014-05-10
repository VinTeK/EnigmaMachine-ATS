(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

(* ROTOR(current_position, notch_position, input_mapping, output_mapping). *)
datatype rotor = ROTOR of (ref(ltr), ref(ltr), map, map)
assume rotor_type = rotor

(* ****** ****** *)

implement
rotor_get_pos(r: rotor): ref(ltr) = let val ROTOR(i, _, _, _) = r in i end

implement
rotor_get_notch(r: rotor): ref(ltr) = let val ROTOR(_, n, _, _) = r in n end

implement
rotor_get_inmap(r: rotor): map = let val ROTOR(_, _, mi, _) = r in mi end

implement
rotor_get_outmap(r: rotor): map = let val ROTOR(_, _, _, mo) = r in mo end


(* ****** ****** *)

implement
rotor_create() =
    ROTOR(ref<ltr>(i2ltr(0)), ref<ltr>(i2ltr(0)), map_create(), map_create())

(* ****** ****** *)

implement
rotor_setup(r, pos, notch, param) =
    (* Historically accurate mappings of the original rotors! *)
    if      param = "I" then (
	!(r.pos) := pos; !(r.notch) := ch2ltr('R');
	map_setup(r.inmap, "EKMFLGDQVZNTOWYHXUSPAIBRCJ");
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to type I"))
    else if param = "II" then (
	!(r.pos) := pos; !(r.notch) := ch2ltr('F');
	map_setup(r.inmap, "AJDKSIRUXBLHWTMCQGZNPYFVOE");
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to type II"))
    else if param = "III" then (
	!(r.pos) := pos; !(r.notch) := ch2ltr('W');
	map_setup(r.inmap, "BDFHJLCPRTXVZNYEIWGAKMUSQO");
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to type III"))
    else if param = "IV" then (
	!(r.pos) := pos; !(r.notch) := ch2ltr('K');
	map_setup(r.inmap, "ESOVPZJAYQUIRHXLNFTGKDCMWB");
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to type IV"))
    else if param = "V" then (
	!(r.pos) := pos; !(r.notch) := ch2ltr('A');
	map_setup(r.inmap, "VZBRGITYUPSDNHLXAWMJQOFECK");
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to type V"))
    else (
	!(r.pos) := pos; !(r.notch) := notch;
	map_setup(r.inmap, param);
	map_set_outmap(r.inmap, r.outmap);
	println!("setting rotor to ", param))

(* ****** ****** *)

implement
rotor_rand_setup(r) =
    (map_rand_setup(r.inmap); map_set_outmap(r.inmap, r.outmap);
    println!("setting rotor to a random map"))

(* ****** ****** *)

implement
rotor_in_notchpos(r) = eqltr(!(r.pos), !(r.notch))

(* ****** ****** *)

implement
rotor_move(r, c) = !(r.pos) := c

(* ****** ****** *)

implement
rotor_rotate(r) =
    !(r.pos) := addltr(!(r.pos), i2ltr(1))

(* ****** ****** *)

implement
rotor_signal_in(r, shft, c) = let
    val input = subltr(addltr(c, !(r.pos)), shft)
    val output = map_getpair(r.inmap, input)
    (*
    val () = println!("IN_ROTOR:  GIVEN=", ltr2ch(c), " | MAPPING=",
		      ltr2ch(input), "->", ltr2ch(output))
    *)
in output end

implement
rotor_signal_out(r, shft, c) = let
    val input = subltr(addltr(c, !(r.pos)), shft)
    val output = map_getpair(r.outmap, input)
    (*
    val () = println!("OUT_ROTOR: GIVEN=", ltr2ch(c), " | MAPPING=",
		      ltr2ch(input), "->", ltr2ch(output))
    *)
in output end

(* ****** ****** *)

implement
rotor_print(r) = (
    print!("POS=", ltr2ch(!(r.pos)));
    print!(" | NOTCH=", ltr2ch(!(r.notch)));
    print!(" | MAPPING="); map_print(r.inmap);
    println!()
)

(* ****** ****** *)

implement
rotor_print_pos(r) = print!(ltr2ch(!(r.pos)))

(* ****** ****** *)

(* end of [Enigma_rotor.dats] *)
