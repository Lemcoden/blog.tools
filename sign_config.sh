#!/bin/bash
		generate_watermark(){
						convert -font FrankfurterMediumStd.otf  -background "rgba(255,255,255,0)" -pointsize 40 -fill "rgba(132,255,0,0.3)"  label:from\ lemcoden.xyz my_label.png
		}

		sign_single_pic(){
					for sign_image  in $@
					do
						echo "		convert $sign_image start"
						composite -compose atop -alpha on  -gravity SouthEast  -geometry +20+20  my_label.png  $sign_image $sign_image
						echo "		convert $sign_image end"
					done
		}		
