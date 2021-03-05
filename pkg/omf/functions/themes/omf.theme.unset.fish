function omf.theme.unset
  set -l theme_folders {$OMF_CONFIG,$OMF_PATH}/themes
  set -l current_theme (omf.theme.current)

  # Remove autoload paths of current theme.
  if test -n "$current_theme"
    echo "Remove autoload"
    autoload -e $theme_folders/$current_theme{,/functions}
  end

  # Unlink (if symlink) or otherwise rename the fish_prompt.fish file.
  set -l prompt_filename "fish_prompt.fish"
  set -l prompt_path (omf.xdg.config_home)/fish/functions/$prompt_filename
  echo $prompt_path
  if test -e "$prompt_path"
    echo "exists"
    if test -L "$prompt_path"
      echo "symlink"
      unlink "$prompt_path"
    else
      echo "original"
      mv $prompt_path{,.bak}
    end
  end

  # Persist the change
  echo "" > $OMF_CONFIG/theme

  # Reload fish key bindings if reload is available and needed
  echo "reload bindings"
  functions -q __fish_reload_key_bindings
    and test -e $OMF_CONFIG/key_bindings.fish -o -e $OMF_PATH/key_bindings.fish
    and __fish_reload_key_bindings
end
