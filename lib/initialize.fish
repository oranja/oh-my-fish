function initialize -d "Initialize a package"
  for init in $argv
    set -l IFS '/'
    echo $init | read -la components

    set package $components[-2]
    set path (printf '/%s' $components[1..-2])
    set bundle $path/bundle

    if test -f $bundle
      while read -l type dependency
        test "$type" = package
          and require "$dependency"
      end < $bundle
    end

    source $init $path
    emit init_$package $path

    set -g omf_packages_loaded $omf_packages_loaded $package
  end
end
