(* ****** ****** *)

#include "CS320-2014-Spring.hats"
#include "share/atspre_staload.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"

staload "./Enigma.sats"

(* ****** ****** *)

assume map_type = array0(ltr)

(* ****** ****** *)

implement
map_create() =
    array0_tabulate<ltr>(i2sz(MAX_NALPHA), lam(i) => i2ltr(sz2i(i)))

(* ****** ****** *)

implement
map_setup(m, param: string) = let
    (* Ensure param is valid; every element should be mapped! *)
    val () = assertloc(array0_get_size(m) = length(param))

    val xs = string_explode(param)

    fun aux(i: int, xs: list0(char)): void =
	case+ xs of
	| nil0() => ()
	| cons0(x, xs) => (array0_set_at(m,i,ch2ltr(x)); aux(i+1, xs))
in
    aux(0, xs)
end

(* ****** ****** *)

implement
map_rand_setup(m) = let
    val () = srandom_with_time()
    val xs = list0_tabulate<ltr>(MAX_NALPHA, lam(i) => i2ltr(i))

    fun aux(i: int, len: int, xs: list0(ltr)): void =
	case+ xs of
	| nil0() => ()
	| _ => let
	    val randi = randint2(len)
	in
	    (* Add random mapping. *)
	    (array0_set_at(m, i, list0_nth_exn(xs, randi));
	    (* Remove used mapping. *)
	    aux(i+1, len-1, list0_remove_at_exn(xs, randi)))
	end

in aux(0, list0_length(xs), xs) end

(* ****** ****** *)

implement
map_set_outmap(mi, mo) =
    array0_iforeach<ltr>(mi,
	lam(i, c) => (array0_set_at(mo,ltr2i(c),i2ltr(sz2i(i)))))

(* ****** ****** *)

implement
map_getpair(m, c) = array0_get_at(m,ltr2i(c))

(* ****** ****** *)

implement
map_print(m) = let
    val () = array0_iforeach<ltr>(m, lam(i, n) => 
	print!('A'+sz2i(i), "->", ltr2ch(n), " "))
in end

(* ****** ****** *)

(* end of [Enigma_map.dats] *)
