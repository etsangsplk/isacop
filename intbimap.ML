signature INTBIMAP =
sig

type left
type right
type bimap

val    empty : int -> bimap
val   insert : (bimap * left) -> (bimap * right)
val  forward : (bimap * left) -> right option
val backward : (bimap * right) -> left option

end

functor IntBimap (Key : KEY) : INTBIMAP =
struct

structure Tab = Table (Key)

type left = Key.key
type right = int

type bimap = {
  forth : int Tab.table
, back : Key.key option Array.array
, maxIndex : int
}

fun empty size = {forth = Tab.empty, back = Array.array (size, NONE), maxIndex = 1}

fun forward ({forth, ...}, x) = Tab.lookup forth x

fun backward ({back, ...} : bimap, i) = Array.sub (back, i)

local
  fun insertNew ({back = b, maxIndex = m, forth = f}, x) =
    (Array.update (b, m, SOME x); ({forth = Tab.update (x,m) f, back = b, maxIndex = m + 1}, m))
in
  fun insert (bm, x) = case forward (bm, x) of SOME i => (bm, i) | NONE => insertNew (bm, x)
end

end