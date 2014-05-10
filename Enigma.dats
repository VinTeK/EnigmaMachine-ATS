(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

datatype machine = ENIGMA of (plugboard, array0(rotor), reflector)
assume machine_type = machine

(* ****** ****** *)

implement
machine_get_plugboard(mch: machine): plugboard =
    let val ENIGMA(pb, _, _) = mch in pb end

implement
machine_get_rotors(mch: machine): array0(rotor) =
    let val ENIGMA(_, rs, _) = mch in rs end

implement
machine_get_reflector(mch: machine): reflector =
    let val ENIGMA(_, _, rf) = mch in rf end

(* ****** ****** *)

implement
machine_create () = let
    val pb = plugboard_create()

    val rs = array0_tabulate<rotor>(i2sz(MAX_NROTORS), lam(i) => rotor_create())
    val () = rotor_setup(rs[0], ch2ltr('A'), i2ltr(0), "I")
    val () = rotor_setup(rs[1], ch2ltr('A'), i2ltr(0), "II")
    val () = rotor_setup(rs[2], ch2ltr('A'), i2ltr(0), "III")

    val rf = reflector_create()
    val () = reflector_setup(rf, "B")
in
    ENIGMA(pb, rs, rf)
end

(* ****** ****** *)

implement
machine_setup (mch, param) = let
    (* Ensure param is valid. If param is an empty string, change nothing. *)
    val () = assertloc(length(param) <= MAX_NROTORS)

    val xs = string_explode(param)

    fun aux(i: int, xs: list0(char)): void =
	case+ xs of
	| nil0() => ()
	| cons0(x, xs) => let
	    val rs = mch.rotors
	in
	    (rotor_move(machine_nth_rotor(mch, i), ch2ltr(x)); aux(i+1, xs))
	end

in aux(0, xs) end

(* ****** ****** *)

implement
machine_num_of_rotors(mch) = let val rs = mch.rotors in sz2i(rs.size) end

(* ****** ****** *)
implement
machine_nth_rotor(mch, i) = let val rs = mch.rotors in rs[i] end

(* ****** ****** *)

implement
machine_do_double_step(mch) =
    if machine_num_of_rotors(mch) != 3 then false else let
	val mch_rs = mch.rotors
    in
	(*
	 * I'm not even 100% on how the double-stepping mechanism works!
	 * This is a bit hacky and only works for 3 rotor machines.
	 *)
	eqltr(subltr(!(mch_rs[2].pos), i2ltr(1)), !(mch_rs[2].notch)) &&
	eqltr(addltr(!(mch_rs[1].pos), i2ltr(1)), !(mch_rs[1].notch))
    end

(* ****** ****** *)

implement
machine_rotate_rotors(mch) = let
    val mch_rs = mch.rotors
    val num_rs = machine_num_of_rotors(mch)

    (* Always rotate the last rotor. *)
    val () = rotor_rotate(mch_rs[num_rs-1])

    fun check_rotors(i: int): void =
	if i < 0 then () else
	(* Previous rotor is on a notch so this rotor should rotate. *)
	if rotor_in_notchpos(mch_rs[i+1]) then
	    (rotor_rotate(mch_rs[i]); check_rotors(i-1))
	else ()
in
    if machine_do_double_step(mch) then
	(rotor_rotate(mch_rs[1]); check_rotors(0))
    else check_rotors(num_rs-2)
end

(* ****** ****** *)

implement
machine_enter_rotors(mch, c) = let
    val () = machine_rotate_rotors(mch)

    val rs = mch.rotors
    val num_rs = machine_num_of_rotors(mch)

    fun aux(i: int, c: ltr): ltr =
	if i < 0 then c else
	(* First rotor has no previous rotor to pass a shift amount. *)
	if i = num_rs-1 then aux(i-1, rotor_signal_in(rs[i], i2ltr(0), c))
	else aux(i-1, rotor_signal_in(rs[i], !(rs[i+1].pos), c))
in
    aux(num_rs-1, c)
end

implement
machine_exit_rotors(mch, c) = let
    val rs = mch.rotors
    val num_rs = machine_num_of_rotors(mch)

    fun aux(i: int, c: ltr): ltr =
	if i >= num_rs then c else
	(* Last rotor has no previous rotor to pass a shift amount. *)
	if i = 0 then aux(i+1, rotor_signal_out(rs[i], i2ltr(0), c))
	else aux(i+1, rotor_signal_out(rs[i], !(rs[i-1].pos), c))
in
    aux(0, c)
end

(* ****** ****** *)

implement
machine_encode_char (mch, c) = let
    (*
     * Get components of the machine.
     *)
    val mch_pb = mch.plugboard
    val mch_rs = mch.rotors
    val num_rs = machine_num_of_rotors(mch)
    val mch_rf = mch.reflector

    (*
     * Raw input signal passes through plugboard. No offset to the input is
     * done in this pass.
     *)
    val pb_in = plugboard_encode(mch_pb, i2ltr(0), i2ltr(c))
    (*
     * Signal is entering rotors. In the input pass, find the mapping for a
     * signal: mapping(SIGNAL + cur_rotor.pos - prev_rotor.pos).
     * The 'fast' (right-most) rotor will have no previous rotor to use.
     *)
    val rs_in = machine_enter_rotors(mch, pb_in)
    (*
     * Signal passes through reflector and begins inverse sequence.
     * mapping(SIGNAL - first_rotor.pos).
     *)
    val rf_in = reflector_encode(mch_rf, !(mch_rs[0].pos), rs_in)
    (*
     * Signal is exiting rotors. In the output pass, find the mapping for a
     * signal: mapping(SIGNAL + cur_rotor.pos - prev_rotor.pos).
     * The 'slow' (left-most) rotor will have no previous rotor to use.
     *)
    val rs_out = machine_exit_rotors(mch, rf_in)
    (*
     * Signal passes through plugboard and the sequence is complete.
     * mapping(SIGNAL - last_rotor.pos).
     *)
    val pb_out = plugboard_encode(mch_pb, !(mch_rs[num_rs-1].pos), rs_out)
in
    ltr2i(pb_out)
end

(* ****** ****** *)

implement
machine_print(mch) = let
    (* Print plugboard settings. *)
    val () = print!("PLUGBOARD: ")
    val () = plugboard_print(mch.plugboard)
    val () = println!()
    (* Print rotor(s) settings. *)
    val () = array0_iforeach<rotor>(mch.rotors, lam(i, n) =>
	(print!("ROTOR ", sz2i(i), ": "); rotor_print(n)))
    val () = println!()
    (* Print reflector settings. *)
    val () = print!("REFLECTOR: ")
    val () = reflector_print(mch.reflector)
in end

(* ****** ****** *) 

implement
machine_print_rotors(mch) = let
    val () = print("ROTOR POS: ")
    val () = array0_iforeach<rotor>(mch.rotors, 
	lam(i, n) => (rotor_print_pos(n); print!(" ")))
    val () = println!()
in end

(* end of [Enigma.dats] *)
