function require
  set packages $argv

  # Remove packages which have already been loaded.
  for package in $packages
    if contains -- $package $omf_packages_loaded
      set index (contains -i -- $package $packages)
      set -e packages[$index]
    end
  end

  set function_path {$OMF_PATH,$OMF_CONFIG}/pkg*/$packages/functions
  set completion_path {$OMF_PATH,$OMF_CONFIG}/pkg*/$packages/completions

  # Autoload functions
  test "$function_path"
    and set fish_function_path $fish_function_path[1] \
                               $function_path \
                               $fish_function_path[2..-1]

  # Autoload completions
  test "$complete_path"
    and set fish_complete_path $fish_complete_path[1] \
                               $complete_path \
                               $fish_complete_path[2..-1]

  initialize {$OMF_CONFIG,$OMF_PATH}/pkg*/$packages/init.fish

  set -g omf_packages_loaded $packages $omf_packages_loaded

  return 0
end
