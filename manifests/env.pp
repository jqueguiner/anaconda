# Creates an environment with Anaconda, Python, and Numpy
# To add packages see anaconda::package


define anaconda::env( 
    String $language         = undef,
    String $version          = '3.5',
    String $anaconda_version = '4.2.0',
    String $base_path        = '/opt/anaconda',
    String $exec_timeout     = '300',) {
    anchor{"anaconda::env::${title}::begin":}
    include anaconda



  $conda = "${base_path}/bin/conda"



    case $language {
      'r', 'R'           : { $options = "-c r" }
      'python', 'Python' : { $options = "python=${version}" }
      default:             { $options = "python=${version}" }
    }


    exec { "anaconda_env_${name}":
        command => "$conda create --yes --quiet \
                    --name=${name} anaconda=${anaconda_version} \
                    ${options}",
        creates => "${base_path}/envs/${name}",
        timeout => $exec_timeout,
        require => Class["anaconda::install"],
    }
    
  anchor{"anaconda::env::${title}::end":
    require => Exec["anaconda_env_${name}"],
  }

}
