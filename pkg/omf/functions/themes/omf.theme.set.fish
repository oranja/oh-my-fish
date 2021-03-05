function omf.theme.set -a target_theme
  if test -d $OMF_CONFIG/theme/$target_theme
    set theme_path $OMF_CONFIG/theme/$target_theme
  else if test -d $OMF_PATH/themes/$target_theme
    set theme_path $OMF_PATH/themes/$target_theme
  else
    return $OMF_INVALID_ARG
  end

  set -l current_theme (omf.theme.current)
  test "$target_theme" = "$current_theme"; and return 0

  set -l prompt_filename "fish_prompt.fish"
  set -l user_functions_path (omf.xdg.config_home)/fish/functions
  mkdir -p "$user_functions_path"

  if not omf.check.fish_prompt
    echo (omf::err)"Conflicting prompt setting."(omf::off)
    echo "Run "(omf::em)"omf doctor"(omf::off)" and fix issues before continuing."
    return $OMF_INVALID_ARG
  end

  omf.theme.unset
  
  set -l theme_paths {$OMF_CONFIG,$OMF_PATH}/themes/$target_theme

  # Replace autoload paths of current theme with the target one
  autoload $theme_paths{,/functions}

  # Find target theme's fish_prompt and link to user function path
  for path in $theme_paths/$prompt_filename
    if test -e $path
      ln -sf $path $user_functions_path/$prompt_filename; and break
    end
  end

  # Reload fish key bindings if reload is available and needed
  functions -q __fish_reload_key_bindings
    and test -e $OMF_CONFIG/key_bindings.fish -o -e $OMF_PATH/key_bindings.fish
    and __fish_reload_key_bindings

  # Load target theme's conf.d files
  for conf in $theme_paths/conf.d/*.fish
    source $conf
  end

  # Persist the changes
  echo "$target_theme" > "$OMF_CONFIG/theme"

  return 0
end
