#!/bin/bash
sign_watermark_recursive(){
	if [ ! $1 ]
	then
		local current_path=`pwd`
	else
		local current_path=$1
	fi

	echo "current path is $current_path"

	for  file in  `ls $current_path`
	do
		if [ -d $file ]
		then
			echo "$file is a directory"
			sign_watermark_recursive  $file
		else
			echo "	  $file is a file"
			file_suffix=${file##*.}
			echo "		the file type is $file_suffix"
			if [ $file_suffix == "png" -o $file_suffix == "jpg" -o $file_suffix == "webp" -o $file_suffix == "pdf" -o $file_suffix == "jpeg" -o $file_suffix == "gif" ]
			then
				file="$current_path/$file"
				sign_single_pic $file
			else
				echo "		file is the $file_suffix"
			fi
		fi
	done
}

#!/bin/bash
sign_watermark_all(){
	if [ ! $1 ]
	then
		local current_path=`pwd`
	else
		local current_path=$1
	fi

	echo "current path is $current_path"

	for  file in  `ls $current_path`
	do
		if [ -d $file ]
		then
			echo "$file is a directory"
		else
			echo "	  $file is a file"
			file_suffix=${file##*.}
			echo "		the file type is $file_suffix"
			if [ $file_suffix == "png" -o $file_suffix == "jpg" -o $file_suffix == "webp" -o $file_suffix == "pdf" -o $file_suffix == "jpeg" -o $file_suffix == "gif" ]
			then
				file="$current_path/$file"
				sign_single_pic $file
			else
				echo "		file is the $file_suffix"
			fi
		fi
	done
}

read_config_file(){

	config_file="`pwd`/sign_config.sh"
	echo "$config_file"
	if [  -f  $config_file   ]
	then
		read -p '配置文件已存在是否直接读入:是(y)，否(n)'  result
		case $result in
													'y')
														source $config_file
													;;
													'n')
														generate_parameter
													;;
													*)
													echo "判断失败退出"
													;;
			esac
	else
							generate_parameter
	fi


}

generate_parameter(){

		read -p  "请输入水印文字内容
		"  label
		read -p  "请输入文字背景颜色（默认透明,RGBA值）比如：255,0,0,0.5
		"  background
		read -p  "请输入文字颜色（RGBA值）
		"  font_color
		read -p  "请输入文字大小（单位ps）
		"  font_size
		read -p  "请输入水印位置（格式：gravity:xy 例如　SouthWest:+20-20）
		"  gravity
		read -p  "请输入字体文件位置（如果内容为中文，此项必填，否则会乱码）
		"  font_file

		if [  -n "$label"  ]
		 then
			 label=${label// /\\ }
				label=" label:$label"
		fi
		if [   -n "$background"  ]
		then
				background=" -background \"rgba($background)\""
		fi
		if [  	-n "$font_color" ]
		then
				font_color="-fill \"rgba($font_color)\""
		fi
		if [  -n  "$font_size" ]
		then
				font_size="-pointsize $font_size"
		fi
		if [  -n "$gravity"  ]
		then
				gravity="-gravity ${gravity%%:*}  -geometry ${gravity##*:}"
	 	fi
		if [  -n "$font_file"  ]
	 	then
				font_file="-font $font_file"
		fi

		touch sign_config.sh
		chmod u+w  sign_config.sh
		echo  "#!/bin/bash
		generate_watermark(){
						convert $font_file $background $font_size $font_color $label my_label.png
		}

		sign_single_pic(){
					for sign_image  in \$@
					do
						echo \"		convert \$sign_image start\"
						composite -compose atop -alpha on  $gravity  my_label.png  \$sign_image \$sign_image
						echo \"		convert \$sign_image end\"
					done
		}		" >   sign_config.sh

		source sign_config.sh
		chmod u+x sign_config.sh
}


read_config_file
if [ $# != 0 ] 
	then 
	echo "开始生成水印图．．．．"
	generate_watermark
	for  image_file in $*  
	do
		image_file=`pwd`'/'$image_file
		sign_single_pic $image_file
	done
else
	read -p "为指定图片打水印请输入１
	为当前文件夹下所有图片文件打上水印请输入２
	(在２的基础上)递归调用所有文件夹打水印请输入３
	" NUM
	echo "您输入的的值为　$NUM"
	echo "开始生成水印图．．．．"
	generate_watermark
	echo "生成完毕．．．．"

	case $NUM in
				1)
				read  -p "请输入要打入水印的图片路径
				" image_file
				echo "正在为图片打上水印"
				sign_single_pic $image_file
				echo "打印完毕"
				;;
				2)
				echo "正在为图片打上水印"
				sign_watermark_all
				echo "打印完毕"
				;;
				3)
				echo "正在为图片打上水印"
				sign_watermark_recursive
				echo "打印完毕"
				;;
				*)
							echo "请输入正确的打印模式"
			;;
	esac
	echo "正在删除水印图．．．．"
	rm -r my_label.png
	echo "删除完毕"
fi
