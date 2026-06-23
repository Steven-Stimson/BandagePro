#!/bin/bash

# Change this variable to point to the BandagePro executable.
bandagepropath="../../build-BandagePro-Desktop_Qt_5_6_0_clang_64bit-Release/BandagePro.app/Contents/MacOS/BandagePro"

# This function tests the exit code, stdout and stderr of a command.
function test_all {
    command=$1
    expected_exit_code=$2
    expected_std_out=$3
    expected_std_err=$4

    $command 1> tmp/std_out 2> tmp/std_err
    exit_code=$?
    std_out="$(echo $(cat tmp/std_out))"
    std_err="$(echo $(cat tmp/std_err))"

    if [ $exit_code == $expected_exit_code ]; then correct_exit_code=true; else correct_exit_code=false; fi
    if [ "$std_out" == "$expected_std_out" ]; then correct_std_out=true; else correct_std_out=false; fi
    if [ "$std_err" == "$expected_std_err" ]; then correct_std_err=true; else correct_std_err=false; fi

    if $correct_exit_code && $correct_std_out && $correct_std_err;
        then echo "PASS: $command";
    else
        echo "FAIL: $command"
        if ! $correct_exit_code; then echo "   expected exit code: $expected_exit_code"; echo "   actual exit code: $exit_code"; fi
        if ! $correct_std_out; then echo "   expected std out: $expected_std_out"; echo "   actual std out: $std_out"; fi
        if ! $correct_std_err; then echo "   expected std err: $expected_std_err"; echo "   actual std err: $std_err"; fi
    fi

    rm tmp/std_out
    rm tmp/std_err
}

# This function only tests the exit code of a command.
function test_exit_code {
    command=$1
    expected_exit_code=$2

    $command 1> tmp/std_out 2> tmp/std_err
    exit_code=$?

    if [ $exit_code == $expected_exit_code ]; then correct_exit_code=true; else correct_exit_code=false; fi

    if $correct_exit_code && $correct_std_out && $correct_std_err;
        then echo "PASS: $command";
    else
        echo "FAIL: $command"
        if ! $correct_exit_code; then echo "   expected exit code: $expected_exit_code"; echo "   actual exit code: $exit_code"; fi
    fi

    rm tmp/std_out
    rm tmp/std_err
}

# This function tests only the width of an image.
function test_image_height {
    image=$1
    height=$2

    size=`convert $image -print "Size: %wx%h\n" /dev/null`

    if [[ $size == *"x$height"* ]]
        then echo "PASS: $size";
    else
        echo "FAIL:"
        echo "   expected height: $height"
        echo "   actual: $size"
    fi
}

# This function tests only the width of an image.
function test_image_width {
    image=$1
    width=$2

    size=`convert $image -print "Size: %wx%h\n" /dev/null`

    if [[ $size == *"$width""x"* ]]
        then echo "PASS: $size";
    else
        echo "FAIL:"
        echo "   expected width: $width"
        echo "   actual: $size"
    fi
}

# This function tests the height and width of an image.
function test_image_width_and_height {
    image=$1
    width=$2
    height=$3
    
    size=`convert $image -print "Size: %wx%h\n" /dev/null`
    expected_size="Size: $width""x""$height"

    if [ "$size" == "$expected_size" ]
        then echo "PASS: $size";
    else
        echo "FAIL:"
        echo "   expected: $expected_size"
        echo "   actual: $size"
    fi
}


# The tmp directory is used to store files that hold stdout and stderr as well as anything else made by the commands.
mkdir tmp

# BandagePro image tests
test_all "$bandagepropath image test.fastg tmp/test.png" 0 "" ""
test_image_height tmp/test.png 1000; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.jpg" 0 "" "";
test_image_height tmp/test.jpg 1000; rm tmp/test.jpg
test_all "$bandagepropath image test.fastg tmp/test.svg" 0 "" ""; rm tmp/test.svg
test_all "$bandagepropath image test.fastg tmp/test.png --height 500" 0 "" ""
test_image_height tmp/test.png 500; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.png --height 50" 0 "" ""
test_image_height tmp/test.png 50; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.png --width 500" 0 "" ""
test_image_width tmp/test.png 500; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.png --width 50" 0 "" ""
test_image_width tmp/test.png 50; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.png  --width 400 --height 500" 0 "" ""
test_image_width_and_height tmp/test.png 400 500; rm tmp/test.png
test_all "$bandagepropath image test.fastg tmp/test.png  --width 500 --height 400" 0 "" ""
test_image_width_and_height tmp/test.png 500 400; rm tmp/test.png
test_all "$bandagepropath image abc.fastg test.png" 1 "" "BandagePro error: abc.fastg does not exist"
test_all "$bandagepropath image test.fastg test.abc" 1 "" "BandagePro error: the output filename must end in .png, .jpg or .svg"
test_all "$bandagepropath image test.csv tmp/test.png" 1 "" "BandagePro error: could not load test.csv"
test_all "$bandagepropath image test.fastg test.png --query abc.fasta" 1 "" "BandagePro error: --query must be followed by a valid filename"

# BandagePro load tests
test_all "$bandagepropath load abc.fastg" 1 "" "BandagePro error: abc.fastg does not exist"
test_all "$bandagepropath load test.fastg --query abc.fasta" 1 "" "BandagePro error: --query must be followed by a valid filename"

# BandagePro help tests
test_exit_code "$bandagepropath --help" 0
test_exit_code "$bandagepropath --helpall" 0
test_exit_code "$bandagepropath --version" 0

# BandagePro incorrect settings tests
test_all "$bandagepropath --abc" 1 "" "BandagePro error: Invalid option: --abc"
test_all "$bandagepropath --scope" 1 "" "BandagePro error: --scope must be followed by entire, aroundnodes, aroundblast or depthrange"
test_all "$bandagepropath --scope abc" 1 "" "BandagePro error: --scope must be followed by entire, aroundnodes, aroundblast or depthrange"
test_all "$bandagepropath --nodes" 1 "" "BandagePro error: --nodes must be followed by a list of node names"
test_all "$bandagepropath --distance" 1 "" "BandagePro error: --distance must be followed by an integer"
test_all "$bandagepropath --distance abc" 1 "" "BandagePro error: --distance must be followed by an integer"
test_all "$bandagepropath --mindepth" 1 "" "BandagePro error: --mindepth must be followed by a number"
test_all "$bandagepropath --mindepth abc" 1 "" "BandagePro error: --mindepth must be followed by a number"
test_all "$bandagepropath --maxdepth" 1 "" "BandagePro error: --maxdepth must be followed by a number"
test_all "$bandagepropath --nodelen" 1 "" "BandagePro error: --nodelen must be followed by a number"
test_all "$bandagepropath --minnodlen" 1 "" "BandagePro error: --minnodlen must be followed by a number"
test_all "$bandagepropath --edgelen" 1 "" "BandagePro error: --edgelen must be followed by a number"
test_all "$bandagepropath --edgewidth" 1 "" "BandagePro error: --edgewidth must be followed by a number"
test_all "$bandagepropath --doubsep" 1 "" "BandagePro error: --doubsep must be followed by a number"
test_all "$bandagepropath --nodseglen" 1 "" "BandagePro error: --nodseglen must be followed by a number"
test_all "$bandagepropath --iter" 1 "" "BandagePro error: --iter must be followed by an integer"
test_all "$bandagepropath --nodewidth" 1 "" "BandagePro error: --nodewidth must be followed by a number"
test_all "$bandagepropath --depwidth" 1 "" "BandagePro error: --depwidth must be followed by a number"
test_all "$bandagepropath --deppower" 1 "" "BandagePro error: --deppower must be followed by a number"
test_all "$bandagepropath --fontsize" 1 "" "BandagePro error: --fontsize must be followed by an integer"
test_all "$bandagepropath --edgecol" 1 "" "BandagePro error: --edgecol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --edgecol abc" 1 "" "BandagePro error: --edgecol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --outcol" 1 "" "BandagePro error: --outcol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --outline" 1 "" "BandagePro error: --outline must be followed by a number"
test_all "$bandagepropath --selcol" 1 "" "BandagePro error: --selcol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --textcol" 1 "" "BandagePro error: --textcol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --toutcol" 1 "" "BandagePro error: --toutcol must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --toutline" 1 "" "BandagePro error: --toutline must be followed by a number"
test_all "$bandagepropath --colour" 1 "" "BandagePro error: --colour must be followed by random, uniform, depth, blastsolid or blastrainbow"
test_all "$bandagepropath --colour abc" 1 "" "BandagePro error: --colour must be followed by random, uniform, depth, blastsolid or blastrainbow"
test_all "$bandagepropath --ransatpos" 1 "" "BandagePro error: --ransatpos must be followed by an integer"
test_all "$bandagepropath --ransatneg" 1 "" "BandagePro error: --ransatneg must be followed by an integer"
test_all "$bandagepropath --ranligpos" 1 "" "BandagePro error: --ranligpos must be followed by an integer"
test_all "$bandagepropath --ranligneg" 1 "" "BandagePro error: --ranligneg must be followed by an integer"
test_all "$bandagepropath --ranopapos" 1 "" "BandagePro error: --ranopapos must be followed by an integer"
test_all "$bandagepropath --ranopaneg" 1 "" "BandagePro error: --ranopaneg must be followed by an integer"
test_all "$bandagepropath --unicolpos" 1 "" "BandagePro error: --unicolpos must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --unicolneg" 1 "" "BandagePro error: --unicolneg must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --unicolspe" 1 "" "BandagePro error: --unicolspe must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --depcollow" 1 "" "BandagePro error: --depcollow must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --depcolhi" 1 "" "BandagePro error: --depcolhi must be followed by a 6-digit hex colour (e.g. #FFB6C1), an 8-digit hex colour (e.g. #7FD2B48C) or a standard colour name (e.g. skyblue)"
test_all "$bandagepropath --depvallow" 1 "" "BandagePro error: --depvallow must be followed by a number"
test_all "$bandagepropath --depvalhi" 1 "" "BandagePro error: --depvalhi must be followed by a number"
test_all "$bandagepropath --query" 1 "" "BandagePro error: A graph must be given (e.g. via BandagePro load) to use the --query option"
test_all "$bandagepropath --blastp" 1 "" "BandagePro error: --blastp must be followed by blastn/tblastn parameters"
test_all "$bandagepropath --alfilter" 1 "" "BandagePro error: --alfilter must be followed by an integer"
test_all "$bandagepropath --qcfilter" 1 "" "BandagePro error: --qcfilter must be followed by a number"
test_all "$bandagepropath --ifilter" 1 "" "BandagePro error: --ifilter must be followed by a number"
test_all "$bandagepropath --evfilter" 1 "" "BandagePro error: --evfilter must be followed by a number in scientific notation"
test_all "$bandagepropath --evfilter abc" 1 "" "BandagePro error: --evfilter must be followed by a number in scientific notation"
test_all "$bandagepropath --evfilter 1" 1 "" "BandagePro error: --evfilter must be followed by a number in scientific notation"
test_all "$bandagepropath --evfilter 1.0" 1 "" "BandagePro error: --evfilter must be followed by a number in scientific notation"
test_all "$bandagepropath --evfilter e1" 1 "" "BandagePro error: --evfilter must be followed by a number in scientific notation"
test_all "$bandagepropath --bsfilter" 1 "" "BandagePro error: --bsfilter must be followed by a number"
test_all "$bandagepropath --pathnodes" 1 "" "BandagePro error: --pathnodes must be followed by an integer"
test_all "$bandagepropath --minpatcov" 1 "" "BandagePro error: --minpatcov must be followed by a number"
test_all "$bandagepropath --minhitcov" 1 "" "BandagePro error: --minhitcov must be followed by a number"
test_all "$bandagepropath --minmeanid" 1 "" "BandagePro error: --minmeanid must be followed by a number"
test_all "$bandagepropath --minpatlen" 1 "" "BandagePro error: --minpatlen must be followed by a number"
test_all "$bandagepropath --maxpatlen" 1 "" "BandagePro error: --maxpatlen must be followed by a number"
test_all "$bandagepropath --minlendis" 1 "" "BandagePro error: --minlendis must be followed by an integer"
test_all "$bandagepropath --maxlendis" 1 "" "BandagePro error: --maxlendis must be followed by an integer"
test_all "$bandagepropath --maxevprod" 1 "" "BandagePro error: --maxevprod must be followed by a number in scientific notation"






rmdir tmp