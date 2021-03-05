function omf.theme.current -a part
  test -f $OMF_CONFIG/theme
    and read -l theme < $OMF_CONFIG/theme
    or set -l theme {$OMF_CONFIG,$OMF_PATH}/themes*/default
  
  switch "$part"
    case "name"
      basename "$theme"
    case "dir"
      dir "$theme"
    case "*"
      echo "$theme"
  end
end
