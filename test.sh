for DIR in `ls -d */`
do
    echo "===== Task:  "$DIR
    cd $DIR
    export FILES='./test_data/in/*'
    for IN in $FILES
    do
	echo "Testing "$IN
	export OUT=`echo $IN | sed 's/in/out/'`
	runhaskell main.hs < $IN | diff - $OUT
    done
    cd - > /dev/null
done
