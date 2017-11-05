FILENAME == ARGV[1] { one[FNR]=$1 }
FILENAME == ARGV[2] { two[FNR]=$1 }
FILENAME == ARGV[3] { three[FNR]=$1 }
FILENAME == ARGV[4] { four[FNR]=$1 }
FILENAME == ARGV[5] { five[FNR]=$1 }

END {
    for (i=1; i<=length(one); i++) {

        print one[i], two[i], three[i], four[i], five[i]
    }
}
