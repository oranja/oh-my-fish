# Set OMF_CONFIG if not set.
if not set -q OMF_CONFIG
  set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME "$HOME/.config"
  set -gx OMF_CONFIG "$XDG_CONFIG_HOME/omf"
end
# Source custom before.init.fish file
source $OMF_CONFIG/before.init.fish ^/dev/null
# Read current theme
read -l theme < $OMF_CONFIG/theme
# Prepare Oh My Fish paths
set -l omf_function_path $OMF_PATH/{lib/{,git}}
set -l omf_package_function_path {$OMF_CONFIG,$OMF_PATH}/{themes*/$theme/{,functions},pkg/*/functions,functions*}
set -l omf_package_complete_path {$OMF_CONFIG,$OMF_PATH}/{themes*/$theme/completions,pkg/*/completions}
# Autoload functions
set fish_function_path $fish_function_path[1] \
                       $omf_package_function_path \
                       $omf_function_path \
                       $fish_function_path[2..-1]
# Autoload completions
set fish_complete_path $fish_complete_path[1] \
                       $omf_package_complete_path \
                       $fish_complete_path[2..-1]
# Do package initialization
initialize {$OMF_CONFIG,$OMF_PATH}/{pkg,theme}/*/init.fish
# Source custom init.fish file
source $OMF_CONFIG/init.fish ^/dev/null
# Backup key bindings
functions -q fish_user_key_bindings
  and functions -c fish_user_key_bindings __original_fish_user_key_bindings
# Override key bindings, calling original if existant
function fish_user_key_bindings
  # Read packages key bindings
  for file in {$OMF_CONFIG,$OMF_PATH}/{pkg,theme}/*/key_bindings.fish
    source $file
  end
  # Read custom key bindings file
  source $OMF_CONFIG/key_bindings.fish ^/dev/null
  # Call original key bindings if existant
  functions -q __original_fish_user_key_bindings
    and __original_fish_user_key_bindings
end
set -g OMF_VERSION "1.1.0-dev"
