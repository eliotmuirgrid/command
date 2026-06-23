file:list:smart2() {
   local file ext

   for file in "$@"; do
      [[ -z "$file" ]] && continue

      if [[ -e "$file" ]]; then
         echo "$file"
         continue
      fi

      for ext in lua md sh c h cpp json txt yaml yml; do
         if [[ -e "$file.$ext" ]]; then
            echo "$file.$ext"
            continue 2
         fi
      done

      echo "$file.md"
   done
}
