#!/bin/bash
########################
# Author      norben
#
# License     MIT (See https://github.com/norben/animated-gif-script/blob/master/LICENSE.md)
#
# Date        2015 09 13
########################
# Description
#
# This script :
# - creates an animated gif using imagemagick tools (See http://www.imagemagick.org)
# - from a selected region of the screen (user has to draw a rectangle using the mouse)
# - saves the image in this default folder : ${HOME}/Images/norben_animated_gifs
#######################

# used shell commands : which echo exit rm sed grep cat mkdir awk cd tr date dirname

function print_error {
  echo "$2"
  exit $1
}

cmd_convert=`which convert`
cmd_import=`which import`

images_folder="${HOME}/Images/norben_animated_gifs"
img_test_file="test.gif"

image_name="screen"
image_extension="gif"
default_duration_in_seconds=4
default_frequency_per_second=1

delete_temporary_images="1"

norben_date=`date +"%Y%m%d-%H%M%S"`

declare -a tab_error
tab_error[0]="Success"
tab_error[1]="'convert' executable not found"
tab_error[2]="'import' executable not found"
tab_error[3]="first 'import' command failed"
tab_error[4]="first 'import' return string is invalid"
tab_error[5]="'crop' value is invalid"
tab_error[6]="'impossible to create image folder"
tab_error[10]="'default_duration_in_seconds' isn't an integer"
tab_error[11]="'default_duration_in_seconds' must be greater than 0"
tab_error[20]="'default_frequency_per_second' isn't an integer"
tab_error[21]="'default_duration_in_seconds' must be greater than 0"

if [ ! -x "${cmd_convert}" ]; then print_error "1" "${tab_error[1]}"; fi
if [ ! -x "${cmd_import}" ]; then print_error "2" "${tab_error[2]}"; fi

if [ ! -d "${images_folder}" ]
then
  mkdir -p "${images_folder}"
fi
if [ "$?" != "0" ]; then print_error "6" "${tab_error[6]}"; fi
cd "${images_folder}"

integer_check1=`echo ${default_duration_in_seconds} | grep '^[0-9]\+$'`
if [ "$?" != "0" ]; then print_error "10" "${tab_error[10]}"; fi
if [ ! "${default_duration_in_seconds}" -gt 0 ]; then print_error "11" "${tab_error[11]}"; fi

integer_check2=`echo ${default_frequency_per_second} | grep '^[0-9]\+$'`
if [ "$?" != "0" ]; then print_error "20" "${tab_error[20]}"; fi
if [ ! "${default_frequency_per_second}" -gt 0 ]; then print_error "21" "${tab_error[21]}"; fi

res_import_get_crop=`"${cmd_import}" "${img_test_file}" -verbose 2>&1`
if [ "$?" != "0" ]; then print_error "3" "${tab_error[3]}"; fi

res_import_get_crop_check=`echo "${res_import_get_crop}" | grep "^${img_test_file} PS [0-9]\+x[0-9]\+ [0-9]\+x[0-9]\++[0-9]\++[0-9]\+ .*"`
if [ "$?" != "0" ]; then print_error "4" "${tab_error[4]}"; fi

crop=`echo "${res_import_get_crop}" | sed "s/^${img_test_file} PS \([0-9]\+\)x\([0-9]\+\) [0-9]\+x[0-9]\++\([0-9]\+\)+\([0-9]\+\) .*/\1x\2+\3+\4/"`
crop_check=`echo ${crop} | grep "^[0-9]\+x[0-9]\++[0-9]\++[0-9]\+$"`
if [ "$?" != "0" ]; then print_error "5" "${tab_error[5]}"; fi

image_extension=`echo "${image_extension}" | tr [a-z] [A-Z]`

images_total=$((${default_duration_in_seconds} * ${default_frequency_per_second}))
for i in $(seq 1 ${images_total})
do
  zero_prefix=""
  zero_to_add=$((${#images_total} - ${#i}))
  if [ ${#i} -lt ${#images_total} ]
  then
    for j in $(seq 1 ${zero_to_add})
    do
      zero_prefix="0${zero_prefix}"
    done
  fi
  image_number="${zero_prefix}${i}"
  image="${image_name}_${norben_date}_${image_number}.${image_extension}"
  "${cmd_import}" -window root -crop "${crop}" -page "+0+0" "${image}"
  sleep `awk "BEGIN { print 1 / ${default_frequency_per_second} }"`
done

"${cmd_convert}" -delay 100 -loop 0 "${image_name}_${norben_date}_*.${image_extension}" "anim_${image_name}_${norben_date}.gif"

if [ ${delete_temporary_images} == "0" ]
then
  rm -f "${image_name}"_"${norben_date}"_*."${image_extension}"
  rm -f "${img_test_file}"
fi

exit 0
