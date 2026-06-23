path:simplify() {
   local path="$1"
   local -a stack
   local part

   for part in ${(s:/:)path}; do
      case "$part" in
         ""|.) ;;
         ..) (( $#stack )) && stack=("${stack[@]:0:$#stack-1}") ;;
         *) stack+=("$part") ;;
      esac
   done

   printf '/%s\n' "${(j:/:)stack}"
}
