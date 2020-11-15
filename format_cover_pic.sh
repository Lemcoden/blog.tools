echo $1
if [ $# != 0 ] 
	then 
	for  image_file in $*  
	do
		convert -resize 500x320 $image_file $image_file
	done
else
	echo "请输入要格式化的图片"
fi

