# blog.tools
#### sign_water 批量添加文字水印的小脚本
本脚本基于imagemagick ，使用前请确保安装了imagemagick
下载安装<a href="https://imagemagick.org/script/download.php">请点这里</a>
使用方法
将sh 文件放到需要处理的图片的同级文件夹下
添加执行权限
```
chmod u+x sign_water.sh
```
然后直接./sign_water.sh 执行　<br/>
中间选项都已给出提示 <br/>
特别说明一下水印位置参数分为Center,South,North,East,West,SouthEast,NorthEast,SouthWest,NorthWest九个，后面的ｘ，ｙ是向左，向上调整的像素值 <br/>
在此给出一个示例和效果 <br/>
```
请输入水印文字内容
		from\ lemcoden.xyz
请输入文字背景颜色（默认透明,RGBA值）比如：255,0,0,0.5
		255,255,255,0
请输入文字颜色（RGBA值）
		132,255,0,0.3
请输入文字大小（单位ps）
		40
请输入水印位置（格式：gravity:xy 例如　SouthWest:+20-20）
		SouthEast:+20+20
请输入字体文件位置（如果内容为中文，此项必填，否则会乱码）
		FrankfurterMediumStd.otf
```
以上配置的效果图
![效果图](http://picture.lemcoden.xyz/node_js_path.png)

当第一次配置完成之后，会在本地生成一个sign_config.sh 文件，保留这个文件，下次运行可以跳过繁琐的水印图定义<br/>
