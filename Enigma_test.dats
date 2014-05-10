(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

(* ****** ****** *)

dynload "./Enigma_letter.dats"
dynload "./Enigma_map.dats"
dynload "./Enigma_plugboard.dats"
dynload "./Enigma_reflector.dats"
dynload "./Enigma_rotor.dats"
dynload "./Enigma.dats"

(* ****** ****** *)

implement
main0 () = () where
{
val mch = machine_create()
val () = machine_setup(mch, "ADU")

(* Set plugboard to a random configuration. *)
//val () = plugboard_rand_setup(mch.plugboard)

(*
val () = (println!(); machine_print_rotors(mch))
val () = println!(ltrint2ch(machine_encode_char(mch, 'A' - 'A')))
val () = (println!(); machine_print_rotors(mch))
val () = println!(ltrint2ch(machine_encode_char(mch, 'A' - 'A')))
val () = (println!(); machine_print_rotors(mch))
val () = println!(ltrint2ch(machine_encode_char(mch, 'A' - 'A')))
val () = (println!(); machine_print_rotors(mch))
val () = println!(ltrint2ch(machine_encode_char(mch, 'A' - 'A')))
val () = (println!(); machine_print_rotors(mch))
*)

val str = "THEQUICKBROWNFOXJUMPSOVERTHELAZYDOG"
val plaintext = array0_make_list<char>(string_explode(str))
val ciphertext = array0_make_elt<char>(plaintext.size, 'A')
val deciphertext = array0_make_elt<char>(plaintext.size, 'A')

(* Encrypt plaintext. *)
val _ = array0_iforeach(plaintext,
    lam(i, c) => ciphertext[i] := ltrint2ch(machine_encode_char(mch, c-'A')))

(* Reset rotors to initial positions to decode. *)
val () = machine_setup(mch, "ADU")

(* Decrypt ciphertext. *)
val _ = array0_iforeach(ciphertext,
    lam(i, c) => deciphertext[i] := ltrint2ch(machine_encode_char(mch, c-'A')))

(* Check reversibility. *)
val () = (array0_foreach(plaintext, lam(c) => print!(c)); println!())
val () = (array0_foreach(ciphertext, lam(c) => print!(c)); println!())
val () = (array0_foreach(deciphertext, lam(c) => print!(c)); println!())
val () = machine_print_rotors(mch)
}

(* ****** ****** *)

(* end of [Enigma_test.dats] *)
