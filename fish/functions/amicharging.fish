function amicharging --wraps=upower\ --show-info\ \(upower\ --enumerate\ \|\ grep\ \'BAT\'\)\ \|\ egrep\ \"state\"\ \|\ awk\ \'\{print\ \$2\}\' --description alias\ amicharging\ upower\ --show-info\ \(upower\ --enumerate\ \|\ grep\ \'BAT\'\)\ \|\ egrep\ \"state\"\ \|\ awk\ \'\{print\ \$2\}\'
  upower --show-info (upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}' $argv
        
end
