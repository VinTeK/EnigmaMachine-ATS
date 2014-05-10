(*
// HX-2014-04:
// an implementation of ENIGMA
*)

(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

#define ATS_PACKNAME "Enigma"

(* ****** ****** *)

(* Army version. *)
#define MAX_NROTORS 3
(* Number of alphabets. *)
#define MAX_NALPHA 26

(* ****** ****** *)

(* ['A'..'Z'] = [0..25] *)
abst@ype letter_type = int
typedef ltr = letter_type

fun ltr2ch (c: ltr): char
fun ltr2i (c: ltr): int
(* ltrint2ch: Returns the ascii char representation of an integer used by
 * the letter_type. *)
fun ltrint2ch (c: int): char
fun ch2ltr (c: char): ltr
fun i2ltr (c: int): ltr
fun eqltr (ltr, ltr): bool
fun addltr (ltr, ltr): ltr
fun subltr (ltr, ltr): ltr

(* ****** ****** *)

abstype map_type = ptr
typedef map = map_type

fun map_create(): map
fun map_setup(map, param: string): void
fun map_rand_setup(map): void
(* map_set_outmap: Sets a given output map to the inverse of an input map. *)
fun map_set_outmap(inmap: map, outmap: map): void
fun map_getpair(map, ltr): ltr
fun map_print(map): void

(* ****** ****** *)

abstype plugboard_type = ptr
typedef plugboard = plugboard_type

fun plugboard_create(): plugboard
fun plugboard_setup(plugboard, param: string): void
fun plugboard_rand_setup(plugboard): void
fun plugboard_encode(plugboard, ltr, ltr): ltr
fun plugboard_print(plugboard): void

(* ****** ****** *)

abstype reflector_type = ptr
typedef reflector = reflector_type

fun reflector_create(): reflector
fun reflector_setup(reflector, param: string): void
fun reflector_rand_setup(reflector): void
fun reflector_encode(reflector, ltr, ltr): ltr
fun reflector_print(reflector): void

(* ****** ****** *)

abstype rotor_type = ptr
typedef rotor = rotor_type

fun rotor_get_pos(rotor): ref(ltr)
fun rotor_get_notch(rotor): ref(ltr)
fun rotor_get_inmap(rotor): map
fun rotor_get_outmap(rotor): map

symintr .pos .notch .inmap .outmap
overload .pos with rotor_get_pos
overload .notch with rotor_get_notch
overload .inmap with rotor_get_inmap
overload .outmap with rotor_get_outmap

fun rotor_create(): rotor
fun rotor_setup(rotor, pos: ltr, notch: ltr, param: string): void
fun rotor_rand_setup(rotor): void
(* rotor_in_notchpos: Returns true if this rotor will cause the its neighbor
 * rotor to step. *)
fun rotor_in_notchpos(rotor): bool
fun rotor_rotate(rotor): void
fun rotor_move(rotor, ltr): void
(* rotor_signal_in: Returns the ltr mapping for on this rotor's input map. *)
fun rotor_signal_in(rotor, ltr, ltr): ltr
(* rotor_signal_out: Returns the ltr mapping for on this rotor's output map. *)
fun rotor_signal_out(rotor, ltr, ltr): ltr
fun rotor_print(rotor): void
fun rotor_print_pos(rotor): void

(* ****** ****** *)

abstype machine_type = ptr
typedef machine = machine_type

fun machine_get_plugboard(machine): plugboard
fun machine_get_rotors(machine): array0(rotor)
fun machine_get_reflector(machine): reflector

symintr .plugboard .rotors .reflector 
overload .plugboard with machine_get_plugboard
overload .rotors with machine_get_rotors
overload .reflector with machine_get_reflector

(* machine_create(): Initial settings for the machine have an unconfigured
 * plugboard, rotors of type I, II, and III, and a reflector of type B. *)
fun machine_create(): machine
fun machine_setup(machine, param: string): void
fun machine_num_of_rotors(machine): int
fun machine_nth_rotor(machine, i: int): rotor
(* machine_do_double_step: Returns true if a rotation will cause the middle
 * rotor to double step! A bit hacky as it will only work if there are
 * strictly THREE rotors--the army version. *)
fun machine_do_double_step(machine): bool
(* machine_rotate_rotors: Rotate the 'fast' rotor in this machine. This is
 * the rotor that changes with each signal input. Rotors will step if the
 * previous rotor's notch is triggered. *)
fun machine_rotate_rotors(machine): void
(* machine_enter_rotors: Return the encoded result of a letter that passes
 * through each rotor from RIGHT to LEFT. *)
fun machine_enter_rotors(machine, ltr): ltr
(* machine_exit_rotors: Return the encoded result of a letter that passes
 * through each rotor from LEFT to RIGHT. *)
fun machine_exit_rotors(machine, ltr): ltr
fun machine_encode_char(machine, c: int): int
fun machine_print(machine): void
fun machine_print_rotors(machine): void

(* ****** ****** *)

(* end of [Enigma.sats] *)
