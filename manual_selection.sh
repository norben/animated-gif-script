#!/bin/bash
########################
# Author      norben
#
# License     MIT (See https://github.com/norben/animated-gif-script/blob/master/LICENSE.md)
#
# Created        2015 09 13
# Last modified  2015 09 14
########################
# Description
#
# manual_selection.sh :
# - creates an animated gif using imagemagick tools (See http://www.imagemagick.org)
# - from a selected region of the screen (user has to draw a rectangle using the mouse)
# - saves the image in the '$images_folder' folder, default = ${HOME}/Images/norben_animated_gifs
########################
# Shell commands
#
# which echo exit rm sed grep cat mkdir awk cd tr date dirname
########################

function usage {
  echo 'Usage : ./manual_selection.sh [-option [value]]...'
  echo ''
  echo '  -cc "<path_to_command_convert>"   : path to to imagemagick convert tool'
  echo '  -ci "<path_to_command_import>"    : path to to imagemagick import tool'
  echo '  -if "<path_to_images_folder>"     : path to the folder where all the images will be saved'
  echo '  -ti "<test_image_file_name>"      : test file complete name (used to determine the selection region)'
  echo '  -is "<image_suffix>"              : image suffix of recorded temporary images'
  echo '  -ie "<image_extension>"           : image type of recorded temporary images'
  echo '  -ds "<duration_in_seconds>"       : duration (in seconds) that the record lasts once a region is selected on the screen'
  echo '  -fs "<frequency_per_second>"      : number of screenshots per second'
  echo '  -df "<delele_temporary_files>"    : "0" to delete temporary images, "1" to keep them'
  echo '  -h                                : prints this help'
  exit 100
}

function print_error {
  echo "${2}"
  exit ${1}
}

function isParameter {
  returnValue="1"
  for item in `echo "-cc -ci -if -ti -is -ie -ds -fs -df -h"`
  do
    if [ "${1}" == "${item}" ]
    then
      returnValue="0"
    fi
  done
  echo ${returnValue}
}

cmd_convert=`which convert`
cmd_import=`which import`

images_folder="${HOME}/Images/norben_animated_gifs"
img_test_file="test.gif"

image_name="screen"
image_extension="gif"
duration_in_seconds="4"
frequency_per_second="1"

delete_temporary_images="1"

while [ "${1}" != "" ]
do
  case "${1}" in
    -cc )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 101; fi
      cmd_convert="${1}"
      ;;
    -ci )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 102; fi
      cmd_import="${1}"
      ;;
    -if )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 103; fi
      images_folder="${1}"
      ;;
    -ti )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 104; fi
      img_test_file="${1}"
      ;;
    -is )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 105; fi
      image_name="${1}"
      ;;
    -ie )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 106; fi
      image_extension="${1}"
      ;;
    -ds )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 107; fi
      duration_in_seconds="${1}"
      ;;
    -fs )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 108; fi
      frequency_per_second="${1}"
      ;;
    -df )
      shift
      if [ "`isParameter "${1}"`" == "0" ]; then echo "missing parameter value" && exit 109; fi
      delete_temporary_images="${1}"
      ;;
    * )
      usage
      ;;
  esac
  shift
done

norben_date=`date +"%Y%m%d-%H%M%S"`

declare -a tab_error
tab_error[0]="Success"
tab_error[1]="'convert' executable not found"
tab_error[2]="'import' executable not found"
tab_error[3]="first 'import' command failed"
tab_error[4]="first 'import' return string is invalid"
tab_error[5]="'crop' value is invalid"
tab_error[6]="'impossible to create image folder"
tab_error[10]="'duration_in_seconds' isn't an integer"
tab_error[11]="'duration_in_seconds' must be greater than 0"
tab_error[20]="'frequency_per_second' isn't an integer"
tab_error[21]="'duration_in_seconds' must be greater than 0"

if [ ! -x "${cmd_convert}" ]; then print_error "1" "${tab_error[1]}"; fi
if [ ! -x "${cmd_import}" ]; then print_error "2" "${tab_error[2]}"; fi

if [ ! -d "${images_folder}" ]
then
  mkdir -p "${images_folder}"
fi
if [ "$?" != "0" ]; then print_error "6" "${tab_error[6]}"; fi
cd "${images_folder}"

integer_check1=`echo ${duration_in_seconds} | grep '^[0-9]\+$'`
if [ "$?" != "0" ]; then print_error "10" "${tab_error[10]}"; fi
if [ ! "${duration_in_seconds}" -gt 0 ]; then print_error "11" "${tab_error[11]}"; fi

integer_check2=`echo ${frequency_per_second} | grep '^[0-9]\+$'`
if [ "$?" != "0" ]; then print_error "20" "${tab_error[20]}"; fi
if [ ! "${frequency_per_second}" -gt 0 ]; then print_error "21" "${tab_error[21]}"; fi

res_import_get_crop=`"${cmd_import}" "${img_test_file}" -verbose 2>&1`
if [ "$?" != "0" ]; then print_error "3" "${tab_error[3]}"; fi

res_import_get_crop_check=`echo "${res_import_get_crop}" | grep "^${img_test_file} PS [0-9]\+x[0-9]\+ [0-9]\+x[0-9]\++[0-9]\++[0-9]\+ .*"`
if [ "$?" != "0" ]; then print_error "4" "${tab_error[4]}"; fi

crop=`echo "${res_import_get_crop}" | sed "s/^${img_test_file} PS \([0-9]\+\)x\([0-9]\+\) [0-9]\+x[0-9]\++\([0-9]\+\)+\([0-9]\+\) .*/\1x\2+\3+\4/"`
crop_check=`echo ${crop} | grep "^[0-9]\+x[0-9]\++[0-9]\++[0-9]\+$"`
if [ "$?" != "0" ]; then print_error "5" "${tab_error[5]}"; fi

image_extension=`echo "${image_extension}" | tr [a-z] [A-Z]`

images_total=$((${duration_in_seconds} * ${frequency_per_second}))
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
  sleep `awk "BEGIN { print 1 / ${frequency_per_second} }"`
done

"${cmd_convert}" -delay 100 -loop 0 "${image_name}_${norben_date}_*.${image_extension}" "anim_${image_name}_${norben_date}.gif"

if [ ${delete_temporary_images} == "0" ]
then
  rm -f "${image_name}"_"${norben_date}"_*."${image_extension}"
  rm -f "${img_test_file}"
fi

exit 0
